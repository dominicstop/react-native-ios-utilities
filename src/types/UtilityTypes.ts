
export type KeyMapType
  <T extends string, K extends { [k in `${T}`]: any }> = K;

export type FunctionVoid = () => void;

export type KeysWithType<T, U> = 
  { [K in keyof T]: T[K] extends U ? K : never }[keyof T];

export type UniformKeyAndValue<T extends string> = { [k in T]: k };

export type UniformKeyAndValueFromObject<T extends Record<string, unknown>> = { [k in keyof T]: k };

export type RemapObject<T, U extends Record<keyof T, unknown>> = {
  [TKey in keyof T]: U[TKey];
};

export type Merge<A, B> = {
  [K in keyof A | keyof B]: 
    K extends keyof A & keyof B
    ? A[K] | B[K]
    : K extends keyof B
    ? B[K]
    : K extends keyof A
    ? A[K]
    : never;
};

export type Merge3<A, B, C> = Merge<Merge<A, B>, C>;

export type ConvertPropertiesToAny<T> = { 
  [K in keyof T]: K extends undefined ? undefined | any : any;
};

export type Combine<T> = T extends infer U ? { [K in keyof U]: U[K] } : never 