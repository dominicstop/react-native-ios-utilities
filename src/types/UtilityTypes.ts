
export type KeyMapType
  <T extends string, K extends { [k in `${T}`]: any }> = K;

export type FunctionVoid = () => void;

export type KeysWithType<T, U> = 
  { [K in keyof T]: T[K] extends U ? K : never }[keyof T];

export type UniformKeyAndValue<T extends string> = { [k in T]: k };

export type Foo<T> = 
    T extends Record<string, unknown> ? { [k in keyof T]: k }
  : T extends string ? { [k in T]: k }
  : T; 

export type UniformKeyAndValueFromObject<T extends Record<string, unknown>> = { [k in keyof T]: k };