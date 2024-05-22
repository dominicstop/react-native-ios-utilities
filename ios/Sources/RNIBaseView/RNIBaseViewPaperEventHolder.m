//
//  RNIBaseViewPaperEventHolder.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if !RCT_NEW_ARCH_ENABLED
#import "RNIBaseViewPaperEventHolder.h"
#import "RNIBaseViewPaperEventHandler.h"

#if DEBUG
#import "RNIBaseView.h"
#endif


@implementation RNIBaseViewPaperEventHolder {
  NSMutableDictionary *_eventMap;
  __weak RNIBaseViewPaperEventHandler *_parentEventHandler;
};

- (instancetype)initWithParentEventHandler:(RNIBaseViewPaperEventHandler *)eventHandler
{
  self = [super init];
  if (self) {
    self->_parentEventHandler = eventHandler;
    self->_eventMap = [NSMutableDictionary new];
  };
  
  return self;
}

- (void)registerEventEmitterForSelector:(SEL)selector
                       withEventEmitter:(id)eventEmitter
{
  /// Extract event name from selector
  /// E.g. `setOnEvent:` -> `onEvent`
  NSString *eventName = ^{
    NSString *eventName = NSStringFromSelector(selector);
    
    eventName = [eventName stringByReplacingOccurrencesOfString:@"set"
                                                    withString:@""];
    
    eventName = [eventName stringByReplacingOccurrencesOfString:@":"
                                                     withString:@""];
                                           
    NSString *firstLetterLowercased =
      [[eventName substringToIndex:1] lowercaseString];
      
    eventName = [eventName
      stringByReplacingCharactersInRange:NSMakeRange(0,1)
                              withString:firstLetterLowercased];
    
    return eventName;
  }();

  [self.eventMap setValue:eventEmitter forKey:eventName];
  
#if DEBUG
  NSString *parentViewClassName = ^{
    if(self->_parentEventHandler == nil){
      return @"N/A";
    }
    
    if(self->_parentEventHandler.parentView == nil){
      return @"N/A";
    }
    
    return NSStringFromClass([self->_parentEventHandler.parentView class]);
  }();
  
  NSLog(
    @"%@\n%@ %@\n%@ %@\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseViewEventHolder.registerEventEmitterForSelector",
    @" - arg selector:", NSStringFromSelector(selector),
    @" - arg eventEmitter:", eventEmitter,
    @" - self.className:", NSStringFromClass([self class]),
    @" - eventName:", eventName,
    @" - parentViewClassName:", parentViewClassName
  );
#endif
}

@end
#endif
