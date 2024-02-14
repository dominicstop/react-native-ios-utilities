import type { ViewProps } from 'react-native';
import type { RNIDetachedNativeViewBaseProps } from './RNIDetachedNativeViewTypes';

export type RNIDetachedViewInheritedProps = Pick<RNIDetachedNativeViewBaseProps,
  | 'contentTargetMode'
> & Partial<Pick<RNIDetachedNativeViewBaseProps,
  | 'internalViewCleanupMode'
  | 'onViewDidDetach'
>>;

export type RNIDetachedViewBaseProps = {
  shouldApplyStyleOverride?: boolean;
  shouldCleanupOnComponentWillUnmount?: boolean;
  shouldNotifyOnComponentWillUnmount?: boolean;
};

export type RNIDetachedViewProps = 
  & RNIDetachedViewInheritedProps
  & RNIDetachedViewBaseProps 
  & ViewProps;

export type RNIDetachedViewState = {
  isDetached: boolean;
};
