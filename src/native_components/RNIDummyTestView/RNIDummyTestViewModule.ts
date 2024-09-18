import { RNIUtilitiesModule, type SharedNativeValueMap } from '../../native_modules/RNIUtilitiesModule';

const MODULE_NAME = "RNIDummyTestViewModule";

export async function somePromiseCommandThatWillAlwaysResolve(
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

export async function somePromiseCommandThatWillAlwaysReject(){
  await RNIUtilitiesModule.moduleCommandRequest(
    MODULE_NAME,  
    "somePromiseCommandThatWillAlwaysReject",
    {}
  );
};

export function overwriteModuleSharedValues(newValues: SharedNativeValueMap) {
  RNIUtilitiesModule.overwriteModuleSharedValues(
    MODULE_NAME,
    newValues
  );
};

export function getAllModuleSharedValues(): {
  someNumber: number | undefined
} {
  //@ts-ignore
  return RNIUtilitiesModule.getAllModuleSharedValues(MODULE_NAME);
}

export function getSharedValueSomeNumber(): number | undefined {
  return RNIUtilitiesModule.getModuleSharedValue(
    MODULE_NAME,  
    "someNumber"
  );
};

export function setSharedValueSomeNumber(newValue: number | undefined){
  RNIUtilitiesModule.setModuleSharedValue(
    MODULE_NAME,  
    "someNumber",
    newValue
  );
};