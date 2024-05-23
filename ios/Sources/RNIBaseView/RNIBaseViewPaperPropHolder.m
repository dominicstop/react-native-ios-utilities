//
//  RNIBaseViewPaperPropHolder.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/23/24.
//

#import "RNIBaseViewPaperPropHolder.h"
#import "react-native-ios-utilities/RNIObjcUtils.h"

#if !RCT_NEW_ARCH_ENABLED
#import "RNIBaseViewPaperPropHolder.h"
#import "RNIBaseViewPaperPropHandler.h"

#if DEBUG
#import "RNIBaseView.h"
#endif


@implementation RNIBaseViewPaperPropHolder {
  NSMutableDictionary *_propsMap;
  __weak RNIBaseViewPaperPropHandler *_parentPropHandler;
};

- (instancetype)initWithParentPropHandler:(RNIBaseViewPaperPropHandler *)propHandler
{
  self = [super init];
  if (self) {
    self->_parentPropHandler = propHandler;
    self->_propsMap = [NSMutableDictionary new];
  };
  
  return self;
}

- (void)handlePropSetterCallForSelector:(SEL)selector
                          withPropValue:(id)propValue
{
  /// Extract event name from selector
  /// E.g. `setProp:` -> `prop`
  NSString *propName =
    [RNIObjcUtils extractPropertyNameForSetterSelector:selector];
    
  // WIP TBA - store prop and notify

#if DEBUG
  NSString *parentViewClassName = ^{
    if(self->_parentPropHandler == nil){
      return @"N/A";
    }
    
    if(self->_parentPropHandler.parentView == nil){
      return @"N/A";
    }
    
    return NSStringFromClass([self->_parentPropHandler.parentView class]);
  }();
  
  NSLog(
    @"%@\n%@ %@\n%@ %@\n%@ %@\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseViewPaperPropHolder.handlePropSetterCallForSelector",
    @" - arg selector:", NSStringFromSelector(selector),
    @" - arg propValue:", propValue,
    @" - self.className:", NSStringFromClass([self class]),
    @" - parentViewClassName:", parentViewClassName,
    @" - propName:", propName,
    @" - propValue:", propValue
  );
#endif
}

@end
#endif
