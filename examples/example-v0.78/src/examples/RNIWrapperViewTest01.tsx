import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, RNIWrapperView, type OnDidSetViewIDEventPayload, ObjectPropertyDisplay, Colors, type OnViewWillRecycleEventPayload } from 'react-native-ios-utilities';
import type { ExampleItemProps } from './SharedExampleTypes';


export function RNIWrapperViewTest01(props: ExampleItemProps) {
  const [reactTag, setReactTag] = 
    React.useState<OnDidSetViewIDEventPayload['reactTag'] | undefined>();

  const [viewID, setViewID] = 
    React.useState<OnDidSetViewIDEventPayload['viewID'] | undefined>();

  const [viewRecycleCount, setViewRecycleCount] = 
    React.useState<OnViewWillRecycleEventPayload['recycleCount'] | undefined>();
  
  return (
    <RNIWrapperView
      style={props.style}
      onDidSetViewID={({nativeEvent}) => {
        setReactTag(nativeEvent.reactTag);
        setViewID(nativeEvent.viewID);
        setViewRecycleCount(nativeEvent.recycleCount);
      }}
      onViewWillRecycle={({nativeEvent}) => {
        setViewRecycleCount(nativeEvent.recycleCount);
      }}
    >
      <ExampleItemCard
        index={props.index}
        title={'RNIWrapperViewTest01'}
        description={[
          "Get the `reactTag` + `viewID` for the current view",
        ]}
      >
        <ObjectPropertyDisplay
          recursiveStyle={styles.debugDisplayInner}
          object={{reactTag, viewID, viewRecycleCount}}
        />
      </ExampleItemCard>
    </RNIWrapperView>
  );
};

const styles = StyleSheet.create({
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
});