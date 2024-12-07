//
//  RNIDummyTestViewManager.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/13/24.
//
#import "RNIDummyTestView.h"

#import "../../Swift.h"
#import "RNIBaseViewUtils.h"

#import <objc/runtime.h>

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
#endif

RNI_EXPORT_VIEW_PROPERTY(someBool, BOOL);
RNI_EXPORT_VIEW_PROPERTY(someString, NSString);
RNI_EXPORT_VIEW_PROPERTY(someStringOptional, NSString);
RNI_EXPORT_VIEW_PROPERTY(someNumber, NSNumber);
RNI_EXPORT_VIEW_PROPERTY(someNumberOptional, NSNumber);
RNI_EXPORT_VIEW_PROPERTY(someObject, NSDictionary);
RNI_EXPORT_VIEW_PROPERTY(someObjectOptional, NSDictionary);
RNI_EXPORT_VIEW_PROPERTY(someArray, NSArray);
RNI_EXPORT_VIEW_PROPERTY(someArrayOptional, NSArray);
  
RNI_EXPORT_VIEW_EVENT(onSomeDirectEventWithEmptyPayload, RCTDirectEventBlock);
RNI_EXPORT_VIEW_EVENT(onSomeDirectEventWithObjectPayload, RCTDirectEventBlock);
RNI_EXPORT_VIEW_EVENT(onSomeBubblingEventWithEmptyPayload, RCTBubblingEventBlock);
RNI_EXPORT_VIEW_EVENT(onSomeBubblingEventWithObjectPayload, RCTBubblingEventBlock);


@end

