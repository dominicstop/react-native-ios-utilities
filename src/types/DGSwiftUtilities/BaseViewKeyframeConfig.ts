import type { ColorValue } from "../MiscTypes";
import type { Transform3D } from "./Transform3D";


export type BaseViewKeyframeConfig = {
  opacity?: number;
  backgroundColor?: ColorValue;
  transform?: Transform3D;
};