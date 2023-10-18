import type * as React from "react";
import type { ViewProps } from "react-native";

import type { WrapperView } from "./WrapperView";

export type WrapperViewBaseProps = {
  ref: (
    | React.Ref<WrapperView>
    | React.LegacyRef<WrapperView> 
    | React.MutableRefObject<WrapperView | undefined>
    | undefined
  );
};

export type WrapperViewProps = 
  & WrapperViewBaseProps
  & Exclude<ViewProps, 'ref'>;