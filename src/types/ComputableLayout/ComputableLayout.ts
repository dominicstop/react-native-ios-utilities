import { ComputableLayoutValue } from "./ComputableLayoutValue";
import { HorizontalAlignment } from "./HorizontalAlignment";
import { VerticalAlignment } from "./VerticalAlignment";

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