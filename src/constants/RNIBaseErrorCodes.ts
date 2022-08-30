import type { RNIBaseErrorCode } from "src/types/RNIError";


export const RNIBaseErrorCodes: {
  [key in RNIBaseErrorCode]: key;
} = {
  runtimeError   : 'runtimeError'   ,
  libraryError   : 'libraryError'   ,
  reactError     : 'reactError'     ,
  unknownError   : 'unknownError'   ,
  invalidArgument: 'invalidArgument',
  outOfBounds    : 'outOfBounds'    ,
  invalidReactTag: 'invalidReactTag',
  nilValue       : 'nilValue'       ,
};