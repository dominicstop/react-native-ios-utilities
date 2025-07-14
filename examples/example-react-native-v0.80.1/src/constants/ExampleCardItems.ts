import { HomeScreen } from "../components/HomeScreen";
import { AppMetadataCard } from "../examples/AppMetadataCard";

import { RNIDummyTest01Screen } from "../examples/RNIDummyTest01Screen";

import { RNIWrapperViewTest01 } from "../examples/RNIWrapperViewTest01";
import { RNIDetachedViewTest01 } from "../examples/RNIDetachedViewTest01";
import { RNIDetachedViewTest02 } from "../examples/RNIDetachedViewTest02";

import type { ExampleItemProps } from "../examples/SharedExampleTypes";
import type { RouteEntry } from "./Routes";
import { SHARED_ENV } from "./SharedEnv";


type ExampleItemBase = {
  component: unknown;
};

export type ExampleItemRoute = ExampleItemBase & RouteEntry & {
  type: 'screen';
  title?: string;
  subtitle?: string;
  desc?: Array<string>;
};

export type ExampleItemCard = ExampleItemBase & {
  type: 'card';
}

export type ExampleItem = 
  | ExampleItemRoute
  | ExampleItemCard;

export type ExampleListItem = {
  id: number;
  component: React.FC<ExampleItemProps>;
};

export const EXAMPLE_ITEMS: Array<ExampleItem> = (() => {
  const screenItems: Array<ExampleItemRoute> = [
    {
      component: HomeScreen,
      type: 'screen',
      routeKey: 'home',
      desc: [
        'Used for testing navigation events + memory leaks',
      ],
    },
    {
      component: RNIDummyTest01Screen,
      type: 'screen',
      routeKey: 'dummyTest01',
    },
  ];

  const cardItems: Array<ExampleItemCard> = [
    {
      type: 'card',
      component: RNIWrapperViewTest01,
    },
    {
      type: 'card',
      component: RNIDetachedViewTest01,
    },
    {
      type: 'card',
      component: RNIDetachedViewTest02,
    },
  ]; 

  const items: Array<ExampleItem> = [
    {
      type: 'card',
      component: AppMetadataCard,
    },
  ];

  if(SHARED_ENV.enableReactNavigation){
    items.push(...screenItems);
  };

  if(SHARED_ENV.shouldShowCardItems){
    items.push(...cardItems);
  };

  return items;
})();