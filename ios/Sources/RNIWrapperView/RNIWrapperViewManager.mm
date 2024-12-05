//
//  RNIWrapperViewManager.m
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

#import "RNIWrapperView.h"
#import <objc/runtime.h>

#import "RNIBaseViewUtils.h"

#import "RCTBridge.h"
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>


@interface RNIWrapperViewManager : RCTViewManager
@end

@implementation RNIWrapperViewManager

RCT_EXPORT_MODULE(RNIWrapperView)

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView *)view
{
  return [[RNIWrapperView alloc] initWithBridge:self.bridge];
}
#endif

RNI_EXPORT_VIEW_PROPERTY(rawDataForNative, *NSDictionary)

RNI_EXPORT_VIEW_EVENT(onDidSetViewID, RCTBubblingEventBlock)
RNI_EXPORT_VIEW_EVENT(onViewWillRecycle, RCTBubblingEventBlock)
RNI_EXPORT_VIEW_EVENT(onRawNativeEvent, RCTBubblingEventBlock)

@end
