import { Point } from "./Point";

export type AngleUnit = 'radians' | 'degrees';

export type AngleValue = {
  angleUnit: AngleUnit;
  angleValue: number;
};

export class Angle {

  angleUnit: AngleUnit;
  angleRawValue: number;

  constructor(args: AngleValue){
    this.angleUnit = args.angleUnit;
    this.angleRawValue = args.angleValue;
  };

  get asValue(): AngleValue {
    return {
      angleUnit: this.angleUnit,
      angleValue: this.angleRawValue,
    };
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

  computeMidAngle(args: {
    otherAngle: Angle;
    isClockwise: boolean;
  }): Angle {

    const isClockwise = args.isClockwise ?? true;

    const angleLeading = this.normalized.degrees;
    const angleTrailing = args.otherAngle.normalized.degrees;
    
    const delta = angleLeading - angleTrailing;
    
    const needsAdj = isClockwise
      ? delta > 0
      : delta < 0;
    
    // amount to shift ccw direction
    const adj: number = (() => {
      if(needsAdj){
        return 0;
      };
      
      return Math.abs(delta) / 2;
    })();

    const angleMidDeg: number = (() => {
      if (adj == 0){
        return (angleLeading + angleTrailing) / 2;
      };
      
      // adjust by shifting counter clockwise
      const angleLeadingShifted = new Angle({ 
        angleUnit: 'degrees',  
        angleValue: angleLeading + adj,
      });

      const angleTrailingShifted = new Angle({ 
        angleUnit: 'degrees',  
        angleValue: angleTrailing + adj,
      });

      // normalized to 0...360
      let angleLeadingNormalized = angleLeadingShifted.normalized.degrees;
      let angleTrailingNormalized = angleTrailingShifted.normalized.degrees;
      
      let angleMidShifted = (angleLeadingNormalized + angleTrailingNormalized) / 2;
      
      // undo shifting
      return angleMidShifted - adj;
    })();
    
    return new Angle({
      angleUnit: 'degrees',
      angleValue: angleMidDeg,
    });
  };
};
