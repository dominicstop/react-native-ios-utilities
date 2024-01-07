import type { ViewProps } from 'react-native';
import type { OnDetachedViewDidDetachEvent } from './RNIDetachedViewEvents';
import type { RNIDetachedViewContentTargetMode } from './RNIDetachedViewContentTargetMode';

export type RNIDetachedNativeViewBaseProps = {
  shouldCleanupOnComponentWillUnmount: boolean;
  contentTargetMode: RNIDetachedViewContentTargetMode;
  onViewDidDetach: OnDetachedViewDidDetachEvent;
};

export type RNIDetachedNativeViewProps = 
  RNIDetachedNativeViewBaseProps & ViewProps;
