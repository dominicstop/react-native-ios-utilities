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

export default {
  somePromiseCommandThatWillAlwaysResolve,
  somePromiseCommandThatWillAlwaysReject
};