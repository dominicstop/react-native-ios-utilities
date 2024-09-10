import type { HostComponent, ViewProps } from 'react-native';

import type { SharedViewEvents } from '../../types/SharedViewEvents';
import type { RemapObject } from '../../types/UtilityTypes';
import type { NativeComponentBasePropsInternal } from '../../types/ReactNativeUtilityTypes';


import { 
  default as RNIWrapperViewNativeComponent,
  type NativeProps as RNIWrapperViewNativeComponentProps
} from './RNIWrapperViewNativeComponent';

import type { SharedViewEventsInternal } from '../../types/SharedViewEventsInternal';
type RNIWrapperViewNativeComponentBaseProps = 
  NativeComponentBasePropsInternal<RNIWrapperViewNativeComponentProps>;

export type RNIWrapperNativeViewBaseProps = RemapObject<RNIWrapperViewNativeComponentBaseProps, {
  // TBA
}>;

export type RNIWrapperNativeViewProps = 
    ViewProps
  & SharedViewEvents
  & SharedViewEventsInternal
  & RNIWrapperNativeViewBaseProps;

export const RNIWrapperNativeView = 
  RNIWrapperViewNativeComponent as unknown as HostComponent<RNIWrapperNativeViewProps>;
