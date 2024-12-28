import type { BaseLayerKeyframeConfig } from "./BaseLayerKeyframeConfig";
import type { BaseViewKeyframeConfig } from "./BaseViewKeyframeConfig";


export type GenericViewKeyframe = 
    BaseViewKeyframeConfig
  & BaseLayerKeyframeConfig;