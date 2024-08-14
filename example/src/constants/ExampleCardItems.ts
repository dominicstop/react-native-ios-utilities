import { RNIDummyTest01Screen } from "../examples/RNIDummyTest01Screen";
import type { ExampleItemProps } from "../examples/SharedExampleTypes";
import type { RouteEntry } from "./Routes";

type ExampleItemBase = {
  component: unknown;
  desc?: Array<string>;
};

export type ExampleItemRoute = ExampleItemBase & RouteEntry & {
  type: 'screen';
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
  const screenItems: Array<ExampleItemRoute> = [{
    component: RNIDummyTest01Screen,
    type: 'screen',
    routeKey: 'dummyTest01',
  }];

  const cardItems: Array<ExampleItemCard> = []; 

  // if (SHARED_ENV.enableReactNavigation) {
  //   items.splice(0, 0, ...[DebugControls]);
  // }

  return [...screenItems, ...cardItems];
})();