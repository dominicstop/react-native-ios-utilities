import type { HostComponent, ViewProps } from 'react-native';

import type { SharedViewEvents } from '../../types/SharedViewEvents';
import type { RemapObject } from '../../types/UtilityTypes';


import { 
  default as RNIWrapperViewNativeComponent,
  type NativeProps as RNIWrapperViewNativeComponentProps
} from './RNIWrapperViewNativeComponent';

type RNIWrapperViewNativeComponentBaseProps = 
  Omit<RNIWrapperViewNativeComponentProps, keyof (ViewProps & SharedViewEvents)>

export type RNIWrapperNativeViewBaseProps = RemapObject<RNIWrapperViewNativeComponentBaseProps, {
  // TBA
}>;

export type RNIWrapperNativeViewProps = 
    SharedViewEvents
  & ViewProps
  & RNIWrapperNativeViewBaseProps;

export const RNIWrapperNativeView = 
  RNIWrapperViewNativeComponent as unknown as HostComponent<RNIWrapperNativeViewProps>;
