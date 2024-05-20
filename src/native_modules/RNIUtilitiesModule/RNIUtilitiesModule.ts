import { NativeModules } from "react-native";

export type RNIUtilitiesModuleCommands = {
  dummyFunction: (someNumber: number) => void;
};

export const RNIUtilitiesModuleName = "RNIUtilitiesModule";

//let _isLoaded = false;
  //console.log("NativeModules: ", Object.keys(NativeModules));
  //_isLoaded = true;
  ////const result = NativeModules.SimpleJsi?.install();

//export const module = NativeModules.RNIUtilitiesModule;

export const RNIUtilitiesModule: 
     RNIUtilitiesModuleCommands = (global as any)[RNIUtilitiesModuleName]
//  ?? NativeModules[RNIUtilitiesModuleName];