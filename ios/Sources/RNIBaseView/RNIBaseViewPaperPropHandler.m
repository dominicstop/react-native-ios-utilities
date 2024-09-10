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

static BOOL SHOULD_LOG = NO;

@implementation RNIBaseViewPaperPropHandler {
  __weak RNIBaseView *_parentView;
  Class  _propHolderClass;
  NSMutableDictionary *_boolSettersToPropNameMap;
};

// MARK: - Class Members
// ---------------------

/// Key: `NSString`, class name
/// Value: `Class`
///
+ (NSMutableDictionary *)sharedClassRegistry
{
  static NSMutableDictionary * _sharedClassRegistry = nil;
  
  if (_sharedClassRegistry == nil) {
    _sharedClassRegistry = [NSMutableDictionary new];
  };
    
  return _sharedClassRegistry;
}

// MARK: - Init
// ------------

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
    self.propHolder = [[associatedClass new] initWithParentPropHandler:self];
  };
  
  return self;
}

// MARK: Methods (Public)
// ----------------------

- (void)createSettersForProps:(NSArray *)props
{
  for (NSString *propName in props) {
    NSString *setterName =
      [RNIObjcUtils createSetterSelectorStringForPropertyName:propName];
    
    SEL setterSelector = NSSelectorFromString(setterName);
    [self createSetterForSelector: setterSelector];
    
    RNILog(
      @"%@\n%@ %@\n%@ %@\n%@ %@\n%@ %@",
      @"[RNIBaseViewPaperEventHandler createSettersForProps]",
      @" - self._propHolderClass:", NSStringFromClass(self->_propHolderClass),
      @" - propName:", propName,
      @" - setterName:", setterName,
      @" - setterSelector:", NSStringFromSelector(setterSelector)
    );
  };
};

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

// MARK: - Methods (Internal)
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
    && ![self.propHolder respondsToSelector:aSelector];
    
  RNILog(
    @"%@\n%@ %@\n%@ %@\n%@ %d\n%@ %d\n%@ %d",
    @"RNIBaseViewPaperPropHandler.forwardingTargetForSelector",
    @" - arg aSelector:", NSStringFromSelector(aSelector),
    @" - self._propHolderClass:", NSStringFromClass(self->_propHolderClass),
    @" - isSelectorSetter:", isSelectorSetter,
    @" - shouldForwardToBaseView:", shouldForwardToBaseView,
    @" - shouldAddMethodForSelector:", shouldAddMethodForSelector
  );
  
  if(shouldForwardToBaseView){
    return self->_parentView;
  };
  
  if(shouldAddMethodForSelector){
    [self createSetterForSelector: aSelector];
  };
  
  return self.propHolder;
}

// MARK: - Static Functions
// ------------------------

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

  RNILog(
    @"%@\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseViewPaperPropHolder._handleReactPropSetterInvocation",
    @" - arg _self:", _self,
    @" - arg _cmd:", NSStringFromSelector(_cmd),
    @" - arg _arg:", boxedValue
  );

  [_self handlePropSetterCallForSelector:_cmd
                           withPropValue:boxedValue];
}

@end
#endif
