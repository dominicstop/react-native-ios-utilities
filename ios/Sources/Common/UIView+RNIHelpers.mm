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

#import <React/RCTView.h>
#import <React/UIView+React.h>
#import <React/RCTUIManager.h>
#import <React/RCTShadowView.h>

#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTLayout.h>
#import <React/RCTUIManagerUtils.h>

#if RCT_NEW_ARCH_ENABLED
#import "react-native-ios-utilities/UIView+RNIFabricHelpers.h"
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <React/RCTViewComponentView.h>
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

/// Works on fabric + paper
- (void)reactGetLayoutMetricsWithCompletionHandler:(nonnull RNILayoutMetricsCompletionBlock)completionBlock
{
  #if RCT_NEW_ARCH_ENABLED
  RNILayoutMetrics *layoutMetrics = [self reactGetLayoutMetrics];
  completionBlock(layoutMetrics);
  #else
  RCTBridge *reactBridge = [self reactGetPaperBridge];
  if(reactBridge == nil){
    completionBlock(nil);
  };
  
  RCTUIManager *uiManager = reactBridge.uiManager;
  if(uiManager == nil){
   completionBlock(nil);
  };
  
  NSNumber *reactTag = self.reactTag;
  if(reactTag == nil || [reactTag intValue] <= 0){
    completionBlock(nil);
  };
  
  RCTExecuteOnUIManagerQueue(^{
    RCTShadowView *shadowView = [uiManager shadowViewForReactTag:reactTag];
    if(shadowView == nil){
      RCTExecuteOnMainQueue(^{
        completionBlock(nil);
      });
      
    } else {
      RCTExecuteOnMainQueue(^{
        RNILayoutMetrics *layoutMetrics = [RNIObjcUtils
          convertToRNILayoutMetricsForPaperLayoutMetrics:shadowView.layoutMetrics
                                          withShadowView:shadowView];
          
        completionBlock(layoutMetrics);
      });
    };
  });
  #endif
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
  #else
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
  #endif
  
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

- (void)reactGetPaperLayoutMetricsWithCompletionHandler:(RNIPaperLayoutMetricsCompletionBlock)completionBlock
{
  RCTBridge *reactBridge = [self reactGetPaperBridge];
  if(reactBridge == nil){
    completionBlock({-1}, NO);
  };
  
  RCTUIManager *uiManager = reactBridge.uiManager;
  if(uiManager == nil){
   completionBlock({-1}, NO);
  };
  
  NSNumber *reactTag = self.reactTag;
  if(reactTag == nil || [reactTag intValue] <= 0){
    completionBlock({-1}, NO);
  };
  
  RCTExecuteOnUIManagerQueue(^{
    RCTShadowView *shadowView = [uiManager shadowViewForReactTag:reactTag];
    if(shadowView == nil){
      RCTExecuteOnMainQueue(^{
        completionBlock({-1}, NO);
      });
      
    } else {
      RCTExecuteOnMainQueue(^{
        completionBlock(shadowView.layoutMetrics, YES);
      });
    };
  });
}

@end
