//
//  RNIBaseViewEventEmitter.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/18/24.
//
#if __cplusplus
#include "RNIBaseViewEventEmitter.h"
#include <jsi/JSIDynamic.h>

using namespace facebook::react;

void RNIBaseViewEventEmitter::dispatchEvent(
  std::string eventName,
  folly::dynamic &dynamic
) const {

  EventEmitter::dispatchEvent(std::move(eventName), [dynamic=std::move(dynamic)](jsi::Runtime &runtime) {
    return jsi::valueFromDynamic(runtime, dynamic);;
  });
}

#endif
