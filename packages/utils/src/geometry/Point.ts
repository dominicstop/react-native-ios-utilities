import { InterpolationHelpers } from "../helpers";
import { Line } from "./Line";
import { Rect } from "./Rect";

export type PointValue = {
  x: number;
  y: number;
};

export class Point {

  x: number;
  y: number;

  constructor(args: PointValue){
    this.x =  args.x;
    this.y =  args.y;
  };

  get asValue(): PointValue {
    return {
      x: this.x,
      y: this.y,
    };
  };

  createLine(otherPoint: Point): Line {
    return new Line({ 
      startPoint: this, 
      endPoint:  otherPoint
    });
  };
  
  getDistance(otherPoint: Point): number {
    const line = this.createLine(otherPoint);
    return line.distance;
  };

  getDelta(otherPoint: Point): Point {
    return new Point({
      x: this.x - otherPoint.x,
      y: this.y - otherPoint.y,
    });
  };

  getSum(...otherPoints: Array<Point>): Point {
    return Point.sumOfAllPoints(this, ...otherPoints);
  };

  static get zero(): Point {
    return new Point({ x: 0, y: 0 });
  }; 

  static lerp(
    valueStart: Point,
    valueEnd: Point,
    percent: number
  ): Point {

    const nextX = InterpolationHelpers.lerp(
      valueStart.x,
      valueEnd.x,
      percent
    );

    const nextY = InterpolationHelpers.lerp(
      valueStart.y,
      valueEnd.y,
      percent
    );

    return new Point({
      x: nextX, 
      y: nextY
    });
  };

  static getBoundingBoxForPoints(points: Array<Point>): Rect {
    const valuesX = points.map(point => point.x);
    const valuesY = points.map(point => point.y);

    const sortedValuesX = valuesX.sort((a, b) => a - b);
    const sortedValuesY = valuesY.sort((a, b) => a - b);
    
    const minX = sortedValuesX[0] ?? 0;
    const maxX = sortedValuesX[valuesX.length - 1] ?? 0;

    const minY = sortedValuesY[0] ?? 0;
    const maxY = sortedValuesY[valuesY.length - 1] ?? 0;

    return new Rect({
      mode: 'corners',
      minX,
      maxX,
      minY,
      maxY,
    });
  };

  static translatePoints(args: {
    points: Array<Point>;
    dx: number; 
    dy: number;
  }): Array<Point> {
    const boundingBox = this.getBoundingBoxForPoints(args.points);

    // calc the translation for the derived bounding box
    const translatedOrigin = new Point({
      x: boundingBox.origin.x + args.dx,
      y: boundingBox.origin.y + args.dy
    });

    // adj each point by translation
    return args.points.map(point => {
      const adjX = translatedOrigin.x - boundingBox.origin.x;
      const adjY = translatedOrigin.y - boundingBox.origin.y;

      return new Point({
        x: point.x + adjX,
        y: point.y + adjY
      });
    });
  };

  static sumOfAllPoints(...points: Array<Point>){
    let sumX = 0;
    let sumY = 0;
    
    for (const point of points) {
      sumX += point.x;
      sumY += point.y;
    };

    return new Point({ x: sumX, y: sumY });
  };
};