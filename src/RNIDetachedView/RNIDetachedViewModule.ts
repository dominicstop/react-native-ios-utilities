import { requireNativeModule } from 'expo-modules-core';
import { NotifyComponentWillUnmount } from '../types/SharedModuleFunctions';

interface RNIDetachedViewModule {
  notifyComponentWillUnmount: NotifyComponentWillUnmount;
};

export const RNIDetachedViewModule: RNIDetachedViewModule = 
  requireNativeModule('RNIDetachedView');
