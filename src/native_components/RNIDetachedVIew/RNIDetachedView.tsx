import * as React from 'react';
import { StyleSheet } from 'react-native';

import { RNIDetachedNativeView } from './RNIDetachedNativeView';

import type { 
  RNIDetachedViewProps, 
  RNIDetachedViewRef, 
} from './RNIDetachedViewTypes';

import { type StateViewID, type StateReactTag } from '../../types/SharedStateTypes';
import * as Helpers from '../../misc/Helpers';

import { RNIWrapperView } from '../RNIWrapperView';


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
    attachToWindow: async (commandArgs) => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      setIsDetached(true);
      await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'attachToWindow',
        /* commandArgs: */ commandArgs,
      );
    },
    presentInModal: async () => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      setIsDetached(true);
      await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'presentInModal',
        /* commandArgs: */ {}
      );
    },
  }));

  const shouldEnableDebugBackgroundColors = 
    props.shouldEnableDebugBackgroundColors ?? false;

  return (
    <RNIDetachedNativeView
      {...props}
      style={[
        isDetached && styles.detachedView,
        shouldEnableDebugBackgroundColors && styles.detachedViewDebug,
        props.style,
      ]}
      onDidSetViewID={(event) => {
        setViewID(event.nativeEvent.viewID);
        setReactTag(event.nativeEvent.reactTag);
        props.onDidSetViewID?.(event);
      }}
    >
      <RNIWrapperView
        style={[
          shouldEnableDebugBackgroundColors && styles.wrapperViewDebug,
        ]}
      >
        <View style={isDetached && {
          flex: 1,
          margin: 10,
          backgroundColor: 'rgba(0,255,0,0.3)',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
          {props.children}
        </View>
      </RNIWrapperView>
    </RNIDetachedNativeView>
  );
});

const styles = StyleSheet.create({
  detachedView: {
    position: 'absolute',
  },
  detachedViewDebug: {
    backgroundColor: 'rgba(255,0,0,0.3)',
  },
  wrapperViewDebug: {
    backgroundColor: 'rgba(0,0,255,0.3)',
  },
});