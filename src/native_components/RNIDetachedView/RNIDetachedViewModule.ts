import { requireNativeModule } from 'expo-modules-core';
import { NotifyOnComponentWillUnmount } from '../../types/SharedModuleFunctions';

interface RNIDetachedViewModule {
  notifyOnComponentWillUnmount: NotifyOnComponentWillUnmount;
};

export const RNIDetachedViewModule: RNIDetachedViewModule = 
  requireNativeModule('RNIDetachedView');
