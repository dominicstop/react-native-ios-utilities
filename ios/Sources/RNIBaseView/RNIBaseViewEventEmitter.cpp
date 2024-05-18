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
  EventEmitter::dispatchEvent(eventName, [&](jsi::Runtime &runtime) {
    auto $payload = jsi::Object(runtime);
    jsi::valueFromDynamic(runtime, dynamic);
    return $payload;
  });
}

#endif
