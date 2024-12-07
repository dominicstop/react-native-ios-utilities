//
//  RNIObjcUtils.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import <Foundation/Foundation.h>

#import "RNIObjcUtils.h"
#import "../../Swift.h"

#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>

#import <React/RCTShadowView.h>
#import <React/RCTShadowView+Layout.h> 

#if __cplusplus
#import <folly/dynamic.h>
#import <React/RCTConversions.h>
#import <React/RCTFollyConvert.h>

#include <react/renderer/core/LayoutMetrics.h>
#include <react/renderer/graphics/Rect.h>
#include <react/renderer/graphics/RectangleEdges.h>

#import <React/RCTBridgeProxy.h>
#import <React/RCTBridgeProxy+Cxx.h>
#endif


static BOOL SHOULD_LOG = NO;

@implementation RNIObjcUtils
#if __cplusplus
+ (std::string)convertToCxxStringForObjcString:(NSString *)string
{
  return std::string(
    [string UTF8String],
    [string lengthOfBytesUsingEncoding: NSUTF8StringEncoding]
  );
}

+ (id)convertFollyDynamicToId:(const folly::dynamic*)dyn
{
  switch (dyn->type()) {
    case folly::dynamic::NULLT:
      return nil;
      
    case folly::dynamic::BOOL:
      return dyn->getBool() ? @YES : @NO;
      
    case folly::dynamic::INT64:
      return @(dyn->getInt());
      
    case folly::dynamic::DOUBLE:
      return @(dyn->getDouble());
      
    case folly::dynamic::STRING:
      return [[NSString alloc] initWithBytes:dyn->c_str()
                                      length:dyn->size()
                                    encoding:NSUTF8StringEncoding];
    
    case folly::dynamic::ARRAY: {
      NSMutableArray *array =
        [[NSMutableArray alloc] initWithCapacity:dyn->size()];
      
      for (const auto &elem : *dyn) {
        id value = [RNIObjcUtils convertFollyDynamicToId:&elem];
        if (value) {
          [array addObject:value];
        }
      }
      return array;
    }
    
    case folly::dynamic::OBJECT: {
      NSMutableDictionary *dict =
        [[NSMutableDictionary alloc] initWithCapacity:dyn->size()];
      
      for (const auto &elem : dyn->items()) {
        id key = [RNIObjcUtils convertFollyDynamicToId:&elem.first];
        id value = [RNIObjcUtils convertFollyDynamicToId:&elem.second];
        
        if (key && value) {
          dict[key] = value;
        }
      }
      return dict;
    }
  }
  
  RNILog(@"Unsupported data type in folly::dynamic");
  return nil;
}

+ (NSMutableDictionary *)convertToMutableDictForFollyDynamicMap:(const std::unordered_map<std::string, folly::dynamic>&)stringToDynMap
{
  NSMutableDictionary *dict = [NSMutableDictionary new];
  for (auto& [key, value]: stringToDynMap) {
    NSString *keyAsObjcString = [NSString stringWithUTF8String:key.c_str()];
    id valueAsId = facebook::react::convertFollyDynamicToId(value);
    
    dict[keyAsObjcString] = valueAsId;
  };
  
  return dict;
}

+ (NSDictionary *)convertToDictForFollyDynamicMap:(const std::unordered_map<std::string, folly::dynamic>&)stringToDynMap
{
  return (NSDictionary *)[[RNIObjcUtils convertToMutableDictForFollyDynamicMap:stringToDynMap] copy];
}

+ (RNILayoutMetrics *)convertToRNILayoutMetricsForFabricLayoutMetrics:(facebook::react::LayoutMetrics)layoutMetrics
{
  RNILayoutMetrics *swiftLayoutMetrics = [RNILayoutMetrics new];
  
  swiftLayoutMetrics.frame =
    RCTCGRectFromRect(layoutMetrics.frame);
    
  swiftLayoutMetrics.contentInsets =
    RCTUIEdgeInsetsFromEdgeInsets(layoutMetrics.contentInsets);
    
  swiftLayoutMetrics.overflowInset =
    RCTUIEdgeInsetsFromEdgeInsets(layoutMetrics.overflowInset);
    
  swiftLayoutMetrics.contentFrame =
    RCTCGRectFromRect(layoutMetrics.getContentFrame());
    
  swiftLayoutMetrics.paddingFrame =
    RCTCGRectFromRect(layoutMetrics.getPaddingFrame());
    
  swiftLayoutMetrics.displayTypeRaw =
    static_cast<int>(layoutMetrics.displayType);
    
  swiftLayoutMetrics.positionTypeRaw =
    static_cast<int>(layoutMetrics.positionType);
    
  swiftLayoutMetrics.layoutDirectionRaw =
    static_cast<int>(layoutMetrics.layoutDirection);
  
  return swiftLayoutMetrics;
}

+ (facebook::react::Size)convertToReactSizeForSize:(CGSize)size
{
  facebook::react::Size newSize = {};
  newSize.width = size.width;
  newSize.height = size.height;
  
  return newSize;
}

+ (facebook::react::RectangleEdges<facebook::react::Float>)convertToReactRectangleEdgesForEdgeInsets:(UIEdgeInsets)edgeInsets
{
  facebook::react::RectangleEdges<facebook::react::Float> rectangleEdges = {};
  rectangleEdges.left = edgeInsets.left;
  rectangleEdges.top = edgeInsets.top;
  rectangleEdges.bottom = edgeInsets.bottom;
  rectangleEdges.right = edgeInsets.right;
  
  return rectangleEdges;
}

+ (YGPositionType)convertToYGPostionTypeForRNIPostionType:(RNIPositionType)positionType
{
  switch (positionType) {
    case RNIPositionTypeStatic:
      return YGPositionTypeStatic;
      
    case RNIPositionTypeRelative:
      return YGPositionTypeRelative;
      
    case RNIPositionTypeAbsolute:
      return YGPositionTypeAbsolute;
      
    default:
      NSAssert(NO, @"Unsupported RNIPositionType value");
  }
}
#endif

+ (RNILayoutMetrics *)convertToRNILayoutMetricsForPaperLayoutMetrics:(RCTLayoutMetrics)layoutMetrics withShadowView:(RCTShadowView *)shadowView
{
  RNILayoutMetrics *swiftLayoutMetrics = [RNILayoutMetrics new];
  
  swiftLayoutMetrics.frame = layoutMetrics.frame;
  swiftLayoutMetrics.contentFrame = layoutMetrics.contentFrame;
  swiftLayoutMetrics.displayTypeRaw = layoutMetrics.displayType;
  swiftLayoutMetrics.layoutDirectionRaw = layoutMetrics.layoutDirection;
    
  swiftLayoutMetrics.contentInsets = shadowView.paddingAsInsets;
  swiftLayoutMetrics.positionTypeRaw = shadowView.position;
  
  swiftLayoutMetrics.overflowInset = ^{
    CGSize size = layoutMetrics.frame.size;
    UIEdgeInsets overflowInset = UIEdgeInsets();
    
    overflowInset.left =
      MIN(CGRectGetMinX(layoutMetrics.contentFrame), 0);
      
    overflowInset.top =
      MIN(CGRectGetMinY(layoutMetrics.contentFrame), 0);
    
    overflowInset.right =
      -MAX(CGRectGetMaxX(layoutMetrics.contentFrame) - size.width, 0);
      
    overflowInset.bottom =
      -MAX(CGRectGetMaxY(layoutMetrics.contentFrame) - size.height, 0);
    
    return overflowInset;
  }();
    
  return swiftLayoutMetrics;
}

/// Extract property name from setter selector
/// E.g. `setOnEvent:` -> `onEvent`
+ (NSString *)extractPropertyNameForSetterSelector:(SEL)selector
{
  NSMutableString *string =
    [NSMutableString stringWithString: NSStringFromSelector(selector)];
  
  [string replaceOccurrencesOfString:@"set"
                          withString:@""
                             options:NSLiteralSearch
                               range:NSMakeRange(0, 3)];
  
  [string replaceOccurrencesOfString:@":"
                          withString:@""
                            options:NSLiteralSearch
                              range:NSMakeRange(0, string.length)];
  
  NSString *firstLetterLowercased =
    [[string substringToIndex:1] lowercaseString];
    
  [string replaceCharactersInRange:NSMakeRange(0,1)
                           withString:firstLetterLowercased];
  
  return string;
};

+ (NSString *)createSetterSelectorStringForPropertyName:(NSString *)propertyName
{
  NSMutableString *setterName = [NSMutableString stringWithString:@"set"];
    
  [setterName appendString:^(){
    NSString *firstLetter = [propertyName substringToIndex:1];
    return [firstLetter capitalizedString];
  }()];
  
  [setterName appendString: [propertyName substringFromIndex:1]];
  [setterName appendString:@":"];
  
  return setterName;
}

+ (void)dispatchToJSThreadViaBridgeForBlock:(void (^)(void))block
{
  RCTBridge *bridge = [RCTBridge currentBridge];
  [bridge dispatchBlock:block queue:RCTJSThread];
}

+ (void)dispatchToJSThreadViaCallInvokerForBlock:(void (^)(void))block
{
#if __cplusplus
  RCTBridge *bridge = [RCTBridge currentBridge];
  RCTBridgeProxy *bridgeProxy = (RCTBridgeProxy *)bridge;
  
  std::shared_ptr<facebook::react::CallInvoker> jsCallInvoker = [bridgeProxy jsCallInvoker];
  
  #if REACT_NATIVE_TARGET_VERSION <= 74
  facebook::react::CallFunc dispatchBlock = [block]() {
  #else
  facebook::react::CallFunc dispatchBlock = [block](facebook::jsi::Runtime &rt) {
  #endif
    block();
  };
  
  jsCallInvoker->invokeAsync(
    /* priority: */ facebook::react::SchedulerPriority::NormalPriority,
    /* func    : */ std::move(dispatchBlock)
  );
#endif
}

+ (id)alloc
{
  [NSException raise:@"Cannot be instantiated!"
              format:@"Static class 'RNIObjcUtils' cannot be instantiated!"];
  return nil;
}

@end
