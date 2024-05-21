//
//  RNICxxUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/22/24.
//

#if __cplusplus
#pragma once

namespace RNIUtilities {

#define RNI_DEBUG_STRING (               \
    "Function: "                         \
  + std::string(__FUNCTION__)            \
  + " - File: "                          \
  + std::string(__FILE_NAME__)           \
  + " - Line: "                          \
  + std::to_string(__LINE__)             \
)                                        \

#define RNI_DEBUG_MESSAGE(debugMessage) ( \
    "Function: "                         \
  + std::string(__FUNCTION__)            \
  + " - Message: " + debugMessage        \
  + " - File: "                          \
  + std::string(__FILE_NAME__)           \
  + " - Line: "                          \
  + std::to_string(__LINE__)             \
)                                        \

}
#endif
