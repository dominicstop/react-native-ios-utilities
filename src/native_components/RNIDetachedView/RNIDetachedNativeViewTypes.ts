import { ViewProps } from 'react-native';
import type { OnDetachedViewDidDetachEvent } from './RNIDetachedViewEvents';

export type RNIDetachedNativeViewBaseProps = {
  shouldCleanupOnComponentWillUnmount: boolean;
  onViewDidDetach: OnDetachedViewDidDetachEvent;
};

export type RNIDetachedNativeViewProps = 
  RNIDetachedNativeViewBaseProps & ViewProps;
