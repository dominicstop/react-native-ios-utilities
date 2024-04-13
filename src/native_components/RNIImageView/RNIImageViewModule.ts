import { requireNativeModule } from 'expo-modules-core';

interface RNIImageViewModule {
};

export const RNIImageViewModule: RNIImageViewModule = 
  requireNativeModule('RNIImageView');
