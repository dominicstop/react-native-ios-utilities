import { RNIUtilitiesModule } from "../modules/RNIUtilitiesModule";


export type RNICleanableViewRegistryEnv = {
  shouldGloballyDisableCleanup?: boolean;
  shouldAllowForceCleanup?: boolean;
  shouldIncludeDelegateInViewsToCleanupByDefault?: boolean;
  shouldProceedCleanupWhenDelegateIsNilByDefault?: boolean;
  shouldUseUIManagerQueueForCleanup?: boolean;
  debugShouldLogCleanup?: boolean;
  debugShouldLogRegister?: boolean;
};

export function setSharedEnvForRNICleanableViewRegistry(
  env: RNICleanableViewRegistryEnv
){
  RNIUtilitiesModule.setSharedEnv<RNICleanableViewRegistryEnv>(env);  
};