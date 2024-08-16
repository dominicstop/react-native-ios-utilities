
export type NumericLogicalExpression = {
  mode: 'any';
} | {
  mode: 'isLessThan';
  toValue: number;
} | {
  mode: 'isLessThanOrEqual';
  toValue: number;
} | {
  mode: 'isEqual';
  toValue: number;
} | {
  mode: 'isGreaterThan';
  toValue: number;
} | {
  mode: 'isGreaterThanOrEqual';
  toValue: number;
} | {
  mode: 'isBetweenRange';
  start: number;
  end: number;
  isInclusive?: boolean;
};