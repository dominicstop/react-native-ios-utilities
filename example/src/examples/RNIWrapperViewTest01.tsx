import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, WrapperView, type OnDidSetViewIDEventPayload, ObjectPropertyDisplay, Colors } from 'react-native-ios-utilities';
import type { ExampleItemProps } from './SharedExampleTypes';


export function RNIWrapperViewTest01(props: ExampleItemProps) {
  const [reactTag, setReactTag] = 
    React.useState<OnDidSetViewIDEventPayload['reactTag'] | undefined>();

  const [viewID, setViewID] = 
    React.useState<OnDidSetViewIDEventPayload['viewID'] | undefined>();
  
  return (
    <WrapperView
      onDidSetViewID={({nativeEvent}) => {
        setReactTag(nativeEvent.reactTag);
        setViewID(nativeEvent.viewID);
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
          object={{reactTag, viewID}}
        />
      </ExampleItemCard>
    </WrapperView>
  );
};

const styles = StyleSheet.create({
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
});