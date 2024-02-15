import { requireNativeModule } from 'expo-modules-core';


interface RNIUtilitiesModule {
  notifyOnJavascriptModuleDidLoad(): void;

  setSharedEnv<T extends object>(env: T);

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

RNIUtilitiesModule.notifyOnJavascriptModuleDidLoad();