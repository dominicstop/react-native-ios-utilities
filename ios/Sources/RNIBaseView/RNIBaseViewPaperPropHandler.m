//
//  RNIBaseViewPaperPropHandler.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/23/24.
//

#if !RCT_NEW_ARCH_ENABLED
#import "RNIBaseViewPaperPropHandler.h"
#import "RNIBaseViewPaperPropHolder.h"
#import "RNIBaseView.h"

#import "react-native-ios-utilities/RNIObjcUtils.h"

#import <objc/runtime.h>


@implementation RNIBaseViewPaperPropHandler {
  __weak RNIBaseView *_parentView;
  Class  _propHolderClass;
  RNIBaseViewPaperPropHolder *_propHolderInstance;
  
  NSMutableDictionary *_boolSettersToPropNameMap;
};

static NSMutableDictionary * _sharedPropHolderClassRegistry = nil;
+ (NSMutableDictionary *)sharedClassRegistry
{
  if ( _sharedPropHolderClassRegistry == nil) {
    _sharedPropHolderClassRegistry = [NSMutableDictionary new];
  };
    
  return _sharedPropHolderClassRegistry;
}

- (instancetype)initWithParentRef:(RNIBaseView *)parentView
{
  self = [[self class] new];
  if(self){
    self->_parentView = parentView;
    self->_boolSettersToPropNameMap = [NSMutableDictionary new];
    
    NSString *className = ^{
      NSString *refClassName = NSStringFromClass([parentView class]);
      return [refClassName stringByAppendingString:@"PropHolder"];
    }();
    
    Class associatedClass = ^{
      Class matchingClass =
        [[[self class] sharedClassRegistry] objectForKey:className];
        
      if(matchingClass != nil){
        return matchingClass;
      };
      
      Class newClass = objc_allocateClassPair(
        [RNIBaseViewPaperPropHolder class],
        [className UTF8String],
        0
      );
      
      objc_registerClassPair(newClass);
      [[[self class] sharedClassRegistry] setObject:newClass forKey:className];
      
      return newClass;
    }();
    
    self->_propHolderClass = associatedClass;
    self->_propHolderInstance = [[associatedClass new] initWithParentPropHandler:self];
  };
  
  return self;
}

// MARK: Functions - Public
// ------------------------

// TBI: createSettersForProps

- (void)setPropTypeMap:(NSDictionary *)propTypeMap
{
  [propTypeMap enumerateKeysAndObjectsUsingBlock:^(NSString *propName, NSString *propType, BOOL *stop) {
    BOOL isTypeBool =
      [propType localizedCaseInsensitiveContainsString:@"bool"];
      
    if(isTypeBool){
      NSString *setterName =
        [RNIObjcUtils createSetterSelectorStringForPropertyName:propName];
        
      [self->_boolSettersToPropNameMap setObject:propName
                                          forKey:setterName];
    };
  }];
}

- (BOOL)isBoolSetterForSelector:(SEL)selector
{
  NSString *selectorString = NSStringFromSelector(selector);
  id match = [self->_boolSettersToPropNameMap valueForKey:selectorString];
  
  return match != nil;
}

// MARK: Functions - Internal
// --------------------------

- (void)createSetterForSelector:(SEL)selector
{
  Method method = class_getInstanceMethod(self->_propHolderClass, selector);
    
  class_addMethod(
    self->_propHolderClass, selector,
    (IMP)_handleReactPropSetterInvocation,
    method_getTypeEncoding(method)
  );
}

- (id)forwardingTargetForSelector:(SEL)aSelector;
{
  BOOL isSelectorSetter = ^{
    NSString *selectorString = NSStringFromSelector(aSelector);
    return [selectorString containsString:@":"];
  }();
  
  BOOL shouldForwardToBaseView =
       !isSelectorSetter
    && [self->_parentView respondsToSelector:aSelector];
  
  BOOL shouldAddMethodForSelector =
       isSelectorSetter
    && ![self->_propHolderInstance respondsToSelector:aSelector];
    
#if DEBUG
  NSLog(
    @"%@\n%@ %@\n%@ %@\n%@ %d\n%@ %d\n%@ %d",
    @"RNIBaseViewPaperPropHandler.forwardingTargetForSelector",
    @" - arg aSelector:", NSStringFromSelector(aSelector),
    @" - self._propHolderClass:", NSStringFromClass(self->_propHolderClass),
    @" - isSelectorSetter:", isSelectorSetter,
    @" - shouldForwardToBaseView:", shouldForwardToBaseView,
    @" - shouldAddMethodForSelector:", shouldAddMethodForSelector
  );
#endif
  
  if(shouldForwardToBaseView){
    return self->_parentView;
  };
  
  if(shouldAddMethodForSelector){
    [self createSetterForSelector: aSelector];
  };
  
  return self->_propHolderInstance;
}



void _handleReactPropSetterInvocation(
  RNIBaseViewPaperPropHolder *_self,
  SEL _cmd,
  void *_arg
) {
  id boxedValue = ^{
    if((size_t)_arg > 1){
      return (__bridge id)_arg;
    };
    
    BOOL isSettingBoolProperty =
      [_self.parentPropHandler isBoolSetterForSelector:_cmd];
      
    if(!isSettingBoolProperty){
      return (__bridge id)_arg;
    };
    
    // assume _arg is a BOOL?
    return (id)[NSNumber numberWithInt:(int)(size_t)_arg];
  }();

#if DEBUG
  NSLog(
    @"%@\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseViewPaperPropHolder._handleReactPropSetterInvocation",
    @" - arg _self:", _self,
    @" - arg _cmd:", NSStringFromSelector(_cmd),
    @" - arg _arg:", boxedValue
  );
#endif

  [_self handlePropSetterCallForSelector:_cmd
                           withPropValue:boxedValue];
}

@end
#endif
