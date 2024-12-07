//
//  UIView+RNIPaperHelpers.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/17/24.
//

#import "UIView+RNIPaperHelpers.h"

#import "RNIBaseView.h"
#import "UIView+RNIHelpers.h"
#import "UIApplication+RNIHelpers.h"

#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <React/RCTUIManager.h>
#import <React/RCTUIManagerUtils.h>
#import <React/RCTShadowView.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#endif


@implementation UIView (RNIPaperHelpers)

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
  
  return [RCTBridge currentBridge];
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

- (void)reactGetShadowViewWithCompletionHandler:(RNIPaperShadowViewCompletionBlock)completionBlock
{
  RCTBridge *reactBridge = [self reactGetPaperBridge];
  
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
        completionBlock(shadowView);
      });
    };
  });
}

@end
