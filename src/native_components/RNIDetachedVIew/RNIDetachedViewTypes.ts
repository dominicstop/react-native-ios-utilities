import type { PropsWithChildren } from "react";
import type { ViewProps } from "react-native";

import type { RNIDetachedNativeViewProps } from "./RNIDetachedNativeView";
import type { StateReactTag, StateViewID } from "react-native-ios-utilities";


export type RNIDetachedViewRef = {
  getViewID: () => StateViewID;
  getReactTag: () => StateReactTag;
  attachToWindow: () => Promise<void>;
  presentInModal: () => Promise<void>;
};

export type RNIDetachedViewInheritedOptionalProps = Partial<Pick<RNIDetachedNativeViewProps,
  | 'onDidSetViewID'
  | 'onViewWillRecycle'
  | 'onContentViewDidDetach'
>>;

// export type RNIDetachedViewInheritedRequiredProps = Required<Pick<RNIDetachedNativeViewProps,
//   | 'placeholder'
// >>;

export type RNIDetachedViewInheritedProps =
    RNIDetachedViewInheritedOptionalProps;
//  & RNIDetachedViewInheritedRequiredProps;

export type RNIDetachedViewBaseProps = {
  // TBA
};

export type RNIDetachedViewProps = PropsWithChildren<
    RNIDetachedViewInheritedProps 
  & RNIDetachedViewBaseProps
  & ViewProps
>;