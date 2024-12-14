//
//  RNIBaseViewPaperPropHolder.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/23/24.
//

#import "RNIBaseViewPaperPropHolder.h"
#import "RNIObjcUtils.h"

#if !RCT_NEW_ARCH_ENABLED
#import "RNIBaseViewPaperPropHolder.h"
#import "RNIBaseViewPaperPropHandler.h"

#import "RNIBaseView.h"


static BOOL SHOULD_LOG = NO;

@implementation RNIBaseViewPaperPropHolder {
  NSMutableDictionary *_propsMap;
};

- (instancetype)initWithParentPropHandler:(RNIBaseViewPaperPropHandler *)propHandler
{
  self = [super init];
  if (self) {
    self.parentPropHandler = propHandler;
    self->_propsMap = [NSMutableDictionary new];
  };
  
  return self;
}

- (RNIBaseView *)parentView
{
  if(self->_parentPropHandler == nil){
    return nil;
  };
  
  if(self->_parentPropHandler.parentView == nil){
    return nil;
  }
  
  return self->_parentPropHandler.parentView;
}

- (void)handlePropSetterCallForSelector:(SEL)selector
                          withPropValue:(id)propValue
{
  /// Extract event name from selector
  /// E.g. `setProp:` -> `prop`
  NSString *propName =
    [RNIObjcUtils extractPropertyNameForSetterSelector:selector];
    
  // WIP TBA - store prop and notify
  [self->_propsMap setValue:propValue forKey:propName];
  
  if(!self.parentView){
    return;
  };
  
  [self.parentView notifyOnPaperSetProp:propName
                              withValue:propValue];

#if DEBUG
  NSString *parentViewClassName = ^{
    if(self.parentView != nil){
      return NSStringFromClass([self.parentView class]);
    }
    
    return @"N/A";
  }();
  
  RNILog(
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
