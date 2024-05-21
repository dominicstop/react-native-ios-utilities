//
//  RNIUtilitiesTurboModule.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if __cplusplus
#pragma once
#include <jsi/jsi.h>
#include <folly/dynamic.h>


using namespace facebook;

namespace RNIUtilities {

using Resolve = std::function<void(folly::dynamic)>;
using Reject = std::function<void(const std::string&)>;
using Promise = std::function<void(Resolve, Reject)>;

class RNIUtilitiesTurboModule : public jsi::HostObject {

static std::function<void(int)> dummyFunction_;
static Promise functionThatReturnsPromise_;

 public:
  static const char MODULE_NAME[];
  
  RNIUtilitiesTurboModule(
    std::function<void(int)> dummyFunction,
    Promise functionThatReturnsPromise
  );
  
  ~RNIUtilitiesTurboModule() override;
  
  void set(
    jsi::Runtime &,
    const jsi::PropNameID &,
    const jsi::Value &
  ) override;
  
  jsi::Value get(
    jsi::Runtime &rt,
    const jsi::PropNameID &name
  ) override;
  
  std::vector<jsi::PropNameID> getPropertyNames(
    jsi::Runtime &rt
  ) override;
  
  static jsi::Value dummyFunction(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value functionThatReturnsPromise(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
};

};
#endif
