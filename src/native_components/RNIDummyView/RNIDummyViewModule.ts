import { requireNativeModule } from 'expo-modules-core';
import { NotifyOnComponentWillUnmount } from '../../types/SharedModuleFunctions';

type RNIDummyViewModule = {
  notifyOnComponentWillUnmount: NotifyOnComponentWillUnmount
};

export const RNIDummyViewModule: RNIDummyViewModule = 
  requireNativeModule('RNIDummyView');
