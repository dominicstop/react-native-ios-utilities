import { Angle } from "./Angle";
import { Point } from "./Point";
import { Rect } from "./Rect";

export type BoxedCircleValue = {
  mode: 'relativeToOrigin';
  origin: Point;
  radius: number;
} | {
  mode: 'relativeToCenter';
  center: Point;
  radius: number;
};

export class BoxedCircle {
  origin: Point;
  radius: number;

  constructor(args: BoxedCircleValue){
    this.radius = args.radius;
    
    switch(args.mode) {
      case 'relativeToOrigin':
        this.origin = args.origin;
        break;

      case 'relativeToCenter':
        const originX = args.center.x - args.radius;
        const originY = args.center.y - args.radius;

        this.origin = new Point({ 
          x: originX, 
          y: originY
        });
        break;
    };
  };

  get diameter(): number {
    return this.radius * 2;
  };

  get centerPoint(): Point {
    return new Point({
      x: this.origin.x + this.radius,
      y: this.origin.y + this.radius,
    });
  };

  get enclosingRect(): Rect {
    const diameter = this.diameter;

    return new Rect({
      mode: 'originAndSize',
      origin: this.origin,
      size: {
        width: diameter,
        height: diameter,
      },
    });
  };

  pointAlongPath(angle: Angle): Point {
    return angle.getPointAlongCircle({
      centerPoint: this.centerPoint,
      radius: this.radius,
      isClockwise: false,
    });
  };
};