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
  minX: boolean;
  midX: boolean;
  maxX: boolean;
  minY: boolean;
  midY: boolean;
  maxY: boolean;
  width: boolean;
  height: boolean;
  isEmpty: boolean;
  isNull: boolean;
  isInfinite: boolean;
  standardized: CGRect;
  integral: CGRect;
  // dictionaryRepresentation
};

export type CGRect = CGRectBase & CGRectComputed;