import type { ColorValue } from "../MiscTypes";
import type { CACornerMask, CGSize } from "../NativeTypes";


export type BaseLayerKeyframeConfig = {

  borderWidth?: number;
  borderColor?: ColorValue;

  shadowColor?: ColorValue;
  shadowOffset?: CGSize;
  shadowOpacity?: number;
  shadowRadius?: number;

  cornerRadius?: number;
  cornerMask?: CACornerMask;
};