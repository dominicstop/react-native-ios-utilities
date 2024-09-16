import type { ViewStyle } from 'react-native';
import type { RNIWrapperViewProps } from "../RNIWrapperView";
import type { RNIDetachedViewProps } from "./RNIDetachedViewTypes";


export type RNIDetachedViewContentInheritedProps = Pick<RNIDetachedViewProps, 
  | 'shouldEnableDebugBackgroundColors'
>;

export type RNIDetachedViewContentBaseProps = {
  contentContainerStyle?: ViewStyle;
  isParentDetached?: boolean;
};

export type RNIDetachedViewContentProps = 
    RNIWrapperViewProps
  & RNIDetachedViewContentInheritedProps
  & RNIDetachedViewContentBaseProps;