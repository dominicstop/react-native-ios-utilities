import { default as NativeRNIUtilitiesModule } from './NativeRNIUtilitiesModule';
import type { SharedNativeValueMap, SupportedNativeSharedValue } from './RNIUtilitiesModuleTypes';

// modules are lazily loaded, so "reading" it's value triggers 
// the module to load in the native side.
NativeRNIUtilitiesModule;

const RNIUtilitiesModuleName = "RNIUtilitiesModule";
const RNIUtilitiesModuleRef = (global as any)[RNIUtilitiesModuleName];

export class RNIUtilitiesModule {

  static async viewCommandRequest<T = Record<string, unknown>>(
    viewID: string,
    commandName: string,
    commandArgs: Record<string, any>
  ): Promise<T> {

    if(RNIUtilitiesModuleRef == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleRef.viewCommandRequest == null){
      throw "RNIUtilitiesModule.viewCommandRequest is null";
    };

    return await RNIUtilitiesModuleRef.viewCommandRequest(
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

    if(RNIUtilitiesModuleRef == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleRef.moduleCommandRequest == null){
      throw "RNIUtilitiesModule.moduleCommandRequest is null";
    };

    return await RNIUtilitiesModuleRef.moduleCommandRequest(
      moduleName,
      commandName,
      commandArgs
    );
  };

  static getModuleSharedValue<T = SupportedNativeSharedValue>(
    moduleName: string,
    key: string,
  ): T {
    if(RNIUtilitiesModuleRef == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleRef.getModuleSharedValue == null){
      throw "RNIUtilitiesModule.getModuleSharedValue is null";
    };

    return RNIUtilitiesModuleRef.getModuleSharedValue(moduleName, key);
  };

  static setModuleSharedValue(
    moduleName: string,
    key: string,
    newValue: SupportedNativeSharedValue
  ){

    if(RNIUtilitiesModuleRef == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleRef.getModuleSharedValue == null){
      throw "RNIUtilitiesModule.setModuleSharedValue is null";
    };

    return RNIUtilitiesModuleRef.setModuleSharedValue(moduleName, key, newValue);
  };

  static getAllModuleSharedValues(
    moduleName: string
  ): SharedNativeValueMap {

    if(RNIUtilitiesModuleRef == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleRef.getAllModuleSharedValues == null){
      throw "RNIUtilitiesModule.getAllModuleSharedValues is null";
    };

    return RNIUtilitiesModuleRef.getAllModuleSharedValues(moduleName);
  };

  static overwriteModuleSharedValues(
    moduleName: string,
    newValues: SharedNativeValueMap
  ){
    
    if(RNIUtilitiesModuleRef == null){
      throw "RNIUtilitiesModule is null";
    };

    if(RNIUtilitiesModuleRef.overwriteModuleSharedValues == null){
      throw "RNIUtilitiesModule.overwriteModuleSharedValues is null";
    };

    return RNIUtilitiesModuleRef.overwriteModuleSharedValues(moduleName, newValues);
  };
};