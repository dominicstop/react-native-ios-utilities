import type { ViewProps } from 'react-native';
import type {  RNIDetachedNativeViewProps } from './RNIDetachedNativeViewTypes';

export type RNIDetachedViewInheritedProps = Pick<RNIDetachedNativeViewProps,
  | 'contentTargetMode'
> & Partial<Pick<RNIDetachedNativeViewProps,
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
