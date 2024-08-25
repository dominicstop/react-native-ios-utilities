import { default as NativeRNIUtilitiesModule } from './NativeRNIUtilitiesModule';
import type { SharedNativeValueMap, SupportedNativeSharedValue } from './RNIUtilitiesModuleTypes';

// modules are lazily loaded, so "reading" it's value triggers 
// the module to load in the native side.
NativeRNIUtilitiesModule;

const RNIUtilitiesModuleName = "RNIUtilitiesModule";
const RNIUtilitiesModule = (global as any)[RNIUtilitiesModuleName];

async function viewCommandRequest<T = Record<string, unknown>>(
  viewID: string,
  commandName: string,
  commandArgs: Record<string, any>
): Promise<T> {

  if(RNIUtilitiesModule == null){
    throw "RNIUtilitiesModule is null";
  };

  if(RNIUtilitiesModule.viewCommandRequest == null){
    throw "RNIUtilitiesModule.viewCommandRequest is null";
  };

  return await RNIUtilitiesModule.viewCommandRequest(
    viewID,
    commandName,
    commandArgs
  );
};

async function moduleCommandRequest<T = Record<string, unknown>>(
  moduleName: string,
  commandName: string,
  commandArgs: Record<string, any>
): Promise<T> {

  if(RNIUtilitiesModule == null){
    throw "RNIUtilitiesModule is null";
  };

  if(RNIUtilitiesModule.moduleCommandRequest == null){
    throw "RNIUtilitiesModule.moduleCommandRequest is null";
  };

  return await RNIUtilitiesModule.moduleCommandRequest(
    moduleName,
    commandName,
    commandArgs
  );
};

function getModuleSharedValue<T = SupportedNativeSharedValue>(
  moduleName: string,
  key: string,
): T {
  if(RNIUtilitiesModule == null){
    throw "RNIUtilitiesModule is null";
  };

  if(RNIUtilitiesModule.getModuleSharedValue == null){
    throw "RNIUtilitiesModule.getModuleSharedValue is null";
  };

  return RNIUtilitiesModule.getModuleSharedValue(moduleName, key);
};

function setModuleSharedValue(
  moduleName: string,
  key: string,
  newValue: SupportedNativeSharedValue
){
  if(RNIUtilitiesModule == null){
    throw "RNIUtilitiesModule is null";
  };

  if(RNIUtilitiesModule.getModuleSharedValue == null){
    throw "RNIUtilitiesModule.setModuleSharedValue is null";
  };

  return RNIUtilitiesModule.setModuleSharedValue(moduleName, key, newValue);
};

function getAllModuleSharedValues(
  moduleName: string
): SharedNativeValueMap {

  if(RNIUtilitiesModule == null){
    throw "RNIUtilitiesModule is null";
  };

  if(RNIUtilitiesModule.getAllModuleSharedValues == null){
    throw "RNIUtilitiesModule.getAllModuleSharedValues is null";
  };

  return RNIUtilitiesModule.getAllModuleSharedValues(moduleName);
};

function overwriteModuleSharedValues(
  moduleName: string,
  newValues: SharedNativeValueMap
) {
  if(RNIUtilitiesModule == null){
    throw "RNIUtilitiesModule is null";
  };

  if(RNIUtilitiesModule.overwriteModuleSharedValues == null){
    throw "RNIUtilitiesModule.overwriteModuleSharedValues is null";
  };

  return RNIUtilitiesModule.overwriteModuleSharedValues(moduleName, newValues);
};

export default {
  viewCommandRequest,
  moduleCommandRequest,
  getModuleSharedValue,
  setModuleSharedValue,
  getAllModuleSharedValues,
  overwriteModuleSharedValues
};