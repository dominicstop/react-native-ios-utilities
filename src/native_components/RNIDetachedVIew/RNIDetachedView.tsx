import * as React from 'react';
import { StyleSheet, View } from 'react-native';

import { RNIDetachedNativeView } from './RNIDetachedNativeView';

import type { 
  RNIDetachedViewProps, 
  RNIDetachedViewRef, 
} from './RNIDetachedViewTypes';

import { type StateViewID, type StateReactTag } from '../../types/SharedStateTypes';
import * as Helpers from '../../misc/Helpers';
import { IS_USING_NEW_ARCH } from '../../constants/LibEnv';


export const RNIDetachedView = React.forwardRef<
  RNIDetachedViewRef, 
  RNIDetachedViewProps
>((props, ref) => {

  const [viewID, setViewID] = React.useState<StateViewID>();
  const [reactTag, setReactTag] = React.useState<StateReactTag>();

  const [isDetached, setIsDetached] = React.useState(false);

  React.useImperativeHandle(ref, () => ({
    getReactTag: () => {
      return reactTag;
    },
    getViewID: () => {
      return viewID;
    },
    attachToWindow: async () => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      setIsDetached(true);
      await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'attachToWindow',
        /* commandArgs: */ {}
      );
    },
  }));

  return (
    <RNIDetachedNativeView
      {...props}
      style={[
        isDetached && styles.detachedView,
        props.style,
      ]}
      onDidSetViewID={(event) => {
        setViewID(event.nativeEvent.viewID);
        setReactTag(event.nativeEvent.reactTag);
        props.onDidSetViewID?.(event);
      }}
    >
      {IS_USING_NEW_ARCH ? (
        <View>
          {props.children}
        </View>
      ):(
        props.children
      )}
    </RNIDetachedNativeView>
  );
});

const styles = StyleSheet.create({
  detachedView: {
    position: 'absolute',
  },
});