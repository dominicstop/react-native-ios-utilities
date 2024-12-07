//
//  RNIBaseViewPaperEventHandler.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if !RCT_NEW_ARCH_ENABLED
#import "RNIBaseViewPaperEventHandler.h"
#import "RNIBaseViewPaperEventHolder.h"
#import "RNIBaseView.h"

#import "RNIObjcUtils.h"

#import <objc/runtime.h>

static BOOL SHOULD_LOG = NO;

@implementation RNIBaseViewPaperEventHandler {
  __weak RNIBaseView *_parentView;
  Class  _eventHolderClass;
  NSString *_eventHolderClassName;
  RNIBaseViewPaperEventHolder *_eventHolderInstance;
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
/// Value: `NSArray<NSString>`, list of event names
///
+ (NSMutableDictionary *)sharedSupportedEventRegistry
{
  static NSMutableDictionary * _sharedSupportedEventRegistry = nil;
  
  if (_sharedSupportedEventRegistry == nil) {
    _sharedSupportedEventRegistry = [NSMutableDictionary new];
  };
    
  return _sharedSupportedEventRegistry;
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
      return [refClassName stringByAppendingString:@"EventHolder"];
    }();
    
    self->_eventHolderClassName = className;
    
    Class associatedClass = ^{
      Class matchingClass =
        [[[self class] sharedClassRegistry] objectForKey:className];
        
      if(matchingClass != nil){
        return matchingClass;
      };
      
      Class newClass = objc_allocateClassPair(
        [RNIBaseViewPaperEventHolder class],
        [className UTF8String],
        0
      );
      
      objc_registerClassPair(newClass);
      [[[self class] sharedClassRegistry] setObject:newClass forKey:className];
      
      return newClass;
    }();
    
    self->_eventHolderClass = associatedClass;
    self->_eventHolderInstance = [[associatedClass new] initWithParentEventHandler:self];
  };
  
  return self;
}

// MARK: Methods (Public)
// ----------------------

- (void)createSettersIfNeededForEvents:(NSArray *)events
{
  NSArray *associatedEvents =
    [[[self class] sharedSupportedEventRegistry] objectForKey:self->_eventHolderClassName];
    
  BOOL shouldCreateSettersForEvents = ^{
    if(associatedEvents == nil){
      return YES;
    };
    
    if([associatedEvents count] != [events count]) {
      return YES;
    };
    
    return NO;
  }();
    
  if(!shouldCreateSettersForEvents){
    return;
  };
  
  [[[self class] sharedSupportedEventRegistry] setObject:events
                                                  forKey:self->_eventHolderClassName];
  
  for (NSString *eventName in events) {
    NSString *setterName =
      [RNIObjcUtils createSetterSelectorStringForPropertyName:eventName];
    
    SEL setterSelector = NSSelectorFromString(setterName);
    [self createSetterForSelector: setterSelector];
    
    RNILog(
      @"%@\n%@ %@\n%@ %@\n%@ %@\n%@ %@",
      @"RNIBaseViewPaperEventHandler.createSettersForEvents",
      @" - self._eventHolderClass:", NSStringFromClass(self->_eventHolderClass),
      @" - eventName:", eventName,
      @" - setterName:", setterName,
      @" - setterSelector:", NSStringFromSelector(setterSelector)
    );
  };
};

- (void)invokeEventBlockForEventName:(NSString *)eventName
                         withPayload:(NSDictionary *)eventPayload
{
  if(self->_eventHolderInstance == nil){
    return;
  };
  
  void (^eventBlock)(NSDictionary *body) =
    [self->_eventHolderInstance.eventMap objectForKey:eventName];
    
  if(eventBlock == nil){
    return;
  };

  eventBlock(eventPayload);
}

// MARK: - Methods (Internal)
// --------------------------

- (void)createSetterForSelector:(SEL)selector
{
  Method method = class_getInstanceMethod(self->_eventHolderClass, selector);
    
  class_addMethod(
    /* cls  : */ self->_eventHolderClass,
    /* name : */ selector,
    /* imp  : */ (IMP)_handleReactEventSetterInvocation,
    /* types: */ method_getTypeEncoding(method)
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
       !shouldForwardToBaseView
    && ![self->_eventHolderInstance respondsToSelector:aSelector];
    
  RNILog(
    @"%@\n%@ %@\n%@ %@\n%@ %d\n%@ %d\n%@ %d",
    @"RNIBaseViewEventHandler.forwardingTargetForSelector",
    @" - arg aSelector:", NSStringFromSelector(aSelector),
    @" - self._eventHolderClass:", NSStringFromClass(self->_eventHolderClass),
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
  
  return self->_eventHolderInstance;
}

// MARK: - Static Functions
// ------------------------

void _handleReactEventSetterInvocation(RNIBaseViewPaperEventHolder *_self, SEL _cmd, id _arg) {
  RNILog(
    @"%@\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseViewEventHolder.registerEventEmitterForSelector",
    @" - arg _self:", _self,
    @" - arg _cmd:", NSStringFromSelector(_cmd),
    @" - arg _arg:", _arg
  );

  [_self registerEventEmitterForSelector:_cmd
                        withEventEmitter:_arg];
}

@end
#endif
