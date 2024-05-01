//
//  RNIObjcUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

@class RNILayoutMetrics;

#if __cplusplus
namespace facebook::react {
  struct LayoutMetrics;
}

namespace folly {
  struct dynamic;
}
#endif

@interface RNIObjcUtils : NSObject
#if __cplusplus
+ (id)convertFollyDynamicToId: (const folly::dynamic*)dyn;

+ (RNILayoutMetrics *)createRNILayoutMetricsFrom: (facebook::react::LayoutMetrics)layoutMetrics;
#endif
@end

