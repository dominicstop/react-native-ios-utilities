import { Rect } from "./Rect";
import { Angle, AngleValue } from "./Angle";
import { BoxedCircle } from "./BoxedCircle";
import { Point } from "./Point";
import { Line } from "./Line";

import { ArrayHelpers } from "../helpers";


export type BoxedHexagonValue = {
  circumRadius: number;
  startAngleOffset?: AngleValue;
} & ({
  mode: 'relativeToOrigin';
  origin: Point;
} | {
  mode: 'relativeToCenter';
  center: Point;
});

export class BoxedHexagon {

  origin: Point;
  circumRadius: number;
  startAngleOffset: Angle;

  constructor(args: BoxedHexagonValue){
    this.circumRadius = args.circumRadius;

    const angleValue = args.startAngleOffset ?? {
      angleUnit: 'degrees',
      angleValue: 0,
    };

    this.startAngleOffset = new Angle(angleValue);

    this.origin = (() => {
      switch(args.mode){
        case 'relativeToCenter':
          const originX = args.center.x - args.circumRadius;
          const originY = args.center.y - args.circumRadius;

          return new Point({  
            x: originX,
            y: originY,
          });

        case 'relativeToOrigin':
          return new Point({  
            x: args.origin.x,
            y: args.origin.y,
          });
      };
    })();
  };

  // MARK: Getters
  // -------------

  // distance between two adjacent points
  get sideLength(): number {
    return this.circumRadius;
  };

  get perimeter(): number {
    return this.circumRadius * 6;
  };

  get boundingRect(): Rect {
    return new Rect({
      mode: 'originAndSize',
      origin: this.origin,
      size: {
        height: this.circumRadius * 2,
        width: this.circumRadius * 2,
      },
    });
  };

  get circumCircle(): BoxedCircle {
    return new BoxedCircle({
      mode: 'relativeToCenter',
      center: this.boundingRect.centerPoint,
      radius: this.circumRadius,
    });
  };

  get angles(): Array<Angle> {
    const angles: Array<Angle> = [];
    const minAngle = 360 / 6;

    let currentAngle = this.startAngleOffset.degrees;
    for(let i = 0; i < 6; i ++){
      currentAngle += minAngle;

      const newAngle = new Angle({ 
        angleUnit: 'degrees', 
        angleValue: currentAngle
      });

      angles.push(newAngle);
    };

    return angles;
  };

  get cornerPoints(): Array<Point> {
    const centerPoint = this.circumCircle.centerPoint;

    return this.angles.map((angleItem) => (
      angleItem.getPointAlongCircle({
        radius: this.circumRadius,
        centerPoint,
        isClockwise: false,
      })
    ));
  };

  get edgeLines(): Array<Line> {
    const cornerPoints = this.cornerPoints;

    let lines: Array<Line> = [];
    
    for (let index = 0; index < cornerPoints.length; index++) {
      const nextIndex = (index + 1) % cornerPoints.length;
      
      const pointCurrent = cornerPoints[index];
      const pointNext = cornerPoints[nextIndex];

      const line = new Line({
        startPoint: pointCurrent,
        endPoint: pointNext,
      });
      
      lines.push(line);
    }

    return lines;
  };

  get inRadius(): number {
    return this.circumRadius * Math.sqrt(3) / 2;
  };

  get apothem(): number {
    return this.inRadius;
  };

  get inCircle(): BoxedCircle {
    
    const inRadius = this.inRadius;
    
    return new BoxedCircle({
      mode: 'relativeToCenter',
      center: this.boundingRect.centerPoint,
      radius: inRadius,
    });
  };
  
  // MARK: Methods
  // -------------

  tileAlongsideEdge(args: {
    edgeLine: Line;
    extraPositionOffset?: number;
  }): BoxedHexagon {
    const extraPositionOffset = args.extraPositionOffset ?? 0;
    const centerPoint = this.boundingRect.centerPoint;

    const apothemLine = new Line({
      startPoint: centerPoint,
      endPoint: args.edgeLine.midPoint,
    });

    const apothemDistance = apothemLine.distance * 2;
    
    const { stopPoint: nextCenterPoint } = 
      apothemLine.traverseByDistance(apothemDistance + extraPositionOffset);

    return new BoxedHexagon({
      mode: 'relativeToCenter',
      center: nextCenterPoint,
      circumRadius: this.circumRadius,
    });
  };

  static recenterHexagonsRelativeToPoint(args: {
    hexagons: Array<BoxedHexagon>;
    centerPoint: Point;
  }){

    const allPoints = args.hexagons.reduce<Point[]>(
      (acc, curr) => {
        acc.push(...curr.cornerPoints);
        return acc;
      },
      []
    );

    const boundingBox = Point.getBoundingBoxForPoints(allPoints);

    const currentCenter = boundingBox.centerPoint;
    const pointAdj = currentCenter.getDelta(args.centerPoint);

    args.hexagons.forEach(hexagon => {
      const adjX = hexagon.origin.x - pointAdj.x;
      const adjY = hexagon.origin.y - pointAdj.y;

      hexagon.origin = new Point({
        x: adjX,
        y: adjY,
      });
    });
  };
  
  static computeHexagonsForFlowerArrangment(args: {
    circumRadius: number;
    centerPoint: Point;
    extraPositionOffset?: number;
    startEdgeOffset?: number;
  }): {
    centerHexagon: BoxedHexagon;
    outerHexagonRing: Array<BoxedHexagon>;
    boundingBox: Rect;
  } {
    const startEdgeOffset = args.startEdgeOffset ?? 0;

    const centerHexagon = new BoxedHexagon({
      center: args.centerPoint,
      circumRadius: args.circumRadius,
      mode: 'relativeToCenter',
    });
  
    const centerHexagonEdgesRaw = centerHexagon.edgeLines;
    const centerHexagonEdges = ArrayHelpers.copyArrayWithCyclicOffset(
      /* sourceArray: */ centerHexagonEdgesRaw,
      /* offset:      */ startEdgeOffset
    );
  
    const outerHexagonRing = centerHexagonEdges.map((edgeLine) => (
      centerHexagon.tileAlongsideEdge({
        edgeLine, 
        extraPositionOffset: args.extraPositionOffset,
      })
    ));

    const hexagons = [centerHexagon, ...outerHexagonRing];
    const allPoints: Array<Point> = hexagons.reduce(
      (acc, curr) => {
        acc.push(...curr.cornerPoints);
        return acc;
      },
      [...centerHexagon.cornerPoints]
    );

    const boundingBox = Point.getBoundingBoxForPoints(allPoints);

    return {
      centerHexagon,
      outerHexagonRing,
      boundingBox,
    };
  };

  static computeHexagonsForTriangleArrangement(args: {
    circumRadius: number;
    centerPoint: Point;
    extraPositionOffset?: number;
    startEdgeOffset?: number;
  }): {
    hexagons: Array<BoxedHexagon>;
    boundingBox: Rect;
  } {

    const startEdgeOffset = args.startEdgeOffset ?? 0;

    const firstHexagon = new BoxedHexagon({
      center: args.centerPoint,
      circumRadius: args.circumRadius,
      mode: 'relativeToCenter',
    });

    const edgeLinesRaw = firstHexagon.edgeLines;
    const edgeLines = ArrayHelpers.copyArrayWithCyclicOffset(
      /* sourceArray: */ edgeLinesRaw,
      /* offset:      */ startEdgeOffset
    );

    const secondHexagon = firstHexagon.tileAlongsideEdge({
      edgeLine: edgeLines[0]!, 
      extraPositionOffset: args.extraPositionOffset,
    });

    const thirdHexagon = firstHexagon.tileAlongsideEdge({
      edgeLine: edgeLines[1]!, 
      extraPositionOffset: args.extraPositionOffset,
    });

    const hexagons = [
      firstHexagon,
      secondHexagon,
      thirdHexagon,
    ];

    const allPoints: Array<Point> = [
      ...firstHexagon.cornerPoints,
      ...secondHexagon.cornerPoints,
      ...thirdHexagon.cornerPoints,
    ];

    const boundingBox = Point.getBoundingBoxForPoints(allPoints);

    BoxedHexagon.recenterHexagonsRelativeToPoint({
      hexagons,
      centerPoint: args.centerPoint,
    });

    return { hexagons, boundingBox };
  };

  static computeHexagonsForTriangleAndFlowerArrangement(args: {
    hexagonCount: number;
    circumRadius: number;
    centerPoint: Point;
    extraPositionOffset?: number;
  }): {
    hexagons: Array<BoxedHexagon>;
    boundingBox: Rect;
  }{
    if(args.hexagonCount == 1) {
      const hexagon = new BoxedHexagon({
        mode: 'relativeToCenter',
        center: args.centerPoint,
        circumRadius: args.circumRadius,
      });

      return ({
        hexagons: [hexagon],
        boundingBox: hexagon.boundingRect,
      });
    };

    if(args.hexagonCount <= 3){
      const startEdgeOffset = args.hexagonCount == 2 ? 1 : 0; 
      const shouldReCenter = args.hexagonCount == 2;

      const hexagonsToRemoveCount = 3 - args.hexagonCount;

      const hexagonGroup = this.computeHexagonsForTriangleArrangement({
        ...args,
        startEdgeOffset,
      });

      if(hexagonsToRemoveCount > 0){
        hexagonGroup.hexagons.splice(-hexagonsToRemoveCount);
      };

      if(shouldReCenter){
        BoxedHexagon.recenterHexagonsRelativeToPoint({
          hexagons: hexagonGroup.hexagons,
          centerPoint: args.centerPoint,
        });
      };

      return ({
        hexagons: hexagonGroup.hexagons,
        boundingBox: hexagonGroup.boundingBox,
      });

    } else if(args.hexagonCount <= 7){
      const startEdgeOffset = 
        args.hexagonCount == 5 || args.hexagonCount == 6 ? 1 : 0;

      const shouldReCenter = args.hexagonCount == 4;
      const hexagonsToRemoveCount = 7 - args.hexagonCount;

      const hexagonGroup = this.computeHexagonsForFlowerArrangment({
        ...args,
        startEdgeOffset,
      });

      const hexagons = [
        hexagonGroup.centerHexagon, 
        ...hexagonGroup.outerHexagonRing
      ];

      if(hexagonsToRemoveCount > 0){
        hexagons.splice(-hexagonsToRemoveCount);
      };

      if(shouldReCenter){
        BoxedHexagon.recenterHexagonsRelativeToPoint({
          hexagons,
          centerPoint: args.centerPoint,
        });
      };

      return {
        hexagons,
        boundingBox: hexagonGroup.boundingBox
      };
    };

    throw new Error("Hexagon count > 6 not supported");
  };
};

