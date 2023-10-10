import { ViewProps } from 'react-native';
import type { OnDetachedViewDidDetachEvent } from './RNIDetachedViewEvents';
import type { OnReactTagDidSetEvent } from '../types/SharedEvents';

export type RNIDetachedNativeViewBaseProps = {
  shouldCleanupOnComponentWillUnmount: boolean;
  onReactTagDidSet: OnReactTagDidSetEvent;
  onViewDidDetach: OnDetachedViewDidDetachEvent;
};

export type RNIDetachedNativeViewProps = 
  RNIDetachedNativeViewBaseProps & ViewProps;
