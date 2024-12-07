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

#import "RNIObjcUtils.h"

#import <objc/runtime.h>

static BOOL SHOULD_LOG = NO;

@implementation RNIBaseViewPaperPropHandler {
  __weak RNIBaseView *_parentView;
  Class  _propHolderClass;
  NSString *_propHolderClassName;
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

/// Key: `NSString`, class name
/// Value: `NSArray<NSString>`, list of prop names
///
+ (NSMutableDictionary *)sharedSupportedPropsRegistry
{
  static NSMutableDictionary * _sharedSupportedPropsRegistry = nil;
  
  if (_sharedSupportedPropsRegistry == nil) {
    _sharedSupportedPropsRegistry = [NSMutableDictionary new];
  };
    
  return _sharedSupportedPropsRegistry;
}

/// Key: `NSString`, class name
/// Value: `NSDictionary`, boolSettersToPropNameMap
/// * Key: `NSString`, selector string, i.e. prop setter name
/// * Value: `NSString`, prop name
///
+ (NSMutableDictionary *)sharedBoolPropsMap
{
  static NSMutableDictionary * _sharedBoolPropsMap = nil;
  
  if (_sharedBoolPropsMap == nil) {
    _sharedBoolPropsMap = [NSMutableDictionary new];
  };
    
  return _sharedBoolPropsMap;
}

// MARK: - Setter/Getters
// ----------------------

- (NSMutableDictionary *)boolSettersToPropNameMap
{
  return [[[self class] sharedBoolPropsMap] objectForKey:self->_propHolderClassName];
};

- (void)setBoolSettersToPropNameMap:(NSMutableDictionary *)newValue
{
  [[[self class] sharedBoolPropsMap] setObject:newValue
                                        forKey:self->_propHolderClassName];
}

// MARK: - Init
// ------------

- (instancetype)initWithParentRef:(RNIBaseView *)parentView
{
  self = [[self class] new];
  if(self){
    self->_parentView = parentView;
    
    NSString *className = ^{
      NSString *refClassName = NSStringFromClass([parentView class]);
      return [refClassName stringByAppendingString:@"PropHolder"];
    }();
    
    self->_propHolderClassName = className;
    
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

- (void)createSettersIfNeededForProps:(NSArray *)props
{
  NSArray *associatedProps =
    [[[self class] sharedSupportedPropsRegistry] objectForKey:self->_propHolderClassName];
  
  BOOL shouldCreateSettersForProps = ^{
    if(associatedProps == nil){
      return YES;
    };
    
    if([associatedProps count] != [props count]) {
      return YES;
    };
    
    return NO;
  }();
  
  if(!shouldCreateSettersForProps){
    return;
  };
  
  [[[self class] sharedSupportedPropsRegistry] setObject:props
                                                  forKey:self->_propHolderClassName];
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

- (void)setPropTypeMapIfNeeded:(NSDictionary *)propTypeMap
{
  BOOL shouldCreateBoolPropMap = self.boolSettersToPropNameMap == nil;
  if(!shouldCreateBoolPropMap){
    return;
  };
  
  self.boolSettersToPropNameMap = [NSMutableDictionary new];

  [propTypeMap enumerateKeysAndObjectsUsingBlock:^(
    NSString *propName,
    NSString *propType,
    BOOL *stop
  ) {
    BOOL isTypeBool =
      [propType localizedCaseInsensitiveContainsString:@"bool"];
      
    if(isTypeBool){
      NSString *setterName =
        [RNIObjcUtils createSetterSelectorStringForPropertyName:propName];
        
      [self.boolSettersToPropNameMap setObject:propName
                                        forKey:setterName];
    };
  }];
}

- (BOOL)isBoolSetterForSelector:(SEL)selector
{
  NSString *selectorString = NSStringFromSelector(selector);
  id match = [self.boolSettersToPropNameMap valueForKey:selectorString];
  BOOL hasMatch = match != nil;
  
  return hasMatch;
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
