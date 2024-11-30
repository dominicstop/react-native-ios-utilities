//
//  UIView+RNIHelpers.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <objc/runtime.h>

#import "UIView+RNIHelpers.h"

#if __has_include(<react_native_ios_utilities/Swift.h>)
#import <react_native_ios_utilities/Swift.h>
#import <react_native_ios_utilities/RNIObjcUtils.h>
#else
#import "react-native-ios-utilities/Swift.h"
#import "react-native-ios-utilities/RNIObjcUtils.h"
#endif

#if RCT_NEW_ARCH_ENABLED
#if __has_include(<react_native_ios_utilities/UIView+RNIFabricHelpers.h>)
#import <react_native_ios_utilities/UIView+RNIFabricHelpers.h>
#else
#import "react-native-ios-utilities/UIView+RNIFabricHelpers.h"
#endif
#import <React/RCTViewComponentView.h>
#else
#if __has_include(<react_native_ios_utilities/UIView+RNIPaperHelpers.h>)
#import <react_native_ios_utilities/UIView+RNIPaperHelpers.h>
#else
#import "react-native-ios-utilities/UIView+RNIPaperHelpers.h"
#endif
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
  
  return nil;
  #else
  return self.nativeID;
  #endif
}

- (NSNumber *)reactNativeTag
{
  #if RCT_NEW_ARCH_ENABLED
  if([self isKindOfClass:[RCTViewComponentView class]]){
    return @(self.tag);
  };
  
  return nil;
  #else
  return self.reactTag;
  #endif
}

/// Works on fabric + paper
- (void)reactGetLayoutMetricsWithCompletionHandler:(nonnull RNILayoutMetricsCompletionBlock)completionBlock
{
  #if RCT_NEW_ARCH_ENABLED
  RNILayoutMetrics *layoutMetrics = [self reactLayoutMetrics];
  completionBlock(layoutMetrics);
  #else
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
