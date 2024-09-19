import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";

import type { RNIDetachedNativeViewProps } from "./RNIDetachedNativeView";
import type { DetachedSubviewsMap } from "./DetachedSubviewsMap";

import type { StateReactTag, StateViewID } from "../../types/SharedStateTypes";
import type { AlignmentPositionConfig } from "../../types/DGSwiftUtilities";


export type RNIDetachedViewRef = {
  getViewID: () => StateViewID;
  getReactTag: () => StateReactTag;
  
  attachToWindow: (commandParams: {
    contentPositionConfig: AlignmentPositionConfig;
  }) => Promise<void>;

  presentInModal: (commandParams: {
    contentPositionConfig: AlignmentPositionConfig;
  }) => Promise<void>;

  getDetachedSubviewsMap: () => DetachedSubviewsMap;
};

export type RNIDetachedViewInheritedOptionalProps = Partial<Pick<RNIDetachedNativeViewProps,
  // shared/internal events
  | 'onDidSetViewID'
  | 'onViewWillRecycle'
  | 'onRawNativeEvent'

  // shared/internal props
  | 'rawDataForNative'

  // props
  | 'shouldImmediatelyDetach'

  // events
  | 'onContentViewDidDetach'
  | 'onViewDidDetachFromParent'
>>;

export type RNIDetachedViewBaseProps = {
  shouldEnableDebugBackgroundColors?: boolean;
  contentContainerStyle?: ViewProps['style'];
};

export type RNIDetachedViewProps = PropsWithChildren<
    RNIDetachedViewInheritedOptionalProps 
  & RNIDetachedViewBaseProps
  & ViewProps
>;