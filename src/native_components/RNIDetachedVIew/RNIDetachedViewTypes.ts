import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";

import type { RNIDetachedNativeViewProps } from "./RNIDetachedNativeView";
import type { StateReactTag, StateViewID } from "../../types/SharedStateTypes";
import type { AlignmentPositionConfig } from "../../types/DGSwiftUtilities";


export type RNIDetachedViewRef = {
  getViewID: () => StateViewID;
  getReactTag: () => StateReactTag;
  
  attachToWindow: (commandParams: {
    contentPositionConfig: AlignmentPositionConfig;
  }) => Promise<void>;

  presentInModal: () => Promise<void>;
};

export type RNIDetachedViewInheritedOptionalProps = Partial<Pick<RNIDetachedNativeViewProps,
  | 'onDidSetViewID'
  | 'onViewWillRecycle'
  | 'onContentViewDidDetach'
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