//
//  RNIUtilitiesModule.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#import <React/RCTBridgeModule.h>

#ifdef RCT_NEW_ARCH_ENABLED
#include <RNIUtilitiesSpec/RNIUtilitiesSpec.h>
#import <ReactCommon/RCTTurboModule.h>

#else
#import <React/RCTBridge.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNIUtilitiesModule : NSObject
#ifdef RCT_NEW_ARCH_ENABLED
  <RCTBridgeModule, RCTTurboModule>
#else
  <RCTBridgeModule>
#endif

+ (void)installHostObjectIfNeeded;

@end

NS_ASSUME_NONNULL_END
