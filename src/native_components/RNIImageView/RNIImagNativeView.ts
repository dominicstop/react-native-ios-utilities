
import { requireNativeViewManager } from 'expo-modules-core';
import type { RNIImageNativeViewProps } from './RNIImageNativeViewTypes';

export const RNIImageNativeView: React.ComponentType<RNIImageNativeViewProps> =
  requireNativeViewManager('RNIImageView');
