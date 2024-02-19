import React from 'react';

import { HomeScreen } from './src/screens/HomeScreen';
import { setSharedEnvForRNICleanableViewRegistry, setSharedEnvForRNIUtilitiesModule } from 'react-native-ios-utilities';

export default function App() {
  return (
    <HomeScreen/>
  );
};

setSharedEnvForRNIUtilitiesModule({
  debugShouldLogViewRegistryEntryRemoval: true,
  overrideEnableLogStackTrace: true,
  overrideShouldLogFileMetadata: true,
  overrideShouldLogFilePath: true
});

setSharedEnvForRNICleanableViewRegistry({
  debugShouldLogCleanup: true,
  debugShouldLogRegister: true,
});