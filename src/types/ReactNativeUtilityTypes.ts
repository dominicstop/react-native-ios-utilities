import type { ViewProps } from "react-native";
import type { SharedViewEvents } from "./SharedViewEvents";
import type { SharedViewEventsInternal } from "./SharedViewEventsInternal";
import type { SharedViewPropsInternal } from "./SharedViewPropsInternal";
import type { ConvertPropertiesToAny, Merge3 } from "./UtilityTypes";


export type NativeComponentBaseProps<T extends SharedViewEvents> =
  Omit<T, keyof (ViewProps & SharedViewEvents)>;

export type Combine<T> = { [K in keyof T]: K };

export type NativeComponentBasePropsInternal<T extends Merge3<
    ConvertPropertiesToAny<SharedViewEvents>, 
    ConvertPropertiesToAny<SharedViewEventsInternal>,
    ConvertPropertiesToAny<SharedViewPropsInternal>
>> = Omit<T, keyof (
    ViewProps
  & SharedViewPropsInternal
  & SharedViewEvents
  & SharedViewEventsInternal
)>;