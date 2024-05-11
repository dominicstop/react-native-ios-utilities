//
//  RNIObjcUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#if __cplusplus
#include <react/renderer/graphics/Float.h>
#include <yoga/YGEnums.h>
#endif


@class RNILayoutMetrics;
typedef NS_ENUM(NSInteger, RNIPositionType);

#if __cplusplus
namespace facebook::react {
  struct LayoutMetrics;
  struct Size;
  
  template <typename T>
  struct RectangleEdges;
}

namespace folly {
  struct dynamic;
}
#endif

@interface RNIObjcUtils : NSObject
#if __cplusplus
+ (id)convertFollyDynamicToId: (const folly::dynamic*)dyn;

+ (RNILayoutMetrics *)createRNILayoutMetricsFrom: (facebook::react::LayoutMetrics)layoutMetrics;

+ (facebook::react::Size)convertToReactSizeForSize:(CGSize)size;

+ (facebook::react::RectangleEdges<facebook::react::Float>)convertToReactRectangleEdgesForEdgeInsets:(UIEdgeInsets)edgeInsets;

+ (YGPositionType)convertToYGPostionTypeForRNIPostionType:(RNIPositionType)positionType;
#endif
@end

