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

  return (
    <RNIDetachedNativeView
      {...props}
      style={[
        isDetached && styles.detachedView,
        props.style,
        // {backgroundColor: 'blue'}
      ]}
      onDidSetViewID={(event) => {
        setViewID(event.nativeEvent.viewID);
        setReactTag(event.nativeEvent.reactTag);
        props.onDidSetViewID?.(event);
      }}
    >
      <RNIWrapperView
        style={[
          {
          // backgroundColor: 'rgba(255,0,0,0.3)',
          },
          isDetached && {
            position: 'absolute',
            opacity: 0,
          },
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
});