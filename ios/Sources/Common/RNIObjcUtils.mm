//
//  RNIObjcUtils.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import <Foundation/Foundation.h>

#import "RNIObjcUtils.h"
#import "react-native-ios-utilities/Swift.h"

#import <folly/dynamic.h>
#import <React/RCTConversions.h>
#import <React/RCTFollyConvert.h>

#if __cplusplus
#include <react/renderer/core/LayoutMetrics.h>
#include <react/renderer/graphics/Rect.h>
#include <react/renderer/graphics/RectangleEdges.h>
#endif

@implementation RNIObjcUtils
#if __cplusplus
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
  
  NSLog(@"Unsupported data type in folly::dynamic");
  return nil;
}

+ (NSMutableDictionary *)convertFollyDynamicMapToMutableDict:(const std::unordered_map<std::string, folly::dynamic>&)stringToDynMap;
{
  NSMutableDictionary *dict = [NSMutableDictionary new];
  for (auto& [key, value]: stringToDynMap) {
    NSString *keyAsObjcString = [NSString stringWithUTF8String:key.c_str()];
    id valueAsId = facebook::react::convertFollyDynamicToId(value);
    
    dict[keyAsObjcString] = valueAsId;
  };
  
  return dict;
}

+ (RNILayoutMetrics *)createRNILayoutMetricsFrom:(facebook::react::LayoutMetrics)layoutMetrics
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

+ (id)alloc
{
  [NSException raise:@"Cannot be instantiated!"
              format:@"Static class 'RNIObjcUtils' cannot be instantiated!"];
  return nil;
}

@end
