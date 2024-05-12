//
//  RNIDummyTestViewManager.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/13/24.
//
#import "RNIDummyTestView.h"

#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"


@interface RNIDummyTestViewManager : RCTViewManager
@end

@implementation RNIDummyTestViewManager

RCT_EXPORT_MODULE(RNIDummyTestView)

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView *)view
{
  return [[RNIDummyTestView new] initWithBridge:self.bridge];
}


// RCT_CUSTOM_VIEW_PROPERTY(color, NSString, UIView)
// {
//   [view setBackgroundColor: [Utils hexStringToColor:json]];
// }

#endif
@end
