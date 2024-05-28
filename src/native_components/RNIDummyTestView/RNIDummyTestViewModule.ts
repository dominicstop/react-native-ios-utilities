import { RNIUtilitiesModule } from '../../native_modules/RNIUtilitiesModule';

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
  getSharedValueSomeNumber,
  setSharedValueSomeNumber
};