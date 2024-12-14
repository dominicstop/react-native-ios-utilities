//
//  RNIUtilitiesTurboModule.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if __cplusplus
#include "RNIUtilitiesTurboModule.h"
#include "RNICxxUtils.h"

#include <jsi/JSIDynamic.h>
#include <string>

#if DEBUG
#include <iostream>
#endif

using namespace facebook;

namespace RNIUtilities {

// MARK: - Static Properties
// -------------------------

jsi::Runtime *RNIUtilitiesTurboModule::jsRuntime;

std::function<void(int)> RNIUtilitiesTurboModule::dummyFunction_;

RNIUtilitiesTurboModule::ViewCommandRequestFunction
  RNIUtilitiesTurboModule::viewCommandRequest_;
  
RNIUtilitiesTurboModule::ModuleCommandRequestFunction
  RNIUtilitiesTurboModule::moduleCommandRequest_;
  
RNIUtilitiesTurboModule::GetModuleSharedValueFunction
  RNIUtilitiesTurboModule::getModuleSharedValue_;
  
RNIUtilitiesTurboModule::SetModuleSharedValueFunction
  RNIUtilitiesTurboModule::setModuleSharedValue_;

RNIUtilitiesTurboModule::GetAllModuleSharedValuesFunction
  RNIUtilitiesTurboModule::getAllModuleSharedValues_;
  
RNIUtilitiesTurboModule::OverwriteModuleSharedValuesFunction
  RNIUtilitiesTurboModule::overwriteModuleSharedValues_;
  
const char RNIUtilitiesTurboModule::MODULE_NAME[] = "RNIUtilitiesModule";

// MARK: - Init + De-Init
// ---------------------

RNIUtilitiesTurboModule::RNIUtilitiesTurboModule() {
  // no-op
}

RNIUtilitiesTurboModule::~RNIUtilitiesTurboModule(){
  // no-op
};

// MARK: - JSI Conformance
// -----------------------

jsi::Value RNIUtilitiesTurboModule::get(
  jsi::Runtime &rt,
  const jsi::PropNameID &name
) {

  auto propName = name.utf8(rt);
  if (propName == "dummyFunction") {
    return jsi::Function::createFromHostFunction(rt, name, 1, dummyFunction);
  };
  
  if(propName == "viewCommandRequest"){
    return jsi::Function::createFromHostFunction(rt, name, 3, viewCommandRequest);
  };
  
  if(propName == "moduleCommandRequest"){
    return jsi::Function::createFromHostFunction(rt, name, 3, moduleCommandRequest);
  };
  
  if(propName == "getModuleSharedValue"){
    return jsi::Function::createFromHostFunction(rt, name, 2, getModuleSharedValue);
  };
  
  if(propName == "setModuleSharedValue"){
    return jsi::Function::createFromHostFunction(rt, name, 3, setModuleSharedValue);
  };
  
  if(propName == "getAllModuleSharedValues"){
    return jsi::Function::createFromHostFunction(rt, name, 1, getAllModuleSharedValues);
  };
  
  if(propName == "overwriteModuleSharedValues"){
    return jsi::Function::createFromHostFunction(rt, name, 2, overwriteModuleSharedValues);
  };
  
  return jsi::Value::undefined();
}

void RNIUtilitiesTurboModule::set(
  jsi::Runtime &,
  const jsi::PropNameID &,
  const jsi::Value &
){
  // no-op
};

std::vector<jsi::PropNameID> RNIUtilitiesTurboModule::getPropertyNames(
  jsi::Runtime &rt
) {
  std::vector<jsi::PropNameID> properties;
  properties.push_back(jsi::PropNameID::forUtf8(rt, "dummyFunction"));
  properties.push_back(jsi::PropNameID::forUtf8(rt, "viewCommandRequest"));
  properties.push_back(jsi::PropNameID::forUtf8(rt, "moduleCommandRequest"));
  properties.push_back(jsi::PropNameID::forUtf8(rt, "getModuleSharedValue"));
  properties.push_back(jsi::PropNameID::forUtf8(rt, "setModuleSharedValue"));
  properties.push_back(jsi::PropNameID::forUtf8(rt, "getAllModuleSharedValues"));
  properties.push_back(jsi::PropNameID::forUtf8(rt, "overwriteModuleSharedValues"));

  return properties;
}

// MARK: - Static Functions
// ------------------------

void RNIUtilitiesTurboModule::registerCommands(
  std::function<void(int)> dummyFunction,
  ViewCommandRequestFunction viewCommandRequest,
  ModuleCommandRequestFunction moduleCommandRequest,
  GetModuleSharedValueFunction getModuleSharedValue,
  SetModuleSharedValueFunction setModuleSharedValue,
  GetAllModuleSharedValuesFunction getAllModuleSharedValues,
  OverwriteModuleSharedValuesFunction overwriteModuleSharedValues
) {
  dummyFunction_ = dummyFunction;
  viewCommandRequest_ = viewCommandRequest;
  moduleCommandRequest_ = moduleCommandRequest;
  getModuleSharedValue_ = getModuleSharedValue;
  setModuleSharedValue_ = setModuleSharedValue;
  getAllModuleSharedValues_ = getAllModuleSharedValues;
  overwriteModuleSharedValues_ = overwriteModuleSharedValues;
};

// MARK: - JSI Commands
// --------------------

jsi::Value RNIUtilitiesTurboModule::dummyFunction(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {
  if (count < 1) {
    throw jsi::JSError(rt,
      "`dummyFunction` method requires 1 argument."
    );
  }
  
  #if DEBUG
  std::cout << "RNIUtilitiesTurboModule::dummyFunction"
    << "\n - arguments[0]:" << arguments[0].asNumber()
    << std::endl;
  #endif
  
  //int stackTag = arguments[0].asNumber();
  RNIUtilitiesTurboModule::dummyFunction_(-1);
  return jsi::Value::undefined();
}

jsi::Value RNIUtilitiesTurboModule::viewCommandRequest(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {

  #if DEBUG
  std::cout
    << RNI_DEBUG_STRING
    << " - arg count: " << count
    << std::endl;
  #endif


  if (count < 3) {
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Requires 3 arguments")
    );
  }
  
  std::string viewID = [&]{
    if (arguments[0].isString()){
      auto jsString = arguments[0].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `viewID` param must be a string literal")
    );
  }();
  
  std::string commandName = [&]{
    if (arguments[1].isString()){
      auto jsString = arguments[1].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `commandName` param must be a string literal")
    );
  }();
  
  folly::dynamic commandArgs = [&]{
    if (arguments[2].isObject()){
      return jsi::dynamicFromValue(rt, arguments[2]);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `commandArgs` param must be an object")
    );
  }();
  
  auto promise = rt.global().getPropertyAsFunction(rt, "Promise");
  auto promiseBody = [=](
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *args,
    size_t count
  ) -> jsi::Value {
  
    auto resolveValue = std::make_shared<jsi::Value>(rt, args[0]);
    auto rejectValue  = std::make_shared<jsi::Value>(rt, args[1]);
    
    RNIUtilitiesTurboModule::viewCommandRequest_(
      viewID,
      commandName,
      commandArgs,
      [resolveValue = std::move(resolveValue)](folly::dynamic resultDyn){
        jsi::Runtime *rt = RNIUtilitiesTurboModule::jsRuntime;
        auto resultValue = jsi::valueFromDynamic(*rt, resultDyn);
        
        auto resolve = resolveValue->asObject(*rt).asFunction(*rt);
        resolve.call(*rt, std::move(resultValue));
      },
      [rejectValue = std::move(rejectValue)](std::string errorMessage){
        jsi::Runtime *rt = RNIUtilitiesTurboModule::jsRuntime;
        auto errorMessageValue = jsi::String::createFromUtf8(*rt, errorMessage);
        
        auto reject = rejectValue->asObject(*rt).asFunction(*rt);
        reject.call(*rt, std::move(errorMessageValue));
      }
    );
    
    return {};
  };
  
  auto promiseFunction = jsi::Function::createFromHostFunction(
    /* runtime    : */ rt,
    /* name       : */ jsi::PropNameID::forAscii(rt, "executor"),
    /* param count: */ 2,
    /* function   : */ promiseBody
  );
  
  return promise.callAsConstructor(rt, promiseFunction);
}

jsi::Value RNIUtilitiesTurboModule::moduleCommandRequest(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {

  #if DEBUG
  std::cout
    << RNI_DEBUG_STRING
    << " - arg count: " << count
    << std::endl;
  #endif

  if (count < 3) {
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Requires 3 arguments")
    );
  }
  
  std::string moduleName = [&]{
    if (arguments[0].isString()){
      auto jsString = arguments[0].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `moduleName` param must be a string literal")
    );
  }();
  
  std::string commandName = [&]{
    if (arguments[1].isString()){
      auto jsString = arguments[1].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `commandName` param must be a string literal")
    );
  }();
  
  folly::dynamic commandArgs = [&]{
    if (arguments[2].isObject()){
      return jsi::dynamicFromValue(rt, arguments[2]);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `commandArgs` param must be an object")
    );
  }();
  
  jsi::Function promise = rt.global().getPropertyAsFunction(rt, "Promise");
  
  auto promiseBody = [=](
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *args,
    size_t count
  ) -> jsi::Value {
    
    auto resolveValue = std::make_shared<jsi::Value>(rt, args[0]);
    auto rejectValue  = std::make_shared<jsi::Value>(rt, args[1]);
    
    RNIUtilitiesTurboModule::moduleCommandRequest_(
      moduleName,
      commandName,
      commandArgs,
      [resolveValue = std::move(resolveValue)](folly::dynamic resultDyn){
        jsi::Runtime *rt = RNIUtilitiesTurboModule::jsRuntime;
        auto resultValue = jsi::valueFromDynamic(*rt, resultDyn);
        
        auto resolve = resolveValue->asObject(*rt).asFunction(*rt);
        resolve.call(*rt, std::move(resultValue));
      },
      [rejectValue = std::move(rejectValue)](std::string errorMessage){
        jsi::Runtime *rt = RNIUtilitiesTurboModule::jsRuntime;
        auto errorMessageValue = jsi::String::createFromUtf8(*rt, errorMessage);
        
        auto reject = rejectValue->asObject(*rt).asFunction(*rt);
        reject.call(*rt, std::move(errorMessageValue));
      }
    );
    
    return {};
  };
  
  auto promiseFunction = jsi::Function::createFromHostFunction(
    /* runtime    : */ rt,
    /* name       : */ jsi::PropNameID::forAscii(rt, "executor"),
    /* param count: */  2,
    /* function   : */ promiseBody
  );
  
  return promise.callAsConstructor(rt, promiseFunction);
};

jsi::Value RNIUtilitiesTurboModule::getModuleSharedValue(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {

  if (count < 2 || count > 2) {
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Requires 2 arguments")
    );
  }
  
  std::string moduleName = [&]{
    if (arguments[0].isString()){
      auto jsString = arguments[0].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `moduleName` param must be a string literal")
    );
  }();
  
  std::string key = [&]{
    if (arguments[1].isString()){
      auto jsString = arguments[1].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `key` param must be a string literal")
    );
  }();

  auto resultDyn = RNIUtilitiesTurboModule::getModuleSharedValue_(
    /* moduleName : */ moduleName,
    /* key:       : */ key
  );
  
  return jsi::valueFromDynamic(rt, resultDyn);
};

jsi::Value RNIUtilitiesTurboModule::setModuleSharedValue(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {

  if (count < 3 || count > 3) {
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Requires 3 arguments")
    );
  }
  
  std::string moduleName = [&]{
    if (arguments[0].isString()){
      auto jsString = arguments[0].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `moduleName` param must be a string literal")
    );
  }();
  
  std::string key = [&]{
    if (arguments[1].isString()){
      auto jsString = arguments[1].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `key` param must be a string literal")
    );
  }();
  
  folly::dynamic valueDyn = [&]{
    auto value = jsi::Value(rt, arguments[2]);
    return jsi::dynamicFromValue(rt, value);
  }();
  
  RNIUtilitiesTurboModule::setModuleSharedValue_(
    /* moduleName : */ moduleName,
    /* key        : */ key,
    /* value      : */ valueDyn
  );
  
  return jsi::Value::undefined();
};

jsi::Value RNIUtilitiesTurboModule::getAllModuleSharedValues(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {

  if (count < 1 || count > 1) {
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Requires 1 arguments")
    );
  }
  
  std::string moduleName = [&]{
    if (arguments[0].isString()){
      auto jsString = arguments[0].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `moduleName` param must be a string literal")
    );
  }();

  auto resultDyn = RNIUtilitiesTurboModule::getAllModuleSharedValues_(
    /* moduleName: */ moduleName
  );
  
  if(resultDyn.type() != folly::dynamic::OBJECT){
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("The value returned by the module is not an object")
    );
  };
  
  return jsi::valueFromDynamic(rt, resultDyn);
};

jsi::Value RNIUtilitiesTurboModule::overwriteModuleSharedValues(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {

  if (count < 2 || count > 2) {
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Requires 2 arguments")
    );
  }
  
  std::string moduleName = [&]{
    if (arguments[0].isString()){
      auto jsString = arguments[0].asString(rt);
      return jsString.utf8(rt);
    };
    
    throw jsi::JSError(rt,
      RNI_DEBUG_MESSAGE("Argument passed to `moduleName` param must be a string literal")
    );
  }();
  
  folly::dynamic valueDyn = [&]{
    auto value = jsi::Value(rt, arguments[1]);
    auto valueDyn = jsi::dynamicFromValue(rt, value);
    
    if(valueDyn.type() != folly::dynamic::OBJECT){
      throw jsi::JSError(rt,
        RNI_DEBUG_MESSAGE("Argument passed to `values` param must be an object")
      );
    };
    
    return valueDyn;
  }();
  
  RNIUtilitiesTurboModule::overwriteModuleSharedValues_(
    /* moduleName: */ moduleName,
    /* values    : */ valueDyn
  );
  
  return jsi::Value::undefined();
};

} // namespace RNScreens
#endif
