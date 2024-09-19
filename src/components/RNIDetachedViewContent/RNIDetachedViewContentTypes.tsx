import type { ViewStyle } from 'react-native';

import type { RNIWrapperViewProps } from "../../native_components/RNIWrapperView";
import type { RNIDetachedViewProps } from "../../native_components/RNIDetachedVIew";

import type { DetachedSubviewsMap } from '../../constants/DetachedSubviewsMap';


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