import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { RNIDetachedView } from 'react-native-ios-utilities';

import type { ExampleItemProps } from './SharedExampleTypes';
import { ExampleItemCard } from '../components/ExampleItemCard';
import { CardButton } from '../components/Card';


export function RNIDetachedViewTest01(props: ExampleItemProps) {
  const ref = React.createRef<RNIDetachedView>();
  
  return (
    <ExampleItemCard
      index={props.index}
      title={'RNIDetachedViewTest01'}
      subtitle={'TBA'}
      description={[
        `Test - TBA`,
      ]}
    >
      <RNIDetachedView
        ref={ref}
        contentTargetMode={'subview'}
      >
        <View style={styles.detachedViewContent}>
          <Text>"RNIDetachedView Content"</Text>
        </View>
      </RNIDetachedView>
      <CardButton
        title={'Dettach and Attach to Window'}
        subtitle={'Trigger: `debugAttachToWindow`'}
        onPress={() => {
          ref?.current?.debugAttachToWindow();
        }}
      />
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  detachedViewContent: {
    width: 250,
    height: 250,
    alignSelf: 'stretch',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'red',
  },
});
