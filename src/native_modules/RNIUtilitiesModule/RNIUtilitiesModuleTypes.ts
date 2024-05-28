
export type SupportedNativePrimitiveSharedValue = 
  | string
  | number
  | boolean
  | null
  | undefined;

export type SupportedNativeSharedValue = 
  | SupportedNativePrimitiveSharedValue
  | Record<string, SupportedNativePrimitiveSharedValue>
  | Array<SupportedNativePrimitiveSharedValue>;

export type SharedNativeValueMap = Record<string, SupportedNativeSharedValue>;