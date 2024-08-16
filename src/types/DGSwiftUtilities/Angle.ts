
export type Angle = {
  mode: 'zero';

} | {
  mode: 'radians';
  value: number;

} | {
  mode: 'degrees';
  value: number;
};