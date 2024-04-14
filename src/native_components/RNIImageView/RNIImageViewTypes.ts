import type { ViewProps } from 'react-native';
import type { RNIImageNativeViewProps } from './RNIImageNativeViewTypes';

export type RNIImageViewInheritedNativeRequiredProps = Pick<RNIImageNativeViewProps,
  | 'imageConfig'
>;

export type RNIImageViewInheritedNativeOptionalProps = Partial<Pick<RNIImageNativeViewProps,
  | 'preferredSymbolConfiguration'
>>;

export type RNIImageViewInheritedNativeProps = 
  & RNIImageViewInheritedNativeRequiredProps
  & RNIImageViewInheritedNativeOptionalProps;

export type RNIImageViewBaseProps = {
};

export type RNIImageViewProps = 
  & RNIImageViewInheritedNativeProps
  & RNIImageViewBaseProps 
  & ViewProps;
