import type { HostComponent, ViewProps } from 'react-native';

import { 
  default as RNIDetachedViewNativeComponent,
  type NativeProps as RNIDetachedViewNativeComponentProps
} from './RNIDetachedViewNativeComponent';

import type { OnContentViewDidDetachEvent, OnViewDidDetachFromParentEvent } from './RNIDetachedViewEvents';

import type { SharedViewEvents } from '../../types/SharedViewEvents';
import type { SharedViewEventsInternal } from '../../types/SharedViewEventsInternal';
import type { SharedViewPropsInternal } from '../../types/SharedViewPropsInternal';
import type { RemapObject } from '../../types/UtilityTypes';
import type { NativeComponentBasePropsInternal } from '../../types/ReactNativeUtilityTypes';


type RNIDetachedViewNativeComponentBaseProps = 
  NativeComponentBasePropsInternal<RNIDetachedViewNativeComponentProps>;

export type RNIDetachedNativeViewBaseProps = RemapObject<RNIDetachedViewNativeComponentBaseProps, {
  shouldImmediatelyDetach: boolean;
  onContentViewDidDetach: OnContentViewDidDetachEvent;
  onViewDidDetachFromParent: OnViewDidDetachFromParentEvent;
  reactChildrenCount: number;
}>;

export type RNIDetachedNativeViewProps = 
    ViewProps
  & SharedViewEvents
  & SharedViewEventsInternal
  & SharedViewPropsInternal
  & RNIDetachedNativeViewBaseProps;

export const RNIDetachedNativeView = 
  RNIDetachedViewNativeComponent as unknown as HostComponent<RNIDetachedNativeViewProps>;
