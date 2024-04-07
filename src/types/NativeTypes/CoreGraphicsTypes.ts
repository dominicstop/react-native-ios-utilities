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

/** Matches the `CGRect` init. for obj-c */
export type CGRectObjC = {
  x: number;
  y: number;
  width: number;
  height: number;
};

/** Used for creating a `CGRect` from an object, i.e. JS -> Native */
export type CGRectInit = CGRectBase | CGRectObjC;

/** Represents a `CGRect` received from native, i.e. Native -> JS */
export type CGRectNative = CGRectBase & CGRectComputed;

/** 
 * All the possible ways a `CGRect` could be represented.
 * 
 * Prefer to use either: `CGRectInit` or `CGRectNative` instead
 * to avoid ambiguity.
 * */
export type CGRect = CGRectInit | CGRectNative;