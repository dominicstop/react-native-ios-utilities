import { requireNativeModule } from 'expo-modules-core';

interface RNIDetachedViewModule {
  notifyComponentWillUnmount(
    reactTag: number,
    isManuallyTriggered: boolean
  ): void;
};

export const RNIDetachedViewModule: RNIDetachedViewModule = 
  requireNativeModule('RNIDetachedView');
