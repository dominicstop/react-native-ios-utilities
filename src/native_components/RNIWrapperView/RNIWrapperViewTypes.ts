import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";

import type { RNIWrapperNativeViewProps } from "./RNIWrapperNativeView";
import type { StateReactTag, StateViewID } from '../../types/SharedStateTypes';


export type RNIWrapperViewRef = {
  getViewID: () => StateViewID;
  getReactTag: () => StateReactTag;
};

export type RNIWrapperViewInheritedOptionalProps = Partial<Pick<RNIWrapperNativeViewProps,
  // shared/internal events
  | 'onDidSetViewID'
  | 'onViewWillRecycle'
  | 'onRawNativeEvent'

  // shared/internal props
  | 'rawDataForNative'
>>;

export type RNIWrapperViewBaseProps = {
  debugShouldEnableLogging?: boolean;
};

export type RNIWrapperViewProps = PropsWithChildren<
    RNIWrapperViewInheritedOptionalProps 
  & RNIWrapperViewBaseProps
  & ViewProps
>;