import { Point, PointValue } from "./Point";
import { SizeValue } from "./Size";

export type RectValue = {
  origin: PointValue;
  size: SizeValue;
};

export type RectCorners = {
  minX: number;
  minY: number;
  maxX: number;
  maxY: number;
};

export type RectInit = (
  RectValue & {
    mode: 'originAndSize';
  }
) | (
  RectCorners & {
    mode: 'corners';
  }
);

export class Rect {
  origin: Point;
  size: SizeValue;

  constructor(args: RectInit){
    switch (args.mode) {
      case 'originAndSize':
        this.origin = new Point(args.origin);
        this.size = args.size;
        break;

      case 'corners':
        this.origin = new Point({ 
          x: args.minX, 
          y: args.minY  
        });

        this.size = { 
          width: args.maxX - args.minX, 
          height: args.maxY - args.minY
        };
        break;
    
      default:
        this.origin = Point.zero;
        this.size = { width: 0, height: 0 };
        break;
    };
  };


  // MARK: Getter + Setter
  // ---------------------

  get minX(): number {
    return this.origin.x;
  };

  set minX(value: number) {
    this.origin.x = value;
  };

  get minY(): number {
    return this.origin.y;
  };
  
  set minY(value: number) {
    this.origin.y = value;
  };

  get midX(): number {
    return this.origin.x + (this.size.width / 2);
  };
  
  set midX(value: number) {
    this.origin.x = value - (this.width / 2);
  };

  get midY(): number {
    return this.origin.y + (this.size.height / 2);
  };
  
  set midY(value: number) {
    this.origin.y = value - (this.height / 2);
  };
  
  get maxX(): number {
    return this.origin.x + this.size.width;
  };

  set maxX(value: number) {
    this.origin.x = value - this.width;
  };

  get maxY(): number {
    return this.origin.y + this.size.height;
  };
  
  set maxY(value: number) {
    this.origin.y = value - this.height;
  }
  
  // MARK: Computed Properties
  // -------------------------

  get asValue(): RectValue {
    return {
      origin: this.origin,
      size: this.size,
    };
  };

  get cornerPoints(): RectCorners {
    return {
      minX: this.minX,
      minY: this.minY,
      maxX: this.maxX,
      maxY: this.maxY,
    };
  };

  get centerPoint(): Point {
    return new Point({
        x: this.midX, 
        y: this.midY 
    });
  };

  get topMidPoint(): Point {
    return new Point({
      x: this.midX, 
      y: this.minY 
    });
  };

  get bottomMidPoint(): Point {
    return new Point({
      x: this.midX, 
      y: this.maxY
    });
  };

  get leftMidPoint(): Point {
    return new Point({
      x: this.minX, 
      y: this.midY 
    });
  };

  get rightMidPoint(): Point {
    return new Point({
      x: this.maxX, 
      y: this.midY 
    });
  };

  get topLeftPoint(): Point {
    return new Point({
      x: this.minX, 
      y: this.minY
    });
  };

  get topRightPoint(): Point {
    return new Point({
      x: this.maxX, 
      y: this.minY
    });
  }

  get bottomLeftPoint(): Point {
    return new Point({
      x: this.minX, 
      y: this.maxY
    });
  }

  get bottomRightPoint(): Point {
    return new Point({
      x: this.maxX, 
      y: this.maxY
    });
  };

  get width(): number {
    return this.size.width;
  };

  get height(): number {
    return this.size.height;
  };

  get isNaN(): boolean {
    return (
         Number.isNaN(this.origin.x)
      || Number.isNaN(this.origin.y)
      || Number.isNaN(this.size.width)
      || Number.isNaN(this.size.height)
    );
  };

  // MARK: Methods
  // -------------

  setPointCenter(newCenterPoint: Point){
    const newX = newCenterPoint.x - (this.width / 2);
    const newY = newCenterPoint.y - (this.height / 2);

    this.origin.x = newX;
    this.origin.y = newY;
  };

  applyScaleToNewSize(newSize: SizeValue){
    const center = this.centerPoint;

    const newX = center.x - (newSize.width / 2);
    const newY = center.y - (newSize.height / 2);

    this.origin.x = newX;
    this.origin.y = newY;
    this.size = newSize;
  };

  applyScaleByFactor(
    widthScaleFactor: number,
    heightScaleFactor: number
  ){

    const newWidth = this.width * widthScaleFactor;
    const newHeight = this.height * heightScaleFactor;
    
    const newSize: SizeValue = {
      width: newWidth, 
      height: newHeight
    };

    this.applyScaleToNewSize(newSize);
  };
};
