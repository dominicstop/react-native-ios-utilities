import { NativeSyntheticEvent } from 'react-native';

export type OnReactTagDidSetEventPayload = NativeSyntheticEvent<{
  reactTag?: number;
}>;

export type OnReactTagDidSetEvent = 
  (event: OnReactTagDidSetEventPayload) => void;