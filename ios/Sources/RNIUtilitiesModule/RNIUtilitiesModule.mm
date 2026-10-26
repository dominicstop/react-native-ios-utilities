//
//  RNIUtilitiesModule.mm
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#import "RNIUtilitiesModule.h"
#import "../../Swift.h"
#import "RNIViewRegistry.h"
#import "RNIViewCommandRequestHandling.h"
#import "RNIObjcUtils.h"

#import <React/RCTBridge+Private.h>
#import <React/RCTBridge.h>

#if __cplusplus
#include "RNIUtilitiesTurboModule.h"

#import <folly/dynamic.h>
#import <React/RCTConversions.h>
#import "RNIUtilitiesFollyConvert.h"

#include <jsi/jsi.h>
#include <string>
#if __has_include(<ReactCommon/RCTTurboModuleWithJSIBindings.h>)
#import <ReactCommon/RCTTurboModuleWithJSIBindings.h>
#define RNI_HAS_JSI_BINDINGS 1
#endif

#if DEBUG
#include <iostream>
#endif

using namespace facebook;
using namespace react;
using namespace RNIUtilities;
#endif

static BOOL SHOULD_LOG = NO;

#if __cplusplus
// Set by the JSI bindings hook; RN 0.88 removed RCTCxxBridge, so this is the
// only way to reach the runtime when the legacy architecture is removed.
static jsi::Runtime *RNIUtilitiesJSIRuntime = nullptr;
void RNIObjcUtilsSetJSCallInvoker(std::shared_ptr<facebook::react::CallInvoker> callInvoker);
#endif

#ifdef RNI_HAS_JSI_BINDINGS
@interface RNIUtilitiesModule () <RCTTurboModuleWithJSIBindings>
@end
#endif

@implementation RNIUtilitiesModule {
  BOOL _didInstallHostObject;
}

static RNIUtilitiesModule *RNIUtilitiesModuleShared = nil;

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
  
  jsi::Runtime *jsiRuntime = RNIUtilitiesJSIRuntime;
  
  #ifndef RCT_REMOVE_LEGACY_ARCH
  if (jsiRuntime == nullptr) {
    RCTCxxBridge *cxxBridge = (RCTCxxBridge *)[RCTBridge currentBridge];
    jsiRuntime = (jsi::Runtime *)cxxBridge.runtime;
  };
  #endif
  
  if (jsiRuntime == nullptr) {
    return;
  };
    
  auto &runtime = *jsiRuntime;
  __weak auto weakSelf = self;
  
  auto moduleName = RNIUtilities::RNIUtilitiesTurboModule::MODULE_NAME;
  RNIUtilitiesTurboModule::jsRuntime = jsiRuntime;
  
  const auto &dummyFunction = [weakSelf](int someInt) {
    #if DEBUG
    std::cout << "[RNIUtilitiesModule dummyFunction]"
      << "\n - someInt:" << someInt
      << std::endl;
    #endif
  };
  
  const RNIUtilitiesTurboModule::ViewCommandRequestFunction &viewCommandRequest = [weakSelf](
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
      [RNIObjcUtils dispatchToJSThreadViaCallInvokerForBlock: ^{
        resolve(resultDyn);
      }];
    };
    
    RNIPromiseRejectBlock rejectBlock = ^(NSString *errorMessage) {
      [RNIObjcUtils dispatchToJSThreadViaCallInvokerForBlock: ^{
        reject([errorMessage UTF8String]);
      }];
    };
    
    NSDictionary *commandArgsDict = react::convertFollyDynamicToId(commandArgs);
    
    [weakSelf
      viewCommandRequestForViewID:[NSString stringWithUTF8String:viewID.c_str()]
                      commandName:[NSString stringWithUTF8String:commandName.c_str()]
                  withCommandArgs:commandArgsDict
                          resolve:resolveBlock
                           reject:rejectBlock];
  };
  
  const RNIUtilitiesTurboModule::ModuleCommandRequestFunction &moduleCommandRequest = [weakSelf](
    std::string moduleName,
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
      moduleCommandForModuleName:[NSString stringWithUTF8String:moduleName.c_str()]
                     commandName:[NSString stringWithUTF8String:commandName.c_str()]
                 withCommandArgs:commandArgsDict
                         resolve:resolveBlock
                          reject:rejectBlock];
  };
  
  const RNIUtilitiesTurboModule::GetModuleSharedValueFunction &getModuleSharedValue = [weakSelf](
    std::string moduleName,
    std::string key
  ) {
    
    if(weakSelf == nil){
      folly::dynamic resultDyn = nullptr;
      return resultDyn;
    };
    
    id result =
      [weakSelf getModuleSharedValueForModuleName:[NSString stringWithUTF8String:moduleName.c_str()]
                                          withKey:[NSString stringWithUTF8String:key.c_str()]];
    
    return react::convertIdToFollyDynamic(result);
  };
  
  const RNIUtilitiesTurboModule::SetModuleSharedValueFunction &setModuleSharedValue = [weakSelf](
    std::string moduleName,
    std::string key,
    folly::dynamic valueDyn
  ) {
    if(weakSelf == nil){
      return;
    };
    
    id value = react::convertFollyDynamicToId(valueDyn);
    [weakSelf setModuleSharedValueForModuleName:[NSString stringWithUTF8String:moduleName.c_str()]
                                         forKey:[NSString stringWithUTF8String:key.c_str()]
                                      withValue:value];
  };
  
  const RNIUtilitiesTurboModule::GetAllModuleSharedValuesFunction &getAllModuleSharedValues = [weakSelf](
    std::string moduleNameCxx
  ) {
  
    if(weakSelf == nil){
      folly::dynamic resultDyn = nullptr;
      return resultDyn;
    };
    
    NSString *moduleNameObjc =
      [NSString stringWithUTF8String:moduleNameCxx.c_str()];
      
    id values = [weakSelf getAllModuleSharedValuesForModuleName:moduleNameObjc];
    return react::convertIdToFollyDynamic(values);
  };
  
  const RNIUtilitiesTurboModule::OverwriteModuleSharedValuesFunction &overwriteModuleSharedValues = [weakSelf](
    std::string moduleNameCxx,
    folly::dynamic valueDyn
  ) {
  
    NSString *moduleNameObjc =
      [NSString stringWithUTF8String:moduleNameCxx.c_str()];
    
    id valueObjc = react::convertFollyDynamicToId(valueDyn);
    [weakSelf overwriteModuleSharedValuesForModuleName:moduleNameObjc
                                            withValues:valueObjc];
  };
  
  RNIUtilitiesTurboModule::registerCommands(
    dummyFunction,
    viewCommandRequest,
    moduleCommandRequest,
    getModuleSharedValue,
    setModuleSharedValue,
    getAllModuleSharedValues,
    overwriteModuleSharedValues
  );

  auto moduleHostObject = std::make_shared<RNIUtilitiesTurboModule>();
          
  auto moduleObject =
    jsi::Object::createFromHostObject(runtime, moduleHostObject);
  
  runtime.global().setProperty(
    /* runtime: */ runtime,
    /* name   : */ moduleName,
    /* value  : */ std::move(moduleObject)
  );
  
  self->_didInstallHostObject = YES;
}

#ifdef RNI_HAS_JSI_BINDINGS
// RN 0.88+ only calls this variant
- (void)installJSIBindingsWithRuntime:(jsi::Runtime &)runtime
                          callInvoker:(const std::shared_ptr<facebook::react::CallInvoker> &)callInvoker
{
  RNIObjcUtilsSetJSCallInvoker(callInvoker);
  [self installJSIBindingsWithRuntime:runtime];
}

- (void)installJSIBindingsWithRuntime:(jsi::Runtime &)runtime
{
  RNIUtilitiesJSIRuntime = &runtime;
  [self installHostObjectIfNeeded];
}
#endif

// MARK: Module Commands
// ---------------------

- (void)viewCommandRequestForViewID:(NSString *)viewID
                        commandName:(NSString *)commandName
                    withCommandArgs:(NSDictionary *)commandArgs
                            resolve:(RNIPromiseResolveBlock)resolveBlock
                             reject:(RNIPromiseRejectBlock)rejectBlock
{
  RNILog(
    @"%@\n%@ %@\n%@ %@\n%@ %lu\n%@ %@\n%@ %@",
    @"[RNIUtilitiesModule viewCommandRequestForViewID]",
    @" - arg viewID:", viewID,
    @" - arg commandName:", commandName,
    @" - arg [commandArgs count]:", [commandArgs count],
    @" - arg [commandArgs allKeys]:", [commandArgs allKeys],
    @" - arg commandArgs:", commandArgs
  );

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
  
  UIView<RNIViewCommandRequestHandling> *view =
    (UIView<RNIViewCommandRequestHandling> *)match;
    
  dispatch_async(dispatch_get_main_queue(), ^{
    [view handleViewRequestForCommandName:commandName
                            withArguments:commandArgs
                                  resolve:resolveBlock
                                   reject:rejectBlock];
  });
}

- (void)moduleCommandForModuleName:(NSString *)moduleName
                       commandName:(NSString *)commandName
                   withCommandArgs:(NSDictionary *)commandArgs
                           resolve:(RNIPromiseResolveBlock)resolveBlock
                            reject:(RNIPromiseRejectBlock)rejectBlock
{
  RNILog(
    @"%@\n%@ %@\n%@ %@\n%@ %lu\n%@ %@\n%@ %@",
    @"[RNIUtilitiesModule moduleCommandForModuleName]",
    @" - arg commandName:", commandName,
    @" - arg commandName:", commandName,
    @" - arg [commandArgs count]:", [commandArgs count],
    @" - arg [commandArgs allKeys]:", [commandArgs allKeys],
    @" - arg commandArgs:", commandArgs
  );

  RNIUtilitiesManager *manager = [[RNIUtilitiesManager class] shared];
  [manager notifyForModuleCommandRequestForModuleName:moduleName
                                          commandName:commandName
                                        withArguments:commandArgs
                                              resolve:resolveBlock
                                               reject:rejectBlock];
}

- (id)getModuleSharedValueForModuleName:(NSString *)moduleName
                                withKey:(NSString *)key
{
  RNIUtilitiesManager *manager = [RNIUtilitiesManager shared];
  return [manager getModuleSharedValueForModuleNamed:moduleName
                                              forKey:key];
}

- (void)setModuleSharedValueForModuleName:(NSString *)moduleName
                                   forKey:(NSString *)key
                                withValue:(id)value
{
  RNIUtilitiesManager *manager = [RNIUtilitiesManager shared];
  [manager setModuleSharedValueForModuleNamed:moduleName
                                       forKey:key
                                    withValue:value];
}

- (id)getAllModuleSharedValuesForModuleName:(NSString *)moduleName
{
  RNIUtilitiesManager *manager = [RNIUtilitiesManager shared];
  return [manager getAllModuleSharedValueForModuleName:moduleName];
}

- (void)overwriteModuleSharedValuesForModuleName:(NSString *)moduleName
                                      withValues:(NSDictionary *)values
{
  RNIUtilitiesManager *manager = [RNIUtilitiesManager shared];
  [manager overwriteModuleSharedValuesForModuleNamed:moduleName
                                           withValue:[values mutableCopy]];
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
 // With the JSI bindings hook, install from there: it runs with the current
 // runtime, while the stored pointer may still refer to a reloaded one here.
 #ifndef RNI_HAS_JSI_BINDINGS
 [self installHostObjectIfNeeded];
 #endif
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
