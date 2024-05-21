import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

export type OnDidSetViewIDEventPayload = Readonly<{
  viewID: string;
  reactTag: number;
}>;

export type OnDidSetViewIDEvent = BubblingEventHandler<OnDidSetViewIDEventPayload>;

export type SharedViewEvents = {
  onDidSetViewID: OnDidSetViewIDEvent;
};
