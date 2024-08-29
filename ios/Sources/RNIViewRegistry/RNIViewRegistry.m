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
  NSMutableDictionary *_reactTagToViewIdMap;
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
    self->_reactTagToViewIdMap = [NSMutableDictionary new];
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

- (UIView *)getViewForReactTag:(NSNumber *)reactTag
{
  NSString *viewID = [self->_reactTagToViewIdMap objectForKey:reactTag];
  if(viewID == nil){
    return nil;
  };
  
  UIView *match = [self getViewForViewID:viewID];
  if(match == nil){
    [self->_reactTagToViewIdMap removeObjectForKey:reactTag];
    return nil;
  };
  
  return match;
}

@end
