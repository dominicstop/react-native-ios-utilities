import { requireNativeModule } from 'expo-modules-core';
import { NotifyOnComponentWillUnmount } from '../../types/SharedModuleFunctions';

interface RNIDetachedViewModule {
  notifyOnComponentWillUnmount: NotifyOnComponentWillUnmount;
  
  debugAttachToWindow: (
    reactTag: number
  ) => Promise<void>;
};

export const RNIDetachedViewModule: RNIDetachedViewModule = 
  requireNativeModule('RNIDetachedView');
