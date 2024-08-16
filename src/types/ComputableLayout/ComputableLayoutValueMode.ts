import type { CGRectNative, CGSize, UIEdgeInsets } from "../NativeTypes";
import type { ComputableLayoutValuePercentTarget } from "./ComputableLayoutValuePercentTarget";
import type { ComputableLayoutValueEvaluableCondition } from "./ComputableLayoutValueEvaluableCondition";
import type { EvaluableCondition } from "./EvaluableCondition";


export type ComputableLayoutValueMode = {
  mode: 'stretch';
} | {
  mode: 'constant';
  value: number;
} | {
  mode: 'percent';
  relativeTo?: ComputableLayoutValuePercentTarget;
  percentValue: number;
} | {
  mode: 'safeAreaInsets';
  insetKey: keyof UIEdgeInsets;
} | {
  mode: 'keyboardScreenRect';
  rectKey: keyof CGRectNative;
} | {
  mode: 'keyboardRelativeSize';
  sizeKey: keyof CGSize;
} | {
  mode: 'multipleValues';
  values: ComputableLayoutValueMode[];
} | {
  mode: 'conditionalLayoutValue';
  condition: ComputableLayoutValueEvaluableCondition;
  trueValue: ComputableLayoutValueMode;
  falseValue?: ComputableLayoutValueMode;
} | {
  mode: 'conditionalValue';
  condition: EvaluableCondition;
  trueValue?: ComputableLayoutValueMode;
  falseValue?: ComputableLayoutValueMode;
};