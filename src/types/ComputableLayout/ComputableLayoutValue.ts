import { ComputableLayoutOffsetOperation } from "./ComputableLayoutOffsetOperation";
import { ComputableLayoutValueMode } from "./ComputableLayoutValueMode";


export type ComputableLayoutValue = {
  mode: ComputableLayoutValueMode;
  offsetValue?: ComputableLayoutValueMode;
  offsetOperation?: ComputableLayoutOffsetOperation;
  minValue?: ComputableLayoutValueMode;
  maxValue?: ComputableLayoutValueMode;
};