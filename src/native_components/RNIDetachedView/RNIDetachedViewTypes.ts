import type { ViewProps } from 'react-native';
import type { RNIDetachedNativeViewBaseProps } from './RNIDetachedNativeViewTypes';

type InheritedProps = Partial<Pick<RNIDetachedNativeViewBaseProps,
  | 'shouldCleanupOnComponentWillUnmount'
  | 'onViewDidDetach'
>>;

export type RNIDetachedViewBaseProps = {};

export type RNIDetachedViewProps = 
  & InheritedProps
  & RNIDetachedViewBaseProps 
  & ViewProps;

export type RNIDetachedViewState = {
  isDetached: boolean;
};
