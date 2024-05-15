//
//  UIView+RNIHelpers.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import "UIView+RNIHelpers.h"
#import <objc/runtime.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#import <React/UIView+React.h>
#endif


@implementation UIView (RNIHelpers)

- (UIResponder *)findParentResponderWhere:(ResponderPredicateBlock)predicateBlock
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

- (NSString *)getReactNativeID
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

@end
