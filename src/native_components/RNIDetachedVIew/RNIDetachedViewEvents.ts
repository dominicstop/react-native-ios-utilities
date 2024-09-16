
import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import type { OnDidSetViewIDEventPayload } from '../../types/SharedViewEvents';


export type OnContentViewDidDetachEventPayload = Readonly<{}>;

export type OnContentViewDidDetachEvent = 
  BubblingEventHandler<OnContentViewDidDetachEventPayload>;
export type OnViewDidDetachFromParentPayload = Readonly<{}>;

export type OnViewDidDetachFromParentEvent = 
  BubblingEventHandler<OnViewDidDetachFromParentPayload>