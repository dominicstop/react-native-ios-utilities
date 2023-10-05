import { ViewProps } from 'react-native';
import type { OnReactTagDidSetEvent } from './RNIDummyViewEvents';

export type RNIDummyNativeViewBaseProps = {
  onReactTagDidSet: OnReactTagDidSetEvent;
};

export type RNIDummyNativeViewProps = 
  RNIDummyNativeViewBaseProps & ViewProps;
