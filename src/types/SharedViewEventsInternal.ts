import type { BubblingEventHandler } from "react-native/Libraries/Types/CodegenTypes";


export type OnRawNativeEventEventPayload = Readonly<{
  eventName: string;
  eventPayload?: Record<string, unknown>;
  shouldPropagate: boolean;
}>;

export type OnRawNativeEventEvent = BubblingEventHandler<OnRawNativeEventEventPayload>;

export type SharedViewEventsInternal = {
  onRawNativeEvent?: OnRawNativeEventEvent;
};