import type { LegacyRef, Ref } from "react";
import type { ViewProps } from "react-native";

import type { WrapperView } from "./WrapperView";

export type WrapperViewBaseProps = {
  ref: (
    | Ref<WrapperView>
    | LegacyRef<WrapperView> 
    | undefined
  );
};

export type WrapperViewProps = 
  & WrapperViewBaseProps
  & Exclude<ViewProps, 'ref'>;