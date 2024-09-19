import type { HostComponent, ViewProps } from 'react-native';

import { 
  default as RNIWrapperViewNativeComponent,
  type NativeProps as RNIWrapperViewNativeComponentProps
} from './RNIWrapperViewNativeComponent';

import type { SharedViewEvents } from '../../types/SharedViewEvents';
import type { SharedViewPropsInternal } from '../../types/SharedViewPropsInternal';
import type { SharedViewEventsInternal } from '../../types/SharedViewEventsInternal';

import type { RemapObject } from '../../types/UtilityTypes';
import type { NativeComponentBasePropsInternal } from '../../types/ReactNativeUtilityTypes';


type RNIWrapperViewNativeComponentBaseProps = 
  NativeComponentBasePropsInternal<RNIWrapperViewNativeComponentProps>;

export type RNIWrapperNativeViewBaseProps = RemapObject<RNIWrapperViewNativeComponentBaseProps, {
  // TBA
}>;

export type RNIWrapperNativeViewProps = 
    ViewProps
  & SharedViewEvents
  & SharedViewEventsInternal
  & SharedViewPropsInternal
  & RNIWrapperNativeViewBaseProps;

export const RNIWrapperNativeView = 
  RNIWrapperViewNativeComponent as unknown as HostComponent<RNIWrapperNativeViewProps>;