import { ArrayHelpers } from "../helpers";
import { BoxedHexagon, HexagonType } from "./BoxedHexagon";
import { Point } from "./Point";
import { Rect } from "./Rect";


export type HexagonGridConfig = {
  centerHexagon: BoxedHexagon;
  hexagonType: HexagonType;
  maxRingCount: number;
};

export type HexagonAxialCoordinate = {
  ringRowIndex: number;
  ringColumnIndex: number;
};

export class HexagonGrid {

  centerHexagon: BoxedHexagon;
  hexagonType: HexagonType;
  maxRingCount: number;
  
  constructor(args: HexagonGridConfig) {
    this.hexagonType = args.hexagonType;
    this.maxRingCount = args.maxRingCount;
    
    this.centerHexagon = BoxedHexagon.createPresetHexagon({
      mode: 'relativeToOrigin',
      origin: args.centerHexagon.origin,
      circumRadius: args.centerHexagon.circumRadius,
      hexagonType: args.hexagonType,
    });
  };

  convertAxialCoordinatesToCartesian(args: {
    hexagonCoords: HexagonAxialCoordinate;
    hexagonType: HexagonType;
  }): Point {

    const { hexagonCoords, hexagonType } = args;
    const { ringRowIndex: q, ringColumnIndex: r } = hexagonCoords;
    const R = this.centerHexagon.circumRadius;
  
    let offsetX: number;
    let offsetY: number;

    switch(hexagonType) {
      case 'pointyTopped':
        offsetX = R * 3/2 * q;
        offsetY = R * Math.sqrt(3) * (q + r / 2);
        break;

      case 'flatTopped':
        offsetX = R * Math.sqrt(3) * (q + r / 2);
        offsetY = R * 3/2 * r;
        break;

      default:
        throw new Error('Invalid hexagonType');
    };

    return new Point({ 
      x: this.centerHexagon.origin.x + offsetX, 
      y: this.centerHexagon.origin.y + offsetY 
    });
  };

  // MARK: - Static Methods
  // ----------------------

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