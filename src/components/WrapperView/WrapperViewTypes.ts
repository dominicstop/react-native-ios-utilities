import type { LegacyRef } from "react";
import type { ViewProps } from "react-native";

import type { WrapperView } from "./WrapperView";

export type WrapperViewBaseProps = {
  ref: LegacyRef<WrapperView> | undefined;
};

export type WrapperViewProps = 
  & WrapperViewBaseProps
  & Exclude<ViewProps, 'ref'>;