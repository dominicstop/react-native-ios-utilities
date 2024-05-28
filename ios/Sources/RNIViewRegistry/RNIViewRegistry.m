//
//  RNIViewRegistry.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/22/24.
//

#import "RNIViewRegistry.h"
#import "RNIRegistrableView.h"

#import "react-native-ios-utilities/RNIObjcUtils.h"

static BOOL SHOULD_LOG = NO;

@implementation RNIViewRegistry {
  NSMapTable *_viewRegistry;
  NSInteger _counterViewID;
}

+ (instancetype)shared {
  static RNIViewRegistry *sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });

  return sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {
    self->_viewRegistry = [NSMapTable strongToWeakObjectsMapTable];
    self->_counterViewID = 0;
  }
  return self;
}

- (void)registerView:(UIView<RNIRegistrableView> *)view
{
  NSString *viewID = [@(self->_counterViewID++) stringValue];
  view.viewID = viewID;
  [self->_viewRegistry setObject:view forKey:viewID];
  
  RNILog(
    @"%@\n%@ %@\n%@ %@\n%@ %lu",
    @"RNIViewRegistry.registerView",
    @" - Class Name:", NSStringFromClass([view class]),
    @" - viewID:", viewID,
    @" - View Registry Count:", [self->_viewRegistry count]
  );
}

- (UIView *)getViewForViewID:(NSString *)viewID
{
  NSDictionary *viewRegistryDict = [self->_viewRegistry dictionaryRepresentation];
  return [viewRegistryDict valueForKey:viewID];
}

@end
