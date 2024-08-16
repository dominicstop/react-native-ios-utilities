import type { ComputableLayoutOffsetOperation } from "./ComputableLayoutOffsetOperation";
import type { ComputableLayoutValueMode } from "./ComputableLayoutValueMode";


export type ComputableLayoutValue = {
  mode: ComputableLayoutValueMode;
  offsetValue?: ComputableLayoutValueMode;
  offsetOperation?: ComputableLayoutOffsetOperation;
  minValue?: ComputableLayoutValueMode;
  maxValue?: ComputableLayoutValueMode;
};