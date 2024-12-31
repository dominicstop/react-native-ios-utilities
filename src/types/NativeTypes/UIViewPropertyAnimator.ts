import type { UIViewAnimating } from "./UIViewAnimating";


export type UIViewPropertyAnimator = UIViewAnimating & {
  duration: number;
  delay: number;
  isInterruptible: boolean;
  isUserInteractionEnabled: boolean;
  isManualHitTestingEnabled: boolean;
  scrubsLinearly: boolean;
  pausesOnCompletion: boolean;
};