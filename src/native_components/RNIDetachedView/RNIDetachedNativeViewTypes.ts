import type { ViewProps } from 'react-native';

import type { OnDetachedViewDidDetachEvent } from './RNIDetachedViewEvents';
import type { RNIDetachedViewContentTargetMode } from './RNIDetachedViewContentTargetMode';
import type { RNIViewCleanupModeProp } from '../../types/RNIViewCleanupModeProp';

export type RNIDetachedNativeViewBaseProps = {
  contentTargetMode: RNIDetachedViewContentTargetMode;
  onViewDidDetach: OnDetachedViewDidDetachEvent;
};

export type RNIDetachedNativeViewProps = 
  & RNIViewCleanupModeProp
  & RNIDetachedNativeViewBaseProps 
  & ViewProps;
