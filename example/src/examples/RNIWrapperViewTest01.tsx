/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text, View, type ViewStyle } from 'react-native';

import { CardButton, ExampleItemCard } from 'react-native-ios-utilities';
import type { ExampleItemProps } from './SharedExampleTypes';


export function RNIWrapperViewTest01(props: ExampleItemProps) { 
  return (
    <ExampleItemCard
      index={props.index}
      title={'RNIWrapperView Test 01'}
      description={[
        `TBA`
      ]}
    >
      <CardButton
        title={'placeholder'}
        subtitle={'TBA'}
        onPress={() => {
          // TBA
        }}
      />
    </ExampleItemCard>
  );
};