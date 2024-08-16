
export type KeyMapType
  <T extends string, K extends { [k in `${T}`]: any }> = K;

export type FunctionVoid = () => void;

export type KeysWithType<T, U> = 
  { [K in keyof T]: T[K] extends U ? K : never }[keyof T];