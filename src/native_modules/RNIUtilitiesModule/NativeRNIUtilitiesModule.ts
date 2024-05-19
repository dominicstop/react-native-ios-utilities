import { type TurboModule, TurboModuleRegistry } from "react-native";

export interface Spec extends TurboModule {
  //add(a: number, b: number): Promise<number>;
  //commandThatAcceptsObject(someObject: Object): Promise<number>;
}

// NativeRNIDummyTestViewModule
// RNIDummyTestViewModule
// NativeRNIDummyTestViewModuleSpec 


export default TurboModuleRegistry.get<Spec>("RNIUtilitiesModule") as Spec | null;