import { Point } from "./Point";


export type LineValue = {
  startPoint: Point;
  endPoint: Point;
};

export class Line {

  startPoint: Point;
  endPoint: Point;
  
  constructor(args: LineValue){
    this.startPoint = args.startPoint;
    this.endPoint = args.endPoint;
  };
  
  get distance(): number {
    const deltaX = this.endPoint.x - this.startPoint.x;
    const deltaY = this.endPoint.y - this.startPoint.y;

    return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
  };

  get midPoint(): Point {
    const midX = (this.endPoint.x + this.startPoint.x) / 2;
    const midY = (this.endPoint.y + this.startPoint.y) / 2;

    return new Point({ x: midX, y: midY });
  };
  
  get slope(): number {
    const deltaX = this.startPoint.x - this.endPoint.x;
    const deltaY = this.startPoint.y - this.endPoint.y;

    return deltaY / deltaX;
  };

  get reversed(): Line {
    return new Line({
      startPoint: this.endPoint, 
      endPoint: this.startPoint,
    });
  };

  traverseByPercent(percentToTraverse: number): Point {
    return Point.lerp(
      this.startPoint,
      this.endPoint,
      percentToTraverse
    );
  };
  
  traverseByDistance(distanceToTraverse: number): {
    percentTraversed: number;
    stopPoint: Point;
  } {
    const totalDistance = this.distance;
    const percentTraversed = distanceToTraverse / totalDistance;
    
    const stopPoint = this.traverseByPercent(percentTraversed);
    return {
      percentTraversed, 
      stopPoint
    };
  };
};