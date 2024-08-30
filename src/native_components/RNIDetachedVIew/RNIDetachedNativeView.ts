import type { HostComponent, ViewProps } from 'react-native';
import type { SharedViewEvents, RemapObject, OnContentViewDidDetachEvent } from 'react-native-ios-utilities';

import { 
  default as RNIDetachedViewNativeComponent,
  type NativeProps as RNIDetachedViewNativeComponentProps
} from './RNIDetachedViewNativeComponent';


type RNIDetachedViewNativeComponentBaseProps = 
  Omit<RNIDetachedViewNativeComponentProps, keyof (ViewProps & SharedViewEvents)>

export type RNIDetachedNativeViewBaseProps = RemapObject<RNIDetachedViewNativeComponentBaseProps, {
  // events
  onContentViewDidDetach?: OnContentViewDidDetachEvent;
}>;

export type RNIDetachedNativeViewProps = 
    SharedViewEvents
  & ViewProps
  & RNIDetachedNativeViewBaseProps;

export const RNIDetachedNativeView = 
  RNIDetachedViewNativeComponent as unknown as HostComponent<RNIDetachedNativeViewProps>;
