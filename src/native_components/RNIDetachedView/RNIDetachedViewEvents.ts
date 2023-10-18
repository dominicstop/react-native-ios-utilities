import { NativeSyntheticEvent } from 'react-native';

export type OnDetachedViewDidDetachPayload = NativeSyntheticEvent<{}>;

export type OnDetachedViewDidDetachEvent = 
  (event: OnDetachedViewDidDetachPayload) => void;
