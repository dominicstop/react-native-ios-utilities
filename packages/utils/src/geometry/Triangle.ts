import { Line } from "./Line";
import { Point, PointValue } from "./Point";


export type TriangleValue = {
  topPoint: PointValue;
  leadingPoint: PointValue;
  trailingPoint: PointValue;
};

/// ```
///            top point
///                +
///               / \
/// leading -->  /   \    < trailing
/// side        /     \     side
///            /       \
/// leading > +---------+ < trailing
/// point          ^        point
///              bottom
///              side
/// ```
export class Triangle {

  topPoint: Point;
  leadingPoint: Point;
  trailingPoint: Point;

  constructor(args: TriangleValue) {
    this.topPoint = new Point(args.topPoint);
    this.leadingPoint = new Point(args.leadingPoint);
    this.trailingPoint = new Point(args.trailingPoint);
  };

  // MARK: - Computed Properties
  // ---------------------------

  get asValue(): TriangleValue {
    return {
      topPoint: this.topPoint,
      leadingPoint: this.leadingPoint,
      trailingPoint: this.trailingPoint,
    };
  };

  get leadingSide(): Line {
    return new Line({
      startPoint: this.topPoint, 
      endPoint: this.leadingPoint
    });
  };
  
  get trailingSide(): Line {
    return new Line({
      startPoint: this.topPoint, 
      endPoint: this.trailingPoint
    });
  };
  
  get bottomSide(): Line {
    return new Line({
      startPoint: this.leadingPoint, 
      endPoint: this.trailingPoint
    });
  };
  
  get centerLine(): Line {
    const bottomMidPoint = this.bottomSide.midPoint;
    return new Line({
      startPoint: this.topPoint,
      endPoint: bottomMidPoint,
    });
  };

  get height(): number {
    const bottomMidPoint = this.bottomSide.midPoint;
    const distanceSigned = this.topPoint.getDistance(bottomMidPoint)
    return Math.floor(distanceSigned);
  };
  
  get width(): number {
    return this.bottomSide.distance;
  };
  
  get centroid(): Point {
    const sumTotalOfAllPoints = Point.sumOfAllPoints(
      this.topPoint, 
      this.leadingPoint,
      this.trailingPoint
    );
      
    return new Point({
      x: sumTotalOfAllPoints.x / 3,
      y: sumTotalOfAllPoints.y / 3,
    });
  };

  get area(): number {
    const { x: x1, y: y1 } = this.topPoint;
    const { x: x2, y: y2 } = this.leadingPoint;
    const { x: x3, y: y3 } = this.trailingPoint;
  
    const area = 0.5 * Math.abs(
      x1 * (y2 - y3) +
      x2 * (y3 - y1) +
      x3 * (y1 - y2)
    );
  
    return area;
  };

  get isCollinear(): boolean {
    return isNaN(this.area) || this.area === 0;
  };
  
  // MARK: - Methods
  // ---------------

  /// Resize triangle to new height, preserving slope, and topmost point
  /// (i.e. the resizing is pinned to the top).
  ///
  /// ```
  ///    /\          /\        /\
  ///   /  \   ->   /  \  ->  '--'
  ///  /    \      '----'
  /// '------'
  /// ```
  ///
  resizeTriangleRelativeToTopPoint(newHeight: number){
    const centerLineCurrent = this.centerLine;

    const { percentTraversed } = centerLineCurrent.traverseByDistance(newHeight);

    const leadingPointNext = this.leadingSide.traverseByPercent(percentTraversed);
    const trailingPointNext = this.trailingSide.traverseByPercent(percentTraversed);

    this.leadingPoint = leadingPointNext;
    this.trailingPoint = trailingPointNext;
  };
};

