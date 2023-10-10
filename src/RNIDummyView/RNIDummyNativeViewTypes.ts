import { ViewProps } from 'react-native';
import type { OnReactTagDidSetEvent } from '../types/SharedEvents';

export type RNIDummyNativeViewBaseProps = {
  shouldCleanupOnComponentWillUnmount: boolean;
  onReactTagDidSet: OnReactTagDidSetEvent;
};

export type RNIDummyNativeViewProps = 
  RNIDummyNativeViewBaseProps & ViewProps;
