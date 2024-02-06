import type { ViewProps } from 'react-native';
import type { RNIDetachedNativeViewBaseProps } from './RNIDetachedNativeViewTypes';

type InheritedProps = Pick<RNIDetachedNativeViewBaseProps,
  | 'contentTargetMode'
> & Partial<Pick<RNIDetachedNativeViewBaseProps,
  | 'shouldCleanupOnComponentWillUnmount'
  | 'onViewDidDetach'
>>;

export type RNIDetachedViewBaseProps = {
  shouldApplyStyleOverride?: boolean;
  shouldNotifyOnComponentWillUnmount?: boolean;
};

export type RNIDetachedViewProps = 
  & InheritedProps
  & RNIDetachedViewBaseProps 
  & ViewProps;

export type RNIDetachedViewState = {
  isDetached: boolean;
};
