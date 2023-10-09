import { useRef, useEffect } from "react";
import { StyleSheet } from "react-native";

import { RNIDummyViewModule } from "./RNIDummyViewModule";
import { RNIDummyNativeView } from "./RNIDummyNativeView";

import { RNIDummyViewProps } from "./RNIDummyViewTypes";
import { OnReactTagDidSetEvent } from "./RNIDummyViewEvents";

export function RNIDummyView(props: RNIDummyViewProps) {
  const { shouldCleanupOnComponentWillUnmount = false, ...restProps } = props;

  const reactTag = useRef<number>();
  
  useEffect(function onUnmount() {
    return () => {
      const tag = reactTag.current;
      const isManuallyTriggered = false;
      // this is the cleanup function returned from useEffect
      if (typeof tag !== "number") return;

      RNIDummyViewModule.notifyComponentWillUnmount(
        tag,
        isManuallyTriggered
      );
    };
  }, []);

  return (
    <RNIDummyNativeView
      {...restProps}
      styles={styles.nativeDummyView}
      onReactTagDidSet={useCallback(({ nativeEvent }) => {
        reactTag.current = nativeEvent.reactTag;
      }, [])}
    />
  );
}
