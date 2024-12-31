//  UIViewAnimating.h
//  UIKit


export type UIViewAnimatingState = 
  | 'inactive'
  | 'active'
  | 'stopped';

export type UIViewAnimatingPosition = 
  | 'end'
  | 'start'
  | 'current';

export type UIViewAnimating = {
  fractionComplete: boolean;
  isReversed: boolean;
  state: UIViewAnimatingState;
  isRunning: boolean;
};