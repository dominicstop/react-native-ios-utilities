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

#import <objc/runtime.h>


@implementation RNIBaseViewPaperEventHandler {
  __weak RNIBaseView *_parentView;
  Class  _eventHolderClass;
  RNIBaseViewPaperEventHolder *_eventHolderInstance;
};

static NSMutableDictionary * _sharedEventHolderClassRegistry = nil;

+ (NSMutableDictionary *)sharedClassRegistry
{
  if ( _sharedEventHolderClassRegistry == nil) {
    _sharedEventHolderClassRegistry = [NSMutableDictionary new];
  };
    
  return _sharedEventHolderClassRegistry;
}

- (instancetype)initWithParentRef:(RNIBaseView *)parentView
{
  self = [[self class] new];
  if(self){
    self->_parentView = parentView;
    
    NSString *className = ^{
      NSString *refClassName = NSStringFromClass([parentView class]);
      return [refClassName stringByAppendingString:@"EventHolder"];
    }();
    
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

// MARK: Functions - Public
// ------------------------

- (void)createSettersForEvents:(NSArray *)events
{
  for (NSString *eventName in events) {
    NSMutableString *setterName = [NSMutableString stringWithString:@"set"];
    
    [setterName appendString:^(){
      NSString *firstLetter = [eventName substringToIndex:1];
      return [firstLetter capitalizedString];
    }()];
    
    [setterName appendString: [eventName substringFromIndex:1]];
    [setterName appendString:@":"];
    
    SEL setterSelector = NSSelectorFromString(setterName);
    [self createSetterForSelector: setterSelector];
    
#if DEBUG
    NSLog(
      @"%@\n%@ %@\n%@ %@\n%@ %@\n%@ %@",
      @"RNIBaseViewPaperEventHandler.createSettersForEvents",
      @" - self._eventHolderClass:", NSStringFromClass(self->_eventHolderClass),
      @" - eventName:", eventName,
      @" - setterName:", setterName,
      @" - setterSelector:", NSStringFromSelector(setterSelector)
    );
#endif
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

// MARK: Functions - Internal
// --------------------------

- (void)createSetterForSelector:(SEL)selector
{
  Method method = class_getInstanceMethod(self->_eventHolderClass, selector);
    
  class_addMethod(
    self->_eventHolderClass, selector,
    (IMP)handleSetterInvocation,
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
       !shouldForwardToBaseView
    && ![self->_eventHolderInstance respondsToSelector:aSelector];
    
#if DEBUG
  NSLog(
    @"%@\n%@ %@\n%@ %@\n%@ %d\n%@ %d\n%@ %d",
    @"RNIBaseViewEventHandler.forwardingTargetForSelector",
    @" - arg aSelector:", NSStringFromSelector(aSelector),
    @" - self._eventHolderClass:", NSStringFromClass(self->_eventHolderClass),
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
  
  return self->_eventHolderInstance;
}

void handleSetterInvocation(RNIBaseViewPaperEventHolder *_self, SEL _cmd, id _arg) {
#if DEBUG
  NSLog(
    @"%@\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseViewEventHolder.registerEventEmitterForSelector",
    @" - arg _self:", _self,
    @" - arg _cmd:", NSStringFromSelector(_cmd),
    @" - arg _arg:", _arg
  );
#endif

  [_self registerEventEmitterForSelector:_cmd
                        withEventEmitter:_arg];
}

@end
#endif
