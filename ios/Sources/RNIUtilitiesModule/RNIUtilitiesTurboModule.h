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

using ViewCommandRequestFunction = std::function<void(
  /* viewID     : */ std::string,
  /* commandName: */ std::string,
  /* commandArgs: */ folly::dynamic,
  /* resolve    : */ Resolve,
  /* reject     : */ Reject
)>;

using ModuleCommandRequestFunction = std::function<void(
  /* moduleName : */ std::string,
  /* commandName: */ std::string,
  /* commandArgs: */ folly::dynamic,
  /* resolve    : */ Resolve,
  /* reject     : */ Reject
)>;

using GetModuleSharedValueFunction = std::function<folly::dynamic(
  /* moduleName : */ std::string,
  /* key        : */ std::string
)>;

using SetModuleSharedValueFunction = std::function<void(
  /* moduleName : */ std::string,
  /* key        : */ std::string,
  /* value      : */ folly::dynamic
)>;

using GetModuleSharedValuesFunction = std::function<folly::dynamic(
  /* moduleName : */ std::string,
  /* key        : */ std::string
)>;

using SetModuleSharedValuesFunction = std::function<void(
  /* moduleName : */ std::string,
  /* key        : */ std::string,
  /* values     : */ folly::dynamic
)>;


class RNIUtilitiesTurboModule : public jsi::HostObject {

  static std::function<void(int)> dummyFunction_;
  static ViewCommandRequestFunction viewCommandRequest_;
  static ModuleCommandRequestFunction moduleCommandRequest_;
  static GetModuleSharedValueFunction getModuleSharedValue_;
  static SetModuleSharedValueFunction setModuleSharedValue_;
  static GetModuleSharedValuesFunction getModuleSharedValues_;
  static SetModuleSharedValuesFunction setModuleSharedValues_;

  public:
  static const char MODULE_NAME[];
  
// MARK: - Init + Deinit
// ---------------------
  
  RNIUtilitiesTurboModule(
    std::function<void(int)> dummyFunction,
    ViewCommandRequestFunction viewCommandRequest,
    ModuleCommandRequestFunction moduleCommandRequest,
    GetModuleSharedValueFunction getModuleSharedValue,
    SetModuleSharedValueFunction setModuleSharedValue,
    GetModuleSharedValuesFunction getModuleSharedValues,
    SetModuleSharedValuesFunction setModuleSharedValues
  );
  
  ~RNIUtilitiesTurboModule() override;
  
// MARK: - JSI Conformance
// -----------------------
  
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
  
// MARK: - Commands
// ----------------
  
  static jsi::Value dummyFunction(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value viewCommandRequest(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value moduleCommandRequest(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value getModuleSharedValue(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value setModuleSharedValue(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value getModuleSharedValues(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value setModuleSharedValues(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
};

};
#endif
