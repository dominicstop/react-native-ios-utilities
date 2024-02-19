
import { RNIUtilitiesModule } from "./RNIUtilitiesModule";


export type RNIUtilitiesModuleEnv = {
  debugShouldLogViewRegistryEntryRemoval?: boolean;

  overrideShouldLogFileMetadata?: boolean;
  overrideShouldLogFilePath?: boolean;
  overrideEnableLogStackTrace?: boolean;
};

export function setSharedEnvForRNIUtilitiesModule(
  env: RNIUtilitiesModuleEnv
){
  RNIUtilitiesModule.setSharedEnv<RNIUtilitiesModuleEnv>(env);  
};