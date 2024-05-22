import { default as NativeRNIUtilitiesModule } from './NativeRNIUtilitiesModule';

// modules are lazily loaded, so "reading" it's value triggers 
// the module to load in the native side.
NativeRNIUtilitiesModule;

export type RNIUtilitiesModuleCommands = {
  dummyFunction: (someNumber: number) => void;
  viewCommandRequest: (
    viewID: string,
    commandArgs: Record<string, any>
  ) => Promise<void>;
};

export const RNIUtilitiesModuleName = "RNIUtilitiesModule";

export const RNIUtilitiesModule: 
  RNIUtilitiesModuleCommands = (global as any)[RNIUtilitiesModuleName];