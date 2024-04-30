//
//  RNIObjcUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#ifndef RNIObjcUtils_h
#define RNIObjcUtils_h

#include <react/renderer/core/LayoutMetrics.h>

@class RNILayoutMetrics;

@interface RNIObjcUtils : NSObject

+ (RNILayoutMetrics *)createRNILayoutMetricsFrom: (facebook::react::LayoutMetrics)layoutMetrics;

@end

#endif /* RNIObjcUtils_h */
