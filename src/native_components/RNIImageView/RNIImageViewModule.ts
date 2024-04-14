import { requireNativeModule } from 'expo-modules-core';

interface RNIImageViewModule {
  getAllSFSymbols: () => Promise<Record<string, Array<string>>>;
};

export const RNIImageViewModule: RNIImageViewModule = 
  requireNativeModule('RNIImageView');
