import { requireNativeModule } from 'expo-modules-core';


interface RNIUtilitiesModule  {
  notifyOnComponentWillUnmount(
    node: number,
    commandParams: {
      shouldForceCleanup: boolean;
      shouldIgnoreCleanupTriggers: boolean;
    }
  ): Promise<void>;
};

export const RNIUtilitiesModule: RNIUtilitiesModule = 
  requireNativeModule('RNIUtilitiesModule');
