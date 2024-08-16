import type { ComputableLayoutValue } from "./ComputableLayoutValue";
import type { HorizontalAlignment } from "./HorizontalAlignment";
import type { VerticalAlignment } from "./VerticalAlignment";

export type ComputableLayout = {
  horizontalAlignment: HorizontalAlignment;
  verticalAlignment: VerticalAlignment;
  
  width: ComputableLayoutValue;
  height: ComputableLayoutValue;
  
  marginLeft?: ComputableLayoutValue;
  marginRight?: ComputableLayoutValue;
  marginTop?: ComputableLayoutValue;
  marginBottom?: ComputableLayoutValue;
  
  paddingLeft?: ComputableLayoutValue;
  paddingRight?: ComputableLayoutValue;
  paddingTop?: ComputableLayoutValue;
  paddingBottom?: ComputableLayoutValue;
  
  offsetX?: ComputableLayoutValue;
  offsetY?: ComputableLayoutValue;
};