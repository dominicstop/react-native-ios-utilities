import { Point } from "./Point";

export type AngleUnit = 'radians' | 'degrees';

export type AngleConfig = {
  angleUnit: AngleUnit;
  angleValue: number;
};

export class Angle {

  angleUnit!: AngleUnit;
  angleRawValue!: number;

  constructor(args: AngleConfig){
    this.angleUnit = args.angleUnit;
    this.angleRawValue = args.angleValue;
  };

  get radians(): number {
    switch(this.angleUnit){
      case 'degrees':
        return this.angleRawValue * (Math.PI / 180);

      case 'radians':
        return this.angleRawValue
    };
  };

  get degrees(): number {
    switch(this.angleUnit){
      case 'degrees':
        return this.angleRawValue;

      case 'radians':
        return this.angleRawValue * (180 / Math.PI);
    };
  };

  get normalized(): Angle {
    const normalizedDegrees = this.degrees % 360;

    const adj = (() => {
      if(normalizedDegrees < 0) {
        return 360;
      };

      if(normalizedDegrees > 360) {
        return -360;
      };

      return 0;
    })();

    const normalizedDegreesAdj = normalizedDegrees + adj;

    return new Angle({ 
      angleUnit: 'degrees', 
      angleValue:  normalizedDegreesAdj,
    });
  };

  get isZero(): boolean {
    return this.angleRawValue == 0;
  };

  getPointAlongCircle(args: {
    radius: number;
    centerPoint: Point;
    isClockwise: boolean;
  }): Point {

    const angleRadians = this.radians;
    const adjustedAngle = args.isClockwise ? -angleRadians : angleRadians;

    /// cw: `x = r * cos(angle)`, `y = r * sin(angle)`
    const x = args.centerPoint.x + args.radius * Math.cos(adjustedAngle);
    const y = args.centerPoint.y + args.radius * Math.sin(adjustedAngle);

    return new Point({x, y});
  };
};
