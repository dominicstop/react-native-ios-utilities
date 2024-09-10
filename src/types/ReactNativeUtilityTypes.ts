import type { ViewProps } from "react-native";
import type { SharedViewEvents } from "./SharedViewEvents";


export type NativeComponentBaseProps<T extends SharedViewEvents> =
  Omit<T, keyof (ViewProps & SharedViewEvents)>;