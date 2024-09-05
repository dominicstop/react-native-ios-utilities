import * as React from 'react';
import { StyleSheet, View, type StyleProp, type ViewStyle } from 'react-native';

import { RNIDetachedNativeView } from './RNIDetachedNativeView';

import type { 
  RNIDetachedViewProps, 
  RNIDetachedViewRef, 
} from './RNIDetachedViewTypes';

import { RNIWrapperView } from '../RNIWrapperView';

import { type StateViewID, type StateReactTag } from '../../types/SharedStateTypes';

import * as Helpers from '../../misc/Helpers';
import { IS_USING_NEW_ARCH } from '../../constants/LibEnv';
import type { OnContentViewDidDetachEvent } from './RNIDetachedViewEvents';


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

  const onContentViewDidDetachHandler = 
    React.useRef<OnContentViewDidDetachEvent | undefined>();
  
  React.useEffect(() => {
    onContentViewDidDetachHandler.current = (event) => {
      props.onContentViewDidDetach?.(event);
      event.stopPropagation();
      setIsDetached(true);
    };
  });

  const shouldEnableDebugBackgroundColors = 
    props.shouldEnableDebugBackgroundColors ?? false;

  const wrapperStyle: StyleProp<ViewStyle> = [
    styles.wrapperView,
    shouldEnableDebugBackgroundColors && styles.wrapperViewDebug,
    props.contentContainerStyle,
  ];

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
      onContentViewDidDetach={onContentViewDidDetachHandler.current}
    >
      <RNIWrapperView
        style={IS_USING_NEW_ARCH && wrapperStyle}
      >
        {IS_USING_NEW_ARCH ? (
          props.children
        ) : (
          <View style={wrapperStyle}>
            {props.children}
          </View>
        )}
      </RNIWrapperView>
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
  wrapperView: {
    flex: 1,
  },
  wrapperViewDebug: {
    backgroundColor: 'rgba(0,0,255,0.3)',
  },
  wrapperContentContainer: {
    flex: 1,
    alignSelf: 'stretch',
  },
});