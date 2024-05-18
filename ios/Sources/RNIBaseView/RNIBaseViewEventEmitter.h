//
//  RNIBaseViewEventEmitter.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/18/24.
//
#if __cplusplus
#pragma once

#include <react/renderer/components/view/ViewEventEmitter.h>
#include <jsi/jsi.h>
#include <folly/dynamic.h>


namespace facebook::react {

class RNIBaseViewEventEmitter : public ViewEventEmitter {
 public:
  using ViewEventEmitter::ViewEventEmitter;

  void dispatchEvent(
    std::string eventName,
    folly::dynamic &dynamic
  ) const;
};

}
#endif
