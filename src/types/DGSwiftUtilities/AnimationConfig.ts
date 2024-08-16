import type { CGPoint, CGVector } from "../NativeTypes/CoreGraphicsTypes";
import type { UIViewAnimationCurve } from "../NativeTypes/UIViewTypes";


// Unsupported: 
// * animator: UIViewPropertyAnimator
export type AnimationConfig = {
  mode: 'presetCurve';
  duration: number;
  curve: UIViewAnimationCurve;

} | {
  mode: 'presetSpring';
  duration: number;
  dampingRatio: number;

} | {
  mode: 'bezierCurve';
  duration: number;
  controlPoint1: CGPoint;
  controlPoint2: CGPoint;

} | {
  mode: 'springDamping';
  duration: number;
  dampingRatio: number;
  initialVelocity?: CGVector;
  maxVelocity?: number;

} | {
  mode: 'springPhysics';
  duration: number;
  mass: number;
  stiffness: number
  damping: number;
  initialVelocity?: CGVector;
  maxVelocity?: number;
};
