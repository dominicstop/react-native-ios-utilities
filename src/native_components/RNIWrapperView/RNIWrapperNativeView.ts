import type { HostComponent, ViewProps } from 'react-native';
import type { SharedViewEvents, RemapObject } from 'react-native-ios-utilities';

import { 
  default as RNIWrapperViewNativeComponent,
  type NativeProps as RNIWrapperViewNativeComponentProps
} from './RNIWrapperViewNativeComponent';

type RNIWrapperViewNativeComponentBaseProps = 
  Omit<RNIWrapperViewNativeComponentProps, keyof (ViewProps & SharedViewEvents)>

export type RNIWrapperNativeViewBaseProps = RemapObject<RNIWrapperViewNativeComponentBaseProps, {
  placeholder: boolean;
}>;

export type RNIWrapperNativeViewProps = 
    SharedViewEvents
  & ViewProps
  & RNIWrapperNativeViewBaseProps;

export const RNIWrapperNativeView = 
  RNIWrapperViewNativeComponent as unknown as HostComponent<RNIWrapperNativeViewProps>;
