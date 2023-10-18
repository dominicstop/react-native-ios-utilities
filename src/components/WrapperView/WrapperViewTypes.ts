import type * as React from "react";
import type { ViewProps } from "react-native";

import type { WrapperView } from "./WrapperView";
import type { RefProp } from "../../types/SharedPropTypes";

export type WrapperViewBaseProps = {
  ref: RefProp<WrapperView>;
};

export type WrapperViewProps = 
  & WrapperViewBaseProps
  & Exclude<ViewProps, 'ref'>;