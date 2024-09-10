import type { HostComponent, ViewProps } from 'react-native';

import type { SharedViewEvents } from '../../types/SharedViewEvents';
import type { RemapObject } from '../../types/UtilityTypes';
import type { NativeComponentBaseProps } from '../../types/ReactNativeUtilityTypes';


import { 
  default as RNIWrapperViewNativeComponent,
  type NativeProps as RNIWrapperViewNativeComponentProps
} from './RNIWrapperViewNativeComponent';

type RNIWrapperViewNativeComponentBaseProps = 
  NativeComponentBaseProps<RNIWrapperViewNativeComponentProps>;

export type RNIWrapperNativeViewBaseProps = RemapObject<RNIWrapperViewNativeComponentBaseProps, {
  // TBA
}>;

export type RNIWrapperNativeViewProps = 
    SharedViewEvents
  & ViewProps
  & RNIWrapperNativeViewBaseProps;

export const RNIWrapperNativeView = 
  RNIWrapperViewNativeComponent as unknown as HostComponent<RNIWrapperNativeViewProps>;
