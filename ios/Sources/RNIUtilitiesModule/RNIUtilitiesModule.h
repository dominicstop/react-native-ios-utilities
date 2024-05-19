//
//  RNIUtilitiesModule.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#ifdef RCT_NEW_ARCH_ENABLED
#include <RNIUtilitiesSpec/RNIUtilitiesSpec.h>
#else
#import <React/RCTBridge.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface RNIUtilitiesModule : NSObject
#ifdef RCT_NEW_ARCH_ENABLED
  <NativeRNIUtilitiesModuleSpec>
#else
  <RCTBridgeModule>
#endif

@end

NS_ASSUME_NONNULL_END
