import * as React from 'react';
import { StyleSheet, View, type StyleProp, type ViewStyle } from 'react-native';

import { RNIWrapperView } from '../RNIWrapperView';
import { IS_USING_NEW_ARCH } from '../../constants/LibEnv';
import type { RNIDetachedViewContentProps } from './RNIDetachedViewContentTypes';


export function RNIDetachedViewContent(
  props: React.PropsWithChildren<RNIDetachedViewContentProps>
) {
  const wrapperStyle: StyleProp<ViewStyle> = [
    props.shouldEnableDebugBackgroundColors && styles.wrapperViewDebug,
    props.contentContainerStyle,
  ];

  return (
    <RNIWrapperView
      {...props}
      style={[
        ...(IS_USING_NEW_ARCH 
          ? wrapperStyle 
          : []
        ),
        (props.isParentDetached 
          ? styles.wrapperViewDetached
          : styles.wrapperViewAttached
        ),
        props.style,
      ]}
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
