//
//  RNIObjcUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//


@class RNILayoutMetrics;

namespace facebook::react {
  struct LayoutMetrics;
}

namespace folly {
  struct dynamic;
}

@interface RNIObjcUtils : NSObject

+ (id)convertFollyDynamicToId: (const folly::dynamic*)dyn;

+ (RNILayoutMetrics *)createRNILayoutMetricsFrom: (facebook::react::LayoutMetrics)layoutMetrics;

@end

