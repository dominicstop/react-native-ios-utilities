import type { Angle } from "./Angle";

export type Transform3D = {
  translateX?: number;
  translateY?: number;
  translateZ?: number;
  scaleX?: number;
  scaleY?: number;
  rotateX?: Angle;
  rotateY?: Angle;
  rotateZ?: Angle;
  perspective?: number;
  skewX?: number;
  skewY?: number;
};