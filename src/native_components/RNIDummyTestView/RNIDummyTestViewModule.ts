import { RNIUtilitiesModule, type SharedNativeValueMap } from '../../native_modules/RNIUtilitiesModule';

const MODULE_NAME = "RNIDummyTestViewModule";

async function somePromiseCommandThatWillAlwaysResolve(
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

async function somePromiseCommandThatWillAlwaysReject(){
  await RNIUtilitiesModule.moduleCommandRequest(
    MODULE_NAME,  
    "somePromiseCommandThatWillAlwaysReject",
    {}
  );
};

function overwriteModuleSharedValues(newValues: SharedNativeValueMap) {
  RNIUtilitiesModule.overwriteModuleSharedValues(
    MODULE_NAME,
    newValues
  );
};

function getAllModuleSharedValues(): {
  someNumber: number | undefined
} {
  //@ts-ignore
  return RNIUtilitiesModule.getAllModuleSharedValues(MODULE_NAME);
}

function getSharedValueSomeNumber(): number | undefined {
  return RNIUtilitiesModule.getModuleSharedValue(
    MODULE_NAME,  
    "someNumber"
  );
};

function setSharedValueSomeNumber(newValue: number | undefined){
  RNIUtilitiesModule.setModuleSharedValue(
    MODULE_NAME,  
    "someNumber",
    newValue
  );
};

export default {
  somePromiseCommandThatWillAlwaysResolve,
  somePromiseCommandThatWillAlwaysReject,
  getAllModuleSharedValues,
  overwriteModuleSharedValues,
  getSharedValueSomeNumber,
  setSharedValueSomeNumber
};