import * as React from 'react';
import { StyleSheet, SafeAreaView, FlatList, ListRenderItem } from 'react-native';

import { SHARED_ENV } from '../constants/SharedEnv';

import type { ExampleItemProps } from '../examples/SharedExampleTypes';

import { RNIDetachedViewTest01 } from '../examples/RNIDetachedViewTest01';
import { ContextMenuTest01 } from '../examples/ContextMenuTest01';


type ExampleListItem = {
  id: number;
  component: React.FC<ExampleItemProps>;
};

const EXAMPLE_COMPONENTS = (() => {
  const items = [
    RNIDetachedViewTest01,
    ContextMenuTest01,
  ];

  if(SHARED_ENV.enableReactNavigation){
    // items.splice(0, 0, ...[DebugControls]);
  };

  return items;
})();

const EXAMPLE_ITEMS: ExampleListItem[] = EXAMPLE_COMPONENTS.map((item, index) => ({
  id: index + 1,
  component: item
}));

export function HomeScreen() {
  const renderItem: ListRenderItem<ExampleListItem>  = ({ item })  => (
    React.createElement(item.component, {
      index: item.id,
      style: styles.exampleListItem
    })
  );

  return (
    <SafeAreaView style={styles.rootContainer}>
      <FlatList
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContentContainer}
        data={EXAMPLE_ITEMS}
        renderItem={renderItem}
        keyExtractor={(item) => `item-${item.id}`}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
  },
  scrollView: {
    flex: 1,
  },
  scrollContentContainer: {
    paddingHorizontal: 10,
    paddingBottom: 100,
    paddingTop: 20,
  },
  exampleListItem: {
    marginBottom: 15,
  },
});