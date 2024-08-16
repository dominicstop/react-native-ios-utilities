import type * as React from "react";

export type RefProp<T> = 
    | React.Ref<T>
    | React.LegacyRef<T> 
    | React.MutableRefObject<T | undefined>
    | undefined;