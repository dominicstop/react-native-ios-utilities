import * as React from 'react';
import { StyleSheet, View, type StyleProp, type ViewStyle } from 'react-native';

import { RNIWrapperView } from '../../native_components/RNIWrapperView';
import { DEFAULT_DETACHED_SUBVIEW_ENTRY } from './DetachedSubviewsMap';

import type { RNIDetachedViewContentProps } from './RNIDetachedViewContentTypes';
import type { StateViewID } from '../../types/SharedStateTypes';

import { IS_USING_NEW_ARCH } from '../../constants/LibEnv';


export function RNIDetachedViewContent(
  props: React.PropsWithChildren<RNIDetachedViewContentProps>
) {
  const [viewID, setViewID] = React.useState<StateViewID>();
  
  const wrapperStyle: StyleProp<ViewStyle> = [
    props.shouldEnableDebugBackgroundColors && styles.wrapperViewDebug,
    props.contentContainerStyle,
  ];

  const detachedSubviewEntry = 
       (viewID != null ? props.detachedSubviewsMap?.[viewID] : undefined ) 
    ?? DEFAULT_DETACHED_SUBVIEW_ENTRY;

  const didDetach = 
       (props.isParentDetached ?? false)
    || detachedSubviewEntry.didDetachFromOriginalParent;

  return (
    <RNIWrapperView
      {...props}
      style={[
        ...(IS_USING_NEW_ARCH 
          ? wrapperStyle 
          : []
        ),
        (didDetach 
          ? styles.wrapperViewDetached
          : styles.wrapperViewAttached
        ),
        props.style,
      ]}
      onDidSetViewID={(event) => {
        props.onDidSetViewID?.(event);
        setViewID(event.nativeEvent.viewID);

        props.onDidSetViewID?.(event);
        event.stopPropagation();
      }}
    >
      {IS_USING_NEW_ARCH ? (
        props.children
      ) : (
        <View style={[
          styles.innerWrapperContainerForPaper,
          ...wrapperStyle,
        ]}>
          {props.children}
        </View>
      )}
    </RNIWrapperView>
  );
};

const styles = StyleSheet.create({
  wrapperViewAttached: {
  },
  wrapperViewDetached: {
  },
  wrapperViewDebug: {
    backgroundColor: 'rgba(255,0,255,0.3)',
  },
  innerWrapperContainerForPaper: {
    flex: 1,
  },
});
