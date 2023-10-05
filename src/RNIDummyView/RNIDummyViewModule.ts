import { requireNativeModule } from 'expo-modules-core';

interface RNIDummyViewModule {
  notifyComponentWillUnmount(
    reactTag: number,
    isManuallyTriggered: boolean
  ): void;
};

export const RNIDummyViewModule: RNIDummyViewModule = 
  requireNativeModule('RNIDummyView');
