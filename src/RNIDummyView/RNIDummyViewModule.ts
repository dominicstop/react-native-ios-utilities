import { requireNativeModule } from 'expo-modules-core';
import { NotifyComponentWillUnmount } from '../types/SharedModuleFunctions';

type RNIDummyViewModule = {
  notifyComponentWillUnmount: NotifyComponentWillUnmount
};

export const RNIDummyViewModule: RNIDummyViewModule = 
  requireNativeModule('RNIDummyView');
