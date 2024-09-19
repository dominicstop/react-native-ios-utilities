import { RNIUtilitiesModule, type SharedNativeValueMap } from '../../native_modules/RNIUtilitiesModule';

const MODULE_NAME = "RNIDummyTestViewModule";

export class RNIDummyTestViewModule {

  static async somePromiseCommandThatWillAlwaysResolve(
    someString: string,
    someNumber: number,
    someBool: boolean,
    someObject: Record<string, unknown>,
    someArray: Array<unknown>,
    someStringOptional: string | undefined = undefined
  ): Promise<Record<string, unknown>>{

    return await RNIUtilitiesModule.moduleCommandRequest(
      MODULE_NAME,  
      "somePromiseCommandThatWillAlwaysResolve", 
      {
        someString,
        someNumber,
        someBool,
        someObject,
        someArray,
        someStringOptional
      }
    );
  };

  static async somePromiseCommandThatWillAlwaysReject(){
    await RNIUtilitiesModule.moduleCommandRequest(
      MODULE_NAME,  
      "somePromiseCommandThatWillAlwaysReject",
      {}
    );
  };

  static overwriteModuleSharedValues(newValues: SharedNativeValueMap) {
    RNIUtilitiesModule.overwriteModuleSharedValues(
      MODULE_NAME,
      newValues
    );
  };

  static getAllModuleSharedValues(): {
    someNumber: number | undefined
  } {
    //@ts-ignore
    return RNIUtilitiesModule.getAllModuleSharedValues(MODULE_NAME);
  }

  static getSharedValueSomeNumber(): number | undefined {
    return RNIUtilitiesModule.getModuleSharedValue(
      MODULE_NAME,  
      "someNumber"
    );
  };

  static setSharedValueSomeNumber(newValue: number | undefined){
    RNIUtilitiesModule.setModuleSharedValue(
      MODULE_NAME,  
      "someNumber",
      newValue
    );
  };
};