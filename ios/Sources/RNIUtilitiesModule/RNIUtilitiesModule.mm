//
//  RNIUtilitiesModule.mm
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#import "RNIUtilitiesModule.h"
#import "react-native-ios-utilities/RNIViewRegistry.h"
#import "react-native-ios-utilities/RNIViewCommandRequestHandling.h"

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

static RNIUtilitiesModule *RNIUtilitiesModuleShared = nil;

@implementation RNIUtilitiesModule {
  BOOL _didInstallHostObject;
}

#ifdef RCT_NEW_ARCH_ENABLED
@synthesize viewRegistry_DEPRECATED = _viewRegistry_DEPRECATED;
#endif

@synthesize bridge = _bridge;

+ (nonnull instancetype)shared
{
  return RNIUtilitiesModuleShared;
}

// MARK: Init + Setup
// ------------------

/// Note: Only gets invoked in paper
- (instancetype)init
{
  self = [super init];
  if (self) {
    RNIUtilitiesModuleShared = self;
    #if !RCT_NEW_ARCH_ENABLED
    [self installHostObjectIfNeeded];
    #endif
  };
  
  return self;
}

- (void)installHostObjectIfNeeded
{
  if(self->_didInstallHostObject){
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
  
  const RNIUtilities::ViewCommandRequestFunction &viewCommandRequest = [weakSelf](
    std::string viewID,
    std::string commandName,
    folly::dynamic commandArgs,
    RNIUtilities::Resolve resolve,
    RNIUtilities::Reject reject
  ) {
    if(weakSelf == nil){
      reject("Reference to RNIUtilitiesModule is nil");
    };
    
    RNIPromiseResolveBlock resolveBlock = ^(NSDictionary *result) {
      folly::dynamic resultDyn = react::convertIdToFollyDynamic(result);
      resolve(resultDyn);
    };
    
    RNIPromiseRejectBlock rejectBlock = ^(NSString *errorMessage) {
      reject([errorMessage UTF8String]);
    };
    
    NSDictionary *commandArgsDict = react::convertFollyDynamicToId(commandArgs);
    
    [weakSelf
      viewCommandRequestForViewID:[NSString stringWithUTF8String:viewID.c_str()]
                      commandName:[NSString stringWithUTF8String:commandName.c_str()]
                  withCommandArgs:commandArgsDict
                          resolve:resolveBlock
                           reject:rejectBlock];
  };

  auto moduleHostObject = std::make_shared<RNIUtilities::RNIUtilitiesTurboModule>(
    dummyFunction,
    viewCommandRequest
  );
          
  auto moduleObject =
    jsi::Object::createFromHostObject(runtime, moduleHostObject);
  
  runtime.global().setProperty(
    /* runtime: */ runtime,
    /* name   : */ moduleName,
    /* value  : */ std::move(moduleObject)
  );
  
  self->_didInstallHostObject = YES;
}

// MARK: Module Commands
// ---------------------

- (void)viewCommandRequestForViewID:(NSString *)viewID
                        commandName:(NSString *)commandName
                    withCommandArgs:(NSDictionary *)commandArgs
                            resolve:(RNIPromiseResolveBlock)resolveBlock
                             reject:(RNIPromiseRejectBlock)rejectBlock
{
#if DEBUG
    NSLog(
      @"%@\n%@ %@\n%@ %@\n%@ %lu\n%@ %@\n%@ %@",
      @"[RNIUtilitiesModule viewCommandRequestForViewID]",
      @" - arg viewID:", viewID,
      @" - arg commandName:", commandName,
      @" - arg [commandArgs count]:", [commandArgs count],
      @" - arg [commandArgs allKeys]:", [commandArgs allKeys],
      @" - arg commandArgs:", commandArgs
    );
#endif

  UIView *match = [[RNIViewRegistry shared] getViewForViewID:viewID];
  if(match == nil){
    NSString *messageRaw =
      @"Unable to execute command: '%@'"
      @" because there is no corresponding view found for viewID: '%@'";
  
    NSString *message = [NSString stringWithFormat: messageRaw, commandName, viewID];
    rejectBlock(message);
  };
  
  if(![match conformsToProtocol:@protocol(RNIViewCommandRequestHandling)]){
    NSString *messageRaw =
      @"Unable to execute command: '%@' "
      @" because the associated view for viewID: '%@'"
      @" of class type: '%@'"
      @" does not conform to protocol: %@";
      
    NSString *className = NSStringFromClass([match class]);
    NSString *protocolName = NSStringFromProtocol(@protocol(RNIViewCommandRequestHandling));
      
    NSString *message =
      [NSString stringWithFormat: messageRaw, commandName, viewID, className, protocolName];
    
    rejectBlock(message);
  };
  
  UIView<RNIViewCommandRequestHandling> *view = (UIView<RNIViewCommandRequestHandling> *)match;
  [view handleViewRequestForCommandName:commandName
                          withArguments:commandArgs
                                resolve:resolveBlock
                                 reject:rejectBlock];
}

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
 [self installHostObjectIfNeeded];
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
  RCTRegisterModule(self);
}

@end
