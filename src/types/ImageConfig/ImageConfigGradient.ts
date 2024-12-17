import type { PointPreset } from "../DGSwiftUtilities";
import type { ColorValue } from "../MiscTypes";
import type { CAGradientLayerType, CGPoint, CGSize } from "../NativeTypes";


export type ImageConfigGradientBase = {
  type: CAGradientLayerType;
  colors: Array<ColorValue>;
  locations?: Array<number>;
  size: CGSize;
  cornerRadius?: number;
};

export type ImageConfigGradientViaPoints = ImageConfigGradientBase & {
  startPointPreset: PointPreset;
  endPointPreset: PointPreset;
};

export type ImageConfigGradientViaPreset = ImageConfigGradientBase & {
  startPoint: CGPoint,
  endPoint: CGPoint,
};

export type ImageConfigGradient = 
    ImageConfigGradientViaPoints 
  | ImageConfigGradientViaPreset;