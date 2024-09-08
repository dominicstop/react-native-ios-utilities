import type { ViewProps } from 'react-native';
import type { RNIWrapperViewProps } from "../RNIWrapperView";
import type { RNIDetachedViewProps } from "./RNIDetachedViewTypes";


export type RNIDetachedViewContentInheritedProps = Pick<RNIDetachedViewProps, 
  | 'shouldEnableDebugBackgroundColors'
>;

export type RNIDetachedViewContentBaseProps = {
  contentContainerStyle?: ViewProps['style'];
  isDetached?: boolean;
};

export type RNIDetachedViewContentProps = 
    RNIWrapperViewProps
  & RNIDetachedViewContentInheritedProps
  & RNIDetachedViewContentBaseProps;