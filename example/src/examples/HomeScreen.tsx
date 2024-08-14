import * as React from "react";
import {
  StyleSheet,
  SafeAreaView,
  FlatList,
  type ListRenderItem,
  type ViewStyle,
} from "react-native";

import { CardButton, ExampleItemCard } from "react-native-ios-utilities";
import { useNavigation } from "@react-navigation/native";

import { SHARED_ENV } from "../constants/SharedEnv";
import { EXAMPLE_ITEMS, type ExampleListItem } from "../constants/ExampleCardItems";


const EXAMPLE_LIST_ITEMS = EXAMPLE_ITEMS.map(
  (item, index) => {
    switch(item.type) {
      case 'screen':
        return ({
          id: index + 1,
          component: (props: Record<string, unknown>) => {
            // @ts-ignore
            // eslint-disable-next-line react-hooks/rules-of-hooks
            const navigation = SHARED_ENV.enableReactNavigation && useNavigation();
            
            return (
              <ExampleItemCard
                {...{props}}
                index={index + 1}
                title={'RNIDetachedViewTest01'}
                subtitle={'TBA'}
                description={item.desc}
              >
                <CardButton
                  title="Navigate"
                  subtitle={`Push: ${item.routeKey}`}
                  onPress={() => {
                    // @ts-ignore
                    navigation?.push(item.routeKey);
                  }}
                />
              </ExampleItemCard>
            );
          },
        });
      
      default:
        return ({
          id: index + 1,
          component: item.component as any,
        });
    };
  }
);

export function ExampleList(props: {
  style: ViewStyle;
  contentContainerStyle: ViewStyle;
}) {
  const renderItem: ListRenderItem<ExampleListItem> = ({item}) => (
    React.createElement(item.component, {
      index: item.id,
      style: styles.exampleListItem,
    })
  );

  return (
    <FlatList
      style={props.style}
      contentContainerStyle={props.contentContainerStyle}
      data={EXAMPLE_LIST_ITEMS}
      renderItem={renderItem}
      keyExtractor={(item) => `item-${item.id}`}
    />
  );
}

export function HomeScreen() {
  return (
    <SafeAreaView style={styles.rootContainer}>
      <ExampleList
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContentContainer}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
    backgroundColor: 'white',
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
