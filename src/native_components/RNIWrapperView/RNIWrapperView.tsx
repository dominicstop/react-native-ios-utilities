import * as React from 'react';

import { type StateViewID, type StateReactTag } from "react-native-ios-utilities";
import { RNIWrapperNativeView } from './RNIWrapperNativeView';

import type { 
  RNIWrapperViewProps, 
  RNIWrapperViewRef, 
} from './RNIWrapperViewTypes';


export const RNIWrapperView = React.forwardRef<
  RNIWrapperViewRef, 
  RNIWrapperViewProps
>((props, ref) => {

  const [viewID, setViewID] = React.useState<StateViewID>();
  const [reactTag, setReactTag] = React.useState<StateReactTag>();

  React.useImperativeHandle(ref, () => ({
    getReactTag: () => {
      return reactTag;
    },
    getViewID: () => {
      return viewID;
    },
  }));

  return (
    <RNIWrapperNativeView
      {...props}
      onDidSetViewID={(event) => {
        setViewID(event.nativeEvent.viewID);
        setReactTag(event.nativeEvent.reactTag);
        props.onDidSetViewID?.(event);
      }}
    >
      {props.children}
    </RNIWrapperNativeView>
  );
});