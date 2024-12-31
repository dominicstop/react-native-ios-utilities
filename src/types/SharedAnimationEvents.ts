
import type { BubblingEventHandler } from "react-native/Libraries/Types/CodegenTypes";
import type { UIViewAnimatingPosition, UIViewPropertyAnimator } from "./NativeTypes";


// MARK: - OnPropertyAnimatorDidStartEvent
// ---------------------------------------

export type OnPropertyAnimatorDidStartEventPayload = Readonly<{
  objectMetadata: UIViewPropertyAnimator;
  didCancelPreviousAnimation?: boolean;
}>;

export type OnPropertyAnimatorDidStartEvent = 
  BubblingEventHandler<OnPropertyAnimatorDidStartEventPayload>;

// MARK: - OnPropertyAnimatorDidCompleteEvent
// ------------------------------------------

export type OnPropertyAnimatorDidCompleteEventPayload = Readonly<{
  objectMetadata: UIViewPropertyAnimator;
  animationPosition: UIViewAnimatingPosition;
  didCancel?: boolean;
}>;

export type OnPropertyAnimatorDidCompleteEvent = 
  BubblingEventHandler<OnPropertyAnimatorDidCompleteEventPayload>;