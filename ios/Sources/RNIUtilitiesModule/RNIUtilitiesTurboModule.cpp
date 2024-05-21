//
//  RNIUtilitiesTurboModule.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if __cplusplus
#include "RNIUtilitiesTurboModule.h"
#include <jsi/JSIDynamic.h>

#if DEBUG
#include <string>
#include <iostream>
#endif

using namespace facebook;
namespace RNIUtilities {

const char RNIUtilitiesTurboModule::MODULE_NAME[] = "RNIUtilitiesModule";

std::function<void(int)> RNIUtilitiesTurboModule::dummyFunction_;
Promise RNIUtilitiesTurboModule::functionThatReturnsPromise_;

RNIUtilitiesTurboModule::RNIUtilitiesTurboModule(
  std::function<void(int)> dummyFunction,
  Promise functionThatReturnsPromise
) {
  dummyFunction_ = dummyFunction;
  functionThatReturnsPromise_ = functionThatReturnsPromise;
}

RNIUtilitiesTurboModule::~RNIUtilitiesTurboModule(){
  // no-op
};

jsi::Value RNIUtilitiesTurboModule::get(
  jsi::Runtime &rt,
  const jsi::PropNameID &name
) {

  auto propName = name.utf8(rt);
  if (propName == "dummyFunction") {
    return jsi::Function::createFromHostFunction(rt, name, 1, dummyFunction);
  };
  
  if(propName == "functionThatReturnsPromise"){
    return jsi::Function::createFromHostFunction(rt, name, 0, functionThatReturnsPromise);
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
  properties.push_back(jsi::PropNameID::forUtf8(rt, "functionThatReturnsPromise"));

  return properties;
}

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
  dummyFunction_(-1);
  return jsi::Value::undefined();
}

jsi::Value RNIUtilitiesTurboModule::functionThatReturnsPromise(
  jsi::Runtime &rt,
  const jsi::Value &thisValue,
  const jsi::Value *arguments,
  size_t count
) {

  #if DEBUG
  std::cout << "RNIUtilitiesTurboModule::functionThatReturnsPromise"
    << std::endl;
  #endif
  
  auto promise = rt.global().getPropertyAsFunction(rt, "Promise");
  
  auto promiseBody = [](
    jsi::Runtime &rt,
    const jsi::Value &thisValue,
    const jsi::Value *args,
    size_t count
  ) -> jsi::Value {
  
    auto resolve = [&rt, &args]{
      auto resolveValue = std::make_shared<jsi::Value>(rt, args[0]);
      return resolveValue->asObject(rt).asFunction(rt);
    }();
    
    auto reject = [&rt, &args]{
      auto rejectValue = std::make_shared<jsi::Value>(rt, args[1]);
      return rejectValue->asObject(rt).asFunction(rt);
    }();
    
    functionThatReturnsPromise_([&rt, &resolve](folly::dynamic resultDyn){
      auto resultValue = jsi::valueFromDynamic(rt, resultDyn);
      resolve.call(rt, std::move(resultValue));
      
    }, [&rt, &reject](std::string errorMessage){
      auto jsString = jsi::String::createFromUtf8(rt, errorMessage);
      reject.call(rt, std::move(jsString));
    });
    
    return {};
  };
  
  auto promiseFunction = jsi::Function::createFromHostFunction(
    /* runtime    : */ rt,
    /* name       : */ jsi::PropNameID::forAscii(rt, "executor"),
    /* param count: */  2,
    /* function   : */ promiseBody
  );
  
  return promise.callAsConstructor(rt, promiseFunction);
}

} // namespace RNScreens
#endif
