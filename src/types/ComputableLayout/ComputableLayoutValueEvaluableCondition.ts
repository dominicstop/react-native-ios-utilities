import type { ComputableLayoutValueMode } from "./ComputableLayoutValueMode";

export type ComputableLayoutValueEvaluableCondition = {
  mode: 'isNilOrZero';
  value: ComputableLayoutValueMode;
} | {
  mode: 'keyboardPresent';
};
