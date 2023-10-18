import { ViewProps } from 'react-native';

export type RNIDummyNativeViewBaseProps = {
  shouldCleanupOnComponentWillUnmount: boolean;
};

export type RNIDummyNativeViewProps = 
  RNIDummyNativeViewBaseProps & ViewProps;
