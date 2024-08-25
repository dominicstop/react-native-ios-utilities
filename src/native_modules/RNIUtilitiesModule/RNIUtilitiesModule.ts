import { default as NativeRNIUtilitiesModule } from './NativeRNIUtilitiesModule';
import type { SharedNativeValueMap, SupportedNativeSharedValue } from './RNIUtilitiesModuleTypes';

// modules are lazily loaded, so "reading" it's value triggers 
// the module to load in the native side.
NativeRNIUtilitiesModule;

const RNIUtilitiesModuleName = "RNIUtilitiesModule";
const RNIUtilitiesModuleNative = (global as any)[RNIUtilitiesModuleName];

export class RNIUtilitiesModule {

  static async viewCommandRequest<T = Record<string, unknown>>(
    viewID: string,
    commandName: string,
    commandArgs: Record<string, any>
  ): Promise<T> {

    if(RNIUtilitiesModuleNative == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleNative.viewCommandRequest == null){
      throw "RNIUtilitiesModule.viewCommandRequest is null";
    };

    return await RNIUtilitiesModuleNative.viewCommandRequest(
      viewID,
      commandName,
      commandArgs
    );
  };

  static async moduleCommandRequest<T = Record<string, unknown>>(
    moduleName: string,
    commandName: string,
    commandArgs: Record<string, any>
  ): Promise<T> {

    if(RNIUtilitiesModuleNative == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleNative.moduleCommandRequest == null){
      throw "RNIUtilitiesModule.moduleCommandRequest is null";
    };

    return await RNIUtilitiesModuleNative.moduleCommandRequest(
      moduleName,
      commandName,
      commandArgs
    );
  };

  static getModuleSharedValue<T = SupportedNativeSharedValue>(
    moduleName: string,
    key: string,
  ): T {
    if(RNIUtilitiesModuleNative == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleNative.getModuleSharedValue == null){
      throw "RNIUtilitiesModule.getModuleSharedValue is null";
    };

    return RNIUtilitiesModuleNative.getModuleSharedValue(moduleName, key);
  };

  static setModuleSharedValue(
    moduleName: string,
    key: string,
    newValue: SupportedNativeSharedValue
  ){
    if(RNIUtilitiesModuleNative == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleNative.getModuleSharedValue == null){
      throw "RNIUtilitiesModule.setModuleSharedValue is null";
    };

    return RNIUtilitiesModuleNative.setModuleSharedValue(moduleName, key, newValue);
  };

  static getAllModuleSharedValues(
    moduleName: string
  ): SharedNativeValueMap {

    if(RNIUtilitiesModuleNative == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleNative.getAllModuleSharedValues == null){
      throw "RNIUtilitiesModule.getAllModuleSharedValues is null";
    };

    return RNIUtilitiesModuleNative.getAllModuleSharedValues(moduleName);
  };

  static overwriteModuleSharedValues(
    moduleName: string,
    newValues: SharedNativeValueMap
  ) {
    if(RNIUtilitiesModuleNative == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleNative.overwriteModuleSharedValues == null){
      throw "RNIUtilitiesModule.overwriteModuleSharedValues is null";
    };

    return RNIUtilitiesModuleNative.overwriteModuleSharedValues(moduleName, newValues);
  };
};