//
//  RNIObjcUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#if __cplusplus
#include <string>
#include <unordered_map>

#include <react/renderer/graphics/Float.h>
#include <yoga/YGEnums.h>
#endif

#import <React/RCTLayout.h>


@class RNILayoutMetrics;
@class RCTShadowView;

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

#ifdef DEBUG
#define RNILog(...)     \
  if(SHOULD_LOG){       \
    NSLog(__VA_ARGS__); \
  };
#else
#define RNILog(...) /* no-op */
#endif



@interface RNIObjcUtils : NSObject
NS_ASSUME_NONNULL_BEGIN
#if __cplusplus
+ (std::string)convertToCxxStringForObjcString:(NSString *)string;

+ (id)convertFollyDynamicToId:(const folly::dynamic*)dyn;

+ (NSMutableDictionary *)convertToMutableDictForFollyDynamicMap:(const std::unordered_map<std::string, folly::dynamic>&)stringToDynMap;

+ (NSDictionary *)convertToDictForFollyDynamicMap:(const std::unordered_map<std::string, folly::dynamic>&)stringToDynMap;

+ (RNILayoutMetrics *)convertToRNILayoutMetricsForFabricLayoutMetrics: (facebook::react::LayoutMetrics)layoutMetrics;

+ (facebook::react::Size)convertToReactSizeForSize:(CGSize)size;

+ (facebook::react::RectangleEdges<facebook::react::Float>)convertToReactRectangleEdgesForEdgeInsets:(UIEdgeInsets)edgeInsets;

+ (YGPositionType)convertToYGPostionTypeForRNIPostionType:(RNIPositionType)positionType;
#endif

+ (RNILayoutMetrics *)convertToRNILayoutMetricsForPaperLayoutMetrics:(RCTLayoutMetrics)layoutMetrics
                                                      withShadowView:(RCTShadowView *)shadowView;
                                                    
+ (NSString *)extractPropertyNameForSetterSelector:(nonnull SEL)selector;

+ (NSString *)createSetterSelectorStringForPropertyName:(NSString *)propertyName;

+ (void)dispatchToJSThreadViaBridgeForBlock:(void (^)(void))block
  NS_SWIFT_NAME(dispatchToJSThreadViaBridge(forBlock:));

+ (void)dispatchToJSThreadViaCallInvokerForBlock:(void (^)(void))block
  NS_SWIFT_NAME(dispatchToJSThreadViaCallInvoker(forBlock:));

NS_ASSUME_NONNULL_END
@end
