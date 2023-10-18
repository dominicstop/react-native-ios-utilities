import type { LegacyRef, MutableRefObject, Ref } from "react";
import type { ViewProps } from "react-native";

import type { WrapperView } from "./WrapperView";

export type WrapperViewBaseProps = {
  ref: (
    | Ref<WrapperView>
    | LegacyRef<WrapperView> 
    | MutableRefObject<WrapperView>
    | undefined
  );
};

export type WrapperViewProps = 
  & WrapperViewBaseProps
  & Exclude<ViewProps, 'ref'>;