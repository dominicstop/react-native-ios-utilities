//
//  RNIObjcUtils.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import <Foundation/Foundation.h>
#include <folly/dynamic.h>

@interface RNIObjcUtils : NSObject
@end

@implementation RNIObjcUtils

+ (id)convertFollyDynamicToId: (const folly::dynamic*)dyn {
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

+ (id)alloc {
  [NSException raise:@"Cannot be instantiated!"
              format:@"Static class 'RNIObjcUtils' cannot be instantiated!"];
  return nil;
}

@end
