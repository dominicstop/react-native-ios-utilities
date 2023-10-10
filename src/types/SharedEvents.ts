
export type OnReactTagDidSetEventPayload = {
  reactTag?: number;
};

export type OnReactTagDidSetEvent = (event: { 
  nativeEvent: OnReactTagDidSetEventPayload 
}) => void;