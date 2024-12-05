//
//  RNIDetachedViewManager.m
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

#import "RNIDetachedView.h"
#import <objc/runtime.h>

#import "RNIBaseViewUtils.h"

#import "RCTBridge.h"
#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>


@interface RNIDetachedViewManager : RCTViewManager
@end

@implementation RNIDetachedViewManager

RCT_EXPORT_MODULE(RNIDetachedView)

#ifndef RCT_NEW_ARCH_ENABLED
- (UIView *)view
{
  return [[RNIDetachedView alloc] initWithBridge:self.bridge];
}
#endif

RNI_EXPORT_VIEW_PROPERTY(rawDataForNative, *NSDictionary)

RNI_EXPORT_VIEW_EVENT(onDidSetViewID, RCTBubblingEventBlock)
RNI_EXPORT_VIEW_EVENT(onViewWillRecycle, RCTBubblingEventBlock)
RNI_EXPORT_VIEW_EVENT(onRawNativeEvent, RCTBubblingEventBlock)

RNI_EXPORT_VIEW_PROPERTY(reactChildrenCount, NSNumber);

RNI_EXPORT_VIEW_EVENT(onViewDidDetachFromParent, RCTBubblingEventBlock)
RNI_EXPORT_VIEW_EVENT(onContentViewDidDetach, RCTBubblingEventBlock)

@end
