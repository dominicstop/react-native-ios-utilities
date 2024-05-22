//
//  RNIBaseViewPaperEventHandler.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if !RCT_NEW_ARCH_ENABLED
#import "RNIBaseViewPaperEventHandler.h"
#import "RNIBaseViewEventHolder.h"
#import "RNIBaseView.h"

#import <objc/runtime.h>

static NSMutableDictionary * _sharedEventHolderClassRegistry = nil;


@implementation RNIBaseViewPaperEventHandler {
  __weak RNIBaseView *_parentView;
  Class  _eventHolderClass;
  RNIBaseViewEventHolder *_eventHolderInstance;
};

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
      return [refClassName stringByAppendingString:@"EventHandler"];
    }();
    
    Class associatedClass = ^{
      Class matchingClass =
        [[[self class] sharedClassRegistry] objectForKey:className];
        
      if(matchingClass != nil){
        return matchingClass;
      };
      
      Class newClass = objc_allocateClassPair(
        [RNIBaseViewEventHolder class],
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

- (id)forwardingTargetForSelector:(SEL)aSelector;
{
  BOOL shouldForwardToEventHolder = ^{
    NSString *selectorString = NSStringFromSelector(aSelector);
    return [selectorString containsString:@":"];
  }();
  
  BOOL shouldAddMethodForSelector =
    ![self->_eventHolderInstance respondsToSelector:aSelector];
    
#if DEBUG
  NSLog(
    @"%@\n%@ %@\n%@ %@\n%@ %d\n%@ %d",
    @"RNIBaseViewEventHandler.forwardingTargetForSelector",
    @" - arg aSelector:", NSStringFromSelector(aSelector),
    @" - self. _eventHolderClass:", NSStringFromClass(self->_eventHolderClass),
    @" - shouldForwardToEventHolder:", shouldForwardToEventHolder,
    @" - shouldAddMethodForSelector:", shouldAddMethodForSelector
  );
#endif
  
  if(!shouldForwardToEventHolder){
    return self->_parentView;
  };
  
  if(shouldAddMethodForSelector){
    Method method = class_getInstanceMethod(self->_eventHolderClass, aSelector);
    
    class_addMethod(
      self->_eventHolderClass, aSelector,
      (IMP)handleSetterInvocation,
      method_getTypeEncoding(method)
    );
    //object_setClass(self->_eventHolderInstance, self->_eventHolderClass);
  };
  
  return self->_eventHolderInstance;
}

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

void handleSetterInvocation(RNIBaseViewEventHolder *_self, SEL _cmd, id _arg) {
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
