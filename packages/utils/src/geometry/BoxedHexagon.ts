import { Rect } from "./Rect";
import { Angle } from "./Angle";
import { BoxedCircle } from "./BoxedCircle";
import { Point } from "./Point";
import { Line } from "./Line";


export type BoxedHexagonValue = {
  circumRadius: number;
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

  constructor(args: BoxedHexagonValue){
    this.circumRadius = args.circumRadius;

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

    let currentAngle = 0;
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

  static centerHexagons(args: {
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
};

