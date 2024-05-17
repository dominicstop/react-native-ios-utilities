//
//  UIView+RNIHelpers.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <objc/runtime.h>

#import "UIView+RNIHelpers.h"
#import "react-native-ios-utilities/Swift.h"
#import "react-native-ios-utilities/RNIObjcUtils.h"

#if RCT_NEW_ARCH_ENABLED
#import "react-native-ios-utilities/UIView+RNIFabricHelpers.h"
#import <React/RCTViewComponentView.h>
#else
#import "react-native-ios-utilities/UIView+RNIPaperHelpers.h"
#import <React/RCTView.h>
#import <React/UIView+React.h>
#import <React/RCTUIManager.h>
#import <React/RCTUIManagerUtils.h>
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

- (NSString *)reactNativeID {
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

@end
