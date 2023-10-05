import { requireNativeViewManager } from 'expo-modules-core';
import type { RNIDummyNativeViewProps } from './RNIDummyNativeViewTypes';

export const RNIDummyNativeView: React.ComponentType<RNIDummyNativeViewProps> =
  requireNativeViewManager('RNIDummyView');
