//
//  RNIUtilitiesModule.mm
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#import "RNIUtilitiesModule.h"

#import <React/RCTBridge+Private.h>
#import <React/RCTBridge.h>

#if __cplusplus
#include "RNIUtilitiesTurboModule.h"

#include <jsi/jsi.h>
#import <folly/dynamic.h>
#import <React/RCTConversions.h>
#import <React/RCTFollyConvert.h>

#if DEBUG
#include <string>
#include <iostream>
#endif

using namespace facebook;
using namespace react;
#endif

BOOL _RNIUtilitiesModuleDidInstallHostObject = NO;

@implementation RNIUtilitiesModule {
}

#ifdef RCT_NEW_ARCH_ENABLED
@synthesize viewRegistry_DEPRECATED = _viewRegistry_DEPRECATED;
#endif

@synthesize bridge = _bridge;

/// Note: Only gets invoked in paper
- (instancetype)init
{
  self = [super init];
  if (self) {
    #if !RCT_NEW_ARCH_ENABLED
    [[self class] installHostObjectIfNeeded];
    #endif
  };
  
  return self;
}

// RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(install){
//   NSLog(@"[RNIUtilitiesModule install]");
//   return nil;
// };

// MARK: RCTBridgeModule
// ---------------------

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (NSDictionary *)constantsToExport
{
  return @{};
}

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

#if RCT_NEW_ARCH_ENABLED
/// Doesn't get called...
- (std::shared_ptr<TurboModule>)getTurboModule:(const ObjCTurboModule::InitParams &)params
{
 [[self class] installHostObjectIfNeeded];
 return std::make_shared<react::NativeRNIUtilitiesModuleSpecJSI>(params);
}
#endif

// MARK: RCT_EXPORT_MODULE
// -----------------------

RCT_EXTERN void RCTRegisterModule(Class);
+(NSString *)moduleName
{
  return @"RNIUtilitiesModule";
}

+(void)load
{
  #if RCT_NEW_ARCH_ENABLED
  dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1);
  dispatch_after(delay, dispatch_get_main_queue(), ^{
    [[self class] installHostObjectIfNeeded];
  });
  #endif
}

// MARK: Static Members
// --------------------

+ (BOOL)isHostObjectRegistered
{
  return _RNIUtilitiesModuleDidInstallHostObject;
}

+ (void)installHostObjectIfNeeded
{
  if(_RNIUtilitiesModuleDidInstallHostObject){
    return;
  };
  
  RCTBridge *bridge = [RCTBridge currentBridge];
  
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)bridge;
  if (cxxBridge == nil) {
    return;
  };
  
  auto jsiRuntime = (jsi::Runtime *)cxxBridge.runtime;
  if (jsiRuntime == nil) {
    return;
  };
    
  auto &runtime = *jsiRuntime;
  __weak auto weakSelf = self;
  
  auto moduleName = RNIUtilities::RNIUtilitiesTurboModule::MODULE_NAME;
  
  const auto &dummyFunction = [weakSelf](int someInt) {
    #if DEBUG
    std::cout << "[RNIUtilitiesModule dummyFunction]"
      << "\n - someInt:" << someInt
      << std::endl;
    #endif
  };
  
  const RNIUtilities::Promise &functionThatReturnsPromise = [weakSelf](
    RNIUtilities::Resolve resolve,
    RNIUtilities::Reject reject
  ) {
    NSLog(@"functionThatReturnsPromise");
    
    NSDictionary *resultDict = @{
      @"someString": @"abc",
      @"someInt": @123,
      @"someDouble": @3.14,
      @"someBool": @NO,
    };
    
    folly::dynamic resultDyn = react::convertIdToFollyDynamic(resultDict);
    resolve(resultDyn);
    return;
  };

  auto moduleHostObject = std::make_shared<RNIUtilities::RNIUtilitiesTurboModule>(
    dummyFunction,
    functionThatReturnsPromise
  );
          
  auto moduleObject =
    jsi::Object::createFromHostObject(runtime, moduleHostObject);
  
  runtime.global().setProperty(
    /* runtime: */ runtime,
    /* name   : */ moduleName,
    /* value  : */ std::move(moduleObject)
  );
  
  _RNIUtilitiesModuleDidInstallHostObject = YES;
}

@end
