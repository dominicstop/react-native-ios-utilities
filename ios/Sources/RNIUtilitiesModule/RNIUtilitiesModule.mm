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

using namespace facebook;
#endif

@implementation RNIUtilitiesModule {
}

RCT_EXPORT_MODULE()

#ifdef RCT_NEW_ARCH_ENABLED
@synthesize viewRegistry_DEPRECATED = _viewRegistry_DEPRECATED;
#endif

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (NSDictionary *)constantsToExport
{
  #if !RCT_NEW_ARCH_ENABLED
  [self installHostObject];
  #endif
  return @{};
}

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

#if RCT_NEW_ARCH_ENABLED && __cplusplus
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
  [self installHostObject];
  return std::make_shared<facebook::react::NativeRNIUtilitiesModuleSpecJSI>(params);
}
#endif

#if __cplusplus
- (void)installHostObject
{
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

  auto moduleHostObject =
    std::make_shared<RNIUtilities::RNIUtilitiesTurboModule>();
          
  auto moduleObject = jsi::Object::createFromHostObject(runtime, moduleHostObject);
  
  //Runtime& , const char* , T&& value
  
  runtime.global().setProperty(
    /* runtime: */ runtime,
    /* name   : */ moduleName,
    /* value  : */ std::move(moduleObject)
  );
}
#endif

@end
