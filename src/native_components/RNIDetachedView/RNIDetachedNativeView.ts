import { requireNativeViewManager } from 'expo-modules-core';
import type { RNIDetachedNativeViewProps } from './RNIDetachedNativeViewTypes';

export const RNIDetachedNativeView: React.ComponentType<RNIDetachedNativeViewProps> =
  requireNativeViewManager('RNIDetachedView');
