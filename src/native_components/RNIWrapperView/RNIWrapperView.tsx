import * as React from 'react';

import { RNIWrapperNativeView } from './RNIWrapperNativeView';

import type { RNIWrapperViewProps, RNIWrapperViewRef } from './RNIWrapperViewTypes';
import type { StateReactTag, StateViewID } from '../../types/SharedStateTypes';


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
        event.stopPropagation();
      }}
    >
      {props.children}
    </RNIWrapperNativeView>
  );
});