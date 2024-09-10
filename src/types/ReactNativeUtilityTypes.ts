import type { ViewProps } from "react-native";
import type { SharedViewEvents } from "./SharedViewEvents";
import type { SharedViewEventsInternal } from "./SharedViewEventsInternal";
import type { Merge } from "./UtilityTypes";


export type NativeComponentBaseProps<T extends SharedViewEvents> =
  Omit<T, keyof (ViewProps & SharedViewEvents)>;

export type NativeComponentBasePropsInternal<
  T extends Merge<SharedViewEvents, SharedViewEventsInternal>
> = Omit<T, keyof (
    ViewProps
  & SharedViewEvents
  & SharedViewEventsInternal
)>;