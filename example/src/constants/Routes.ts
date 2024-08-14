import { HomeScreen } from "../examples/HomeScreen";
import { RNIDummyTest01Screen } from "../examples/RNIDummyTest01Screen";
import type { RouteKey } from "./RouteKeys";


export type RouteEntry = {
  routeKey: RouteKey
  component: React.ComponentType<{}>;
};

export const ROUTE_ITEMS: Array<RouteEntry> = [{
  routeKey: 'home',
  component: HomeScreen,
}, {
  routeKey: 'dummyTest01',
  component: RNIDummyTest01Screen,
}];

export const ROUTE_MAP: Record<RouteKey, RouteEntry> = (() => {
  const map: Record<string, RouteEntry> = {};

  for (const routeItem of ROUTE_ITEMS) {
    map[routeItem.routeKey] = routeItem;
  };

  return map;
})();