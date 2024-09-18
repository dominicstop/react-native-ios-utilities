import type { ViewStyle } from 'react-native';
import type { RNIWrapperViewProps } from "../RNIWrapperView";
import type { RNIDetachedViewProps } from "./RNIDetachedViewTypes";
import type { DetachedSubviewsMap } from './DetachedSubviewsMap';


export type RNIDetachedViewContentInheritedProps = Pick<RNIDetachedViewProps, 
  | 'shouldEnableDebugBackgroundColors'
>;

export type RNIDetachedViewContentBaseProps = {
  contentContainerStyle?: ViewStyle;
  isParentDetached?: boolean;
  detachedSubviewsMap?: DetachedSubviewsMap;
};

export type RNIDetachedViewContentProps = 
    RNIWrapperViewProps
  & RNIDetachedViewContentInheritedProps
  & RNIDetachedViewContentBaseProps;