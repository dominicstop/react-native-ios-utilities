import type { ViewStyle } from 'react-native';
import type { RNIWrapperViewProps } from "../RNIWrapperView";
import type { RNIDetachedViewProps } from "../RNIDetachedVIew";
import type { DetachedSubviewsMap } from '../RNIDetachedVIew';


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