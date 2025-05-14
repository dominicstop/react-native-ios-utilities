import { BoxedHexagon, HexagonType } from "./BoxedHexagon";
import { Point } from "./Point";


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
};