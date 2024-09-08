import * as React from 'react';
import { StyleSheet } from 'react-native';

import { RNIDetachedNativeView } from './RNIDetachedNativeView';

import type { 
  RNIDetachedViewProps, 
  RNIDetachedViewRef, 
} from './RNIDetachedViewTypes';

import type { RNIDetachedViewContentProps } from './RNIDetachedViewContentTypes';
import type { StateViewID, StateReactTag } from '../../types/SharedStateTypes';

import * as Helpers from '../../misc/Helpers';


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

  const children = React.Children.map(props.children, (child) => {
    return React.cloneElement(
      child as React.ReactElement<RNIDetachedViewContentProps>, 
      {
        isDetached,
        shouldEnableDebugBackgroundColors,
      }
    );
  });

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
        event.stopPropagation();
      }}
      onContentViewDidDetach={(event) => {
        props.onContentViewDidDetach?.(event);
        event.stopPropagation();
        setIsDetached(true);
      }}
    >
      {children}
    </RNIDetachedNativeView>
  );
});

const styles = StyleSheet.create({
  detachedView: {
    position: 'absolute',
    pointerEvents: 'none',
  },
  detachedViewDebug: {
    backgroundColor: 'rgba(255,0,0,0.3)',
  },
});