import type { ViewProps } from 'react-native';
import type { RNIDummyNativeViewBaseProps } from './RNIDummyNativeViewTypes';

type InheritedProps = Partial<Pick<RNIDummyNativeViewBaseProps,
  | 'shouldCleanupOnComponentWillUnmount'
>>;

export type RNIDummyViewBaseProps = {};

export type RNIDummyViewProps = 
  & InheritedProps
  & RNIDummyViewBaseProps 
  & ViewProps;
