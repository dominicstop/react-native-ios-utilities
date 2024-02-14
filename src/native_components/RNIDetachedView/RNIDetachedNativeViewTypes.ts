import type { ViewProps } from 'react-native';
import type { OnDetachedViewDidDetachEvent } from './RNIDetachedViewEvents';
import type { RNIDetachedViewContentTargetMode } from './RNIDetachedViewContentTargetMode';
import type { RNIViewCleanupMode } from '../../types/RNIViewCleanupMode';

export type RNIDetachedNativeViewBaseProps = {
  internalViewCleanupMode: RNIViewCleanupMode;
  contentTargetMode: RNIDetachedViewContentTargetMode;
  onViewDidDetach: OnDetachedViewDidDetachEvent;
};

export type RNIDetachedNativeViewProps = 
  RNIDetachedNativeViewBaseProps & ViewProps;
