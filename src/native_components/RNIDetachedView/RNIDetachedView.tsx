import * as React from 'react';
import { StyleSheet } from 'react-native';

import { RNIDetachedNativeView } from './RNIDetachedNativeView';
import { DEFAULT_DETACHED_SUBVIEW_ENTRY, type DetachedSubviewsMap } from './DetachedSubviewsMap';

import type { RNIDetachedViewProps, RNIDetachedViewRef, } from './RNIDetachedViewTypes';
import type { RNIDetachedViewContentProps } from './RNIDetachedViewContentTypes';

import type { StateViewID, StateReactTag } from '../../types/SharedStateTypes';
import { Helpers } from '../../misc/Helpers';


export const RNIDetachedView = React.forwardRef<
  RNIDetachedViewRef, 
  RNIDetachedViewProps
>((props, ref) => {
  const [viewID, setViewID] = React.useState<StateViewID>();
  const [reactTag, setReactTag] = React.useState<StateReactTag>();

  const [isDetachedInNative, setIsDetachedInNative] = React.useState(false);

  const [
    detachedSubviewsMap, 
    setDetachedSubviewsMap
  ] = React.useState<DetachedSubviewsMap>({});

  React.useImperativeHandle(ref, () => ({
    getReactTag: () => {
      return reactTag;
    },
    getViewID: () => {
      return viewID;
    },
    getDetachedSubviewsMap: () => {
      return detachedSubviewsMap;
    },
    attachToWindow: async (commandArgs) => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      setIsDetachedInNative(true);
      await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'attachToWindow',
        /* commandArgs: */ commandArgs,
      );
    },
    presentInModal: async (commandArgs) => {
      if(viewID == null) return;
      const module = Helpers.getRNIUtilitiesModule();

      setIsDetachedInNative(true);
      await module.viewCommandRequest(
        /* viewID     : */ viewID,
        /* commandName: */ 'presentInModal',
        /* commandArgs: */ commandArgs
      );
    },
  }));

  const shouldEnableDebugBackgroundColors = 
    props.shouldEnableDebugBackgroundColors ?? false;

  const shouldImmediatelyDetach = props.shouldImmediatelyDetach ?? false;
  const isDetached = shouldImmediatelyDetach || isDetachedInNative;

  const reactChildrenCount = React.Children.count(props.children);

  const children = React.Children.map(props.children, (child) => {
    if (React.isValidElement(child) && child.type === React.Fragment) {
      return child;
    }
    return React.cloneElement(
      child as React.ReactElement<RNIDetachedViewContentProps>, 
      {
        isParentDetached: isDetached,
        shouldEnableDebugBackgroundColors,
        detachedSubviewsMap,
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
      reactChildrenCount={reactChildrenCount}
      onDidSetViewID={(event) => {
        setViewID(event.nativeEvent.viewID);
        setReactTag(event.nativeEvent.reactTag);

        props.onDidSetViewID?.(event);
        event.stopPropagation();
      }}
      onViewDidDetachFromParent={(event) => {
        props.onViewDidDetachFromParent?.(event);
        event.stopPropagation();
        setIsDetachedInNative(true);
      }}
      onContentViewDidDetach={(event) => {
        props.onContentViewDidDetach?.(event);
        event.stopPropagation();

        const detachedSubviewViewID = event.nativeEvent.viewID;
        const prevEntry = detachedSubviewsMap[detachedSubviewViewID];

        setDetachedSubviewsMap({
          ...detachedSubviewsMap,
          [detachedSubviewViewID]: {
            ...DEFAULT_DETACHED_SUBVIEW_ENTRY,
            ...prevEntry,
            didDetachFromOriginalParent: true,
          },
        });
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
    opacity: 0,
  },
  detachedViewDebug: {
    backgroundColor: 'rgba(255,0,0,0.3)',
  },
});
