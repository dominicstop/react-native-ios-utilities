import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

export type OnDidSetViewIDEventPayload = Readonly<{
  viewID: string;
  reactTag: number;
  recycleCount: number;
}>;

export type OnDidSetViewIDEvent = BubblingEventHandler<OnDidSetViewIDEventPayload>;

export type OnViewWillRecycleEventPayload = Readonly<{
  recycleCount: number;
}>;

export type OnViewWillRecycleEvent = BubblingEventHandler<OnViewWillRecycleEventPayload>;

export type SharedViewEvents = {
  onDidSetViewID?: OnDidSetViewIDEvent;
  onViewWillRecycle?: OnViewWillRecycleEvent;
};
