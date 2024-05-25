import { type TurboModule, TurboModuleRegistry } from "react-native";

// stub
export interface Spec extends TurboModule {
}

export default TurboModuleRegistry.get<Spec>("RNIUtilitiesModule") as Spec | null;