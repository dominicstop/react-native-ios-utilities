import type { OnDidSetViewIDEventPayload, OnViewWillRecycleEventPayload } from "./SharedViewEvents";


export type StateViewID = 
    OnDidSetViewIDEventPayload['viewID'] 
  | undefined;

export type StateReactTag = 
    OnDidSetViewIDEventPayload['reactTag'] 
  | undefined;

export type StateViewRecycleCount =
    OnViewWillRecycleEventPayload['recycleCount']
  | undefined;
