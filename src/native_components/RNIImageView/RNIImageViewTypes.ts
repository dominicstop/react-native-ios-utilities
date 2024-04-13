import type { ViewProps } from 'react-native';
import type { RNIImageNativeViewProps } from './RNIImageNativeViewTypes';

export type RNIImageViewInheritedProps = Pick<RNIImageNativeViewProps,
  | 'imageConfig'
>;

export type RNIImageViewBaseProps = {
};

export type RNIImageViewProps = 
  & RNIImageViewInheritedProps
  & RNIImageViewBaseProps 
  & ViewProps;
