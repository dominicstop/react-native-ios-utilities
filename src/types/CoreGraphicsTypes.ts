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

export type CGRect = {
  origin: CGPoint;
  size: CGSize;
};