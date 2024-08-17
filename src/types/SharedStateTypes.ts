import type { OnDidSetViewIDEventPayload } from "./SharedViewEvents";


export type StateViewID = 
    OnDidSetViewIDEventPayload['viewID'] 
  | undefined;

export type StateReactTag = 
    OnDidSetViewIDEventPayload['reactTag'] 
  | undefined;