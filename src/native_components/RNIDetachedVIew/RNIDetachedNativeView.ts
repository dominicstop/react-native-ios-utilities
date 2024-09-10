import type { HostComponent, ViewProps } from 'react-native';

import { 
  default as RNIDetachedViewNativeComponent,
  type NativeProps as RNIDetachedViewNativeComponentProps
} from './RNIDetachedViewNativeComponent';

import type { OnContentViewDidDetachEvent } from './RNIDetachedViewEvents';

import type { SharedViewEvents } from '../../types/SharedViewEvents';
import type { RemapObject } from '../../types/UtilityTypes';
import type { NativeComponentBaseProps } from '../../types/ReactNativeUtilityTypes';


type RNIDetachedViewNativeComponentBaseProps = 
  NativeComponentBaseProps<RNIDetachedViewNativeComponentProps>;

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
