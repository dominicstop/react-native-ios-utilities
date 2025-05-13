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

  get minX(): number {
    return this.origin.x;
  };

  get midX(): number {
    return this.origin.x + (this.size.width / 2);
  };

  get maxX(): number {
    return this.origin.x + this.size.width;
  };

  get minY(): number {
    return this.origin.y;
  };

  get midY(): number {
    return this.origin.y + (this.size.height / 2);
  };

  get maxY(): number {
    return this.origin.y + this.size.height;
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

  adjustPoint(adjConfig: {
    mode: 'topLeft';
    minX?: number;
    minY?: number;
  } | {
    mode: 'center';
    midX?: number;
    midY?: number;
  } | {
    mode: 'bottomRight'
    maxX?: number;
    maxY?: number;
  } | {
    mode: 'topRight';
    maxX?: number;
    minY?: number;
  } | {
    mode: 'bottomLeft';
    minX?: number;
    maxY?: number;
  }){
    let newX: number; 
    let newY: number;

    switch(adjConfig.mode){
      case 'topLeft':
        if(adjConfig.minX == null && adjConfig.minY == null) {
          return;
        };

        this.origin.x = adjConfig.minX ?? this.minX;
        this.origin.y = adjConfig.minY ?? this.minY;
        break;
      
      case 'center':
        if(adjConfig.midX == null && adjConfig.midY == null) {
          return;
        };

        newX = (() => {
          if(adjConfig.midX == null){
            return this.midX;
          };

          return adjConfig.midX - (this.width / 2);
        })();

        newY = (() => {
          if(adjConfig.midY == null){
            return this.midY;
          };

          return adjConfig.midY - (this.height / 2);
        })();

        this.origin.x = newX;
        this.origin.y = newY;
        break;

      case 'bottomRight':
        if(adjConfig.maxX == null && adjConfig.maxY == null) {
          return;
        };

        newX = (() => {
          if(adjConfig.maxX == null){
            return this.maxX;
          };

          return adjConfig.maxX - this.width;
        })();

        newY = (() => {
          if(adjConfig.maxY == null){
            return this.maxY;
          };

          return adjConfig.maxY - this.height;
        })();

        this.origin.x = newX;
        this.origin.y = newY;
        break;
      
      // Recursive
      case 'topRight':
        this.adjustPoint({ 
          mode: 'bottomRight', 
          maxX: adjConfig.maxX,
        });

        this.adjustPoint({ 
          mode: 'topLeft', 
          minY: adjConfig.minY
        });
        break;
      
      // Recursive
      case 'bottomLeft':
        this.adjustPoint({ 
          mode: 'topLeft', 
          minX: adjConfig.minX,
        });

        this.adjustPoint({ 
          mode: 'bottomRight', 
          maxY: adjConfig.maxY,
        });
    };
  };

  setPointCenter(newCenterPoint: Point){
    const newX = newCenterPoint.x - (this.width / 2);
    const newY = newCenterPoint.y - (this.height / 2);

    this.origin.x = newX;
    this.origin.y = newY;
  };

  applyScaleToNewSize(newSize: SizeValue){
    let center = this.centerPoint;

    let newX = center.x - (newSize.width / 2);
    let newY = center.y - (newSize.height / 2);

    this.origin.x = newX;
    this.origin.y = newY;
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
