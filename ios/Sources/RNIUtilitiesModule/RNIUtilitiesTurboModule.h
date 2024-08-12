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


class RNIUtilitiesTurboModule : public jsi::HostObject {

  // MARK: - Embedded Types
  // ----------------------
  
  public:
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

  using GetAllModuleSharedValuesFunction = std::function<folly::dynamic(
    /* moduleName: */ std::string
  )>;

  using OverwriteModuleSharedValuesFunction = std::function<void(
    /* moduleName: */ std::string,
    /* values    : */ folly::dynamic
  )>;
  
  
  // MARK: - Static Properties
  // -------------------------
  
  public:
  static const char MODULE_NAME[];
  
  static jsi::Runtime *jsRuntime;
  
  private:
  static std::function<void(int)> dummyFunction_;
  static ViewCommandRequestFunction viewCommandRequest_;
  static ModuleCommandRequestFunction moduleCommandRequest_;
  static GetModuleSharedValueFunction getModuleSharedValue_;
  static SetModuleSharedValueFunction setModuleSharedValue_;
  static GetAllModuleSharedValuesFunction getAllModuleSharedValues_;
  static OverwriteModuleSharedValuesFunction overwriteModuleSharedValues_;

    
// MARK: - Init + De-Init
// ---------------------
  
  public:
  RNIUtilitiesTurboModule();
  
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
  
// MARK: - Static Functions
// ------------------------
  
  static void registerCommands(
    std::function<void(int)> dummyFunction,
    ViewCommandRequestFunction viewCommandRequest,
    ModuleCommandRequestFunction moduleCommandRequest,
    GetModuleSharedValueFunction getModuleSharedValue,
    SetModuleSharedValueFunction setModuleSharedValue,
    GetAllModuleSharedValuesFunction getAllModuleSharedValues,
    OverwriteModuleSharedValuesFunction overwriteModuleSharedValues
  );
  
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
  
  static jsi::Value getAllModuleSharedValues(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
  
  static jsi::Value overwriteModuleSharedValues(
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *arguments,
    size_t count
  );
};

}; // namespace RNIUtilities
#endif
