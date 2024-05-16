//
//  UIView+RNIHelpers.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import "UIView+RNIHelpers.h"
#import <objc/runtime.h>

#import "react-native-ios-utilities/Swift.h"
#import "react-native-ios-utilities/RNIBaseView.h"
#import "react-native-ios-utilities/RNIObjcUtils.h"
#import "react-native-ios-utilities/UIApplication+RNIHelpers.h"

#import <React/RCTBridge.h>
#import <React/RCTRootView.h>

#if RCT_NEW_ARCH_ENABLED
#import "react-native-ios-utilities/UIApplication+RNIHelpers.h"
#import "react-native-ios-utilities/UIView+RNIFabricHelpers.h"

#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#import <React/UIView+React.h>
#import <React/RCTUIManager.h>
#import <React/RCTShadowView.h>
#endif


@implementation UIView (RNIHelpers)

- (UIResponder *)findParentResponderForPredicate:(RNIResponderPredicateBlock)predicateBlock
{
  UIResponder *responder = self;
  while ((responder = [responder nextResponder])) {
    BOOL isMatch = predicateBlock(responder);
    if(isMatch){
      return responder;
    }
  }
  
  return nil;
}

- (UIView *)recursivelyFindSubviewForPredicate:(RNIViewPredicateBlock)predicateBlock
{
  if([self.subviews count] == 0){
    return nil;
  };
  
  for (UIView *subview in self.subviews) {
    BOOL isMatch = predicateBlock(subview);
    if(isMatch){
      return subview;
    };
    
    UIView *match = [subview recursivelyFindSubviewForPredicate:predicateBlock];
    if(match != nil){
      return match;
    };
  };
  
  return nil;
}

- (NSArray<UIView*> *)recursivelyGetAllSubviews
{
  NSMutableArray<UIView *> *views = [NSMutableArray new];
  
  for (UIView *subview in self.subviews) {
    [views addObject:subview];
    
    NSArray *subviews = [subview recursivelyGetAllSubviews];
    [views addObjectsFromArray:subviews];
  };
  
  return views;
}

// MARK: - React-Native Related
// ----------------------------

- (NSString *)reactGetNativeID
{
  #if RCT_NEW_ARCH_ENABLED
  if ([self isKindOfClass:[RCTViewComponentView class]]) {
    RCTViewComponentView *componentView = (RCTViewComponentView *)self;
    return componentView.nativeId;
  };
  #else
  if ([self isKindOfClass:[RCTView class]]) {
    RCTView *reactView = (RCTView *)self;
    return reactView.nativeID;
  };
  #endif
  
  return nil;
}

// MARK: React-Native - Paper-Related
// ----------------------------------

- (RCTBridge *)reactGetPaperBridge
{
  #if RCT_NEW_ARCH_ENABLED
  RCTSurfacePresenterBridgeAdapter *reactBridgeAdapter =
    [[UIApplication sharedApplication] reactBridgeAdapter];
    
  if(reactBridgeAdapter != nil){
    return reactBridgeAdapter.bridge;
  };
  #endif

  RCTRootView *reactPaperRootView = [self reactGetPaperRootView];
  if(reactPaperRootView != nil){
    return reactPaperRootView.bridge;
  };

  UIResponder *currentResponder = self;
  while (currentResponder != nil) {
    if([currentResponder isKindOfClass: [RCTRootView class]]) {
      RCTRootView *reactRootView = (RCTRootView *)currentResponder;
      return reactRootView.bridge;
    };
    
    if([currentResponder isKindOfClass:[RNIBaseView class]]){
      RNIBaseView *baseView = (RNIBaseView *)currentResponder;
      return baseView.bridge;
    };
    
    currentResponder = [currentResponder nextResponder];
  };
  
  return nil;
}

- (RCTRootView *)reactGetPaperRootView
{
  //UIView *view = [self paper]
  
  UIWindow *window = ^{
    if(self.window != nil){
      return self.window;
    };
    
    return [[[UIApplication sharedApplication] getAllActiveKeyWindows] firstObject];
  }();
  
  UIViewController *rootVC = window.rootViewController;
  if(rootVC == nil){
    return nil;
  };
  
  UIView *rootView = rootVC.view;
  if([rootView isKindOfClass:[RCTRootView class]]){
    return (RCTRootView *)rootView;
  };
  
  UIView *match = [rootView recursivelyFindSubviewForPredicate:^BOOL(UIView *subview) {
    return [subview isKindOfClass:[RCTRootView class]];
  }];
  
  if(match != nil){
    return (RCTRootView *)match;
  };
  
  return nil;
}

@end
