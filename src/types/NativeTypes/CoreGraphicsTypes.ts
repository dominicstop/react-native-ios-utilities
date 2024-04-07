// Note:
// * Maps to `CoreFoundation/CFCGTypes.swift`

export type CGPoint = {
  x: number;
  y: number;
};

export type CGSize = {
  width: number;
  height: number;
};

export type CGVector = {
  dx: number;
  dy: number;
};

/** The base properties for `CGRect` */
export type CGRectBase = {
  origin: CGPoint;
  size: CGSize;
};

/** The computed properties for `CGRect` */
export type CGRectComputed = {
  minX: number;
  midX: number;
  maxX: number;
  minY: number;
  midY: number;
  maxY: number;
  width: number;
  height: number;
  isEmpty: number;
  isNull: number;
  isInfinite: number;
  standardized: CGRect;
  integral: CGRect;
  // dictionaryRepresentation
};

export type CGRect = CGRectBase & CGRectComputed;