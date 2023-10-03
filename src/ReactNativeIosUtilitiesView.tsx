import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ReactNativeIosUtilitiesViewProps } from './ReactNativeIosUtilities.types';

const NativeView: React.ComponentType<ReactNativeIosUtilitiesViewProps> =
  requireNativeViewManager('ReactNativeIosUtilities');

export default function ReactNativeIosUtilitiesView(props: ReactNativeIosUtilitiesViewProps) {
  return <NativeView {...props} />;
}
