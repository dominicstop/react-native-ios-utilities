import { requireNativeModule } from 'expo-modules-core';

interface RNIDetachedViewModule {
  debugAttachToWindow: (
    reactTag: number
  ) => Promise<void>;
};

export const RNIDetachedViewModule: RNIDetachedViewModule = 
  requireNativeModule('RNIDetachedView');
