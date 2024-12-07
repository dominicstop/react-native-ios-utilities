//
//  RNIViewRegistry.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/22/24.
//

#import "RNIViewRegistry.h"
#import "RNIRegistrableView.h"

#import "RNIObjcUtils.h"

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


- (void)registerViewUsingReactTagForView:(UIView<RNIRegistrableView> *)view
{
  NSNumber *reactTag;
  if ([view respondsToSelector:NSSelectorFromString(@"reactNativeTag")]) {
    reactTag = [view valueForKey:@"reactNativeTag"];
  };
  
  if(reactTag == nil || reactTag <= 0){
    return;
  };
  
  __block NSString *viewID;
  
  BOOL isRegistered = ^{
    if(view.viewID == nil){
      return NO;
    };
    
    id match = [self getViewForViewID:view.viewID];
    if(match != nil){
      viewID = view.viewID;
      return YES;
    };
    
    viewID = [@(self->_counterViewID++) stringValue];
    return NO;
  }();
  
  if(!isRegistered){
    [self registerView:view];
  };
  
  if(reactTag != nil){
    [self->_reactTagToViewIdMap setObject:viewID forKey:reactTag];
  };
};

- (UIView *)getViewForViewID:(NSString *)viewID
{
  return [self->_viewRegistry objectForKey:viewID];
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
