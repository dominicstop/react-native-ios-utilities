//
//  UIApplication+RNIHelpers.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import "UIApplication+RNIHelpers.h"

// NOTE:
// * Build error starting in RN 78 + Paper
//
// * When importing `RCTAppDelegate`, it also starts importing fabric-related
//   stuff, e.g. `#include <jsinspector-modern/ReactCdp.h>`,
//   `#import <ReactCommon/RCTHost.h`, etc.
//
#if REACT_NATIVE_TARGET_VERSION < 78 || RCT_NEW_ARCH_ENABLED || !defined(REACT_NATIVE_TARGET_VERSION)
#define USE_RCT_APP_DELEGATE
#import "RCTAppDelegate.h"
#endif

#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <React/RCTMountingManager.h>
#import <React/RCTComponentViewRegistry.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTScheduler.h>
#import <react/renderer/uimanager/UIManager.h>
#endif

@implementation UIApplication (RNIHelpers)

- (NSArray<UIScene*> *)getAllScenesWhereForegroundActive API_AVAILABLE(ios(13.0))
{
  NSArray<UIScene*> *connectedScenes =
    [[[UIApplication sharedApplication] connectedScenes] allObjects];
  
  NSMutableArray *scenes = [NSMutableArray new];
  for (UIScene *scene in connectedScenes) {
    if(scene.activationState == UISceneActivationStateForegroundActive){
      [scenes addObject:scene];
    };
  };
  
  return scenes;
}

- (NSArray<UIWindowScene*> *)getAllWindowScenesWhereForegroundActive API_AVAILABLE(ios(13.0))
{
  NSArray<UIScene *> *scenes = [self getAllScenesWhereForegroundActive];
  
  NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(UIScene *scene, NSDictionary *bindings) {
    return [scene isKindOfClass:[UIWindowScene class]];
  }];
  
  return (NSArray<UIWindowScene*> *)[scenes filteredArrayUsingPredicate:filterPredicate];
}

- (NSArray<UIWindow *> *)getAllActiveWindows
{
  if (@available(iOS 13, *)) {
    NSArray<UIWindowScene *> *windowScenes = [self getAllWindowScenesWhereForegroundActive];
    
    NSMutableArray<UIWindow *> *windows = [NSMutableArray new];
    for (UIWindowScene *windowScene in windowScenes) {
      [windows addObjectsFromArray:windowScene.windows];
    };
    
    return windows;
  };
  
  NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];
  NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(UIWindow *window, NSDictionary *bindings) {
    return ![window isHidden];
  }];
  
  return [windows filteredArrayUsingPredicate:filterPredicate];
}

- (NSArray<UIWindow *> *)getAllActiveKeyWindows
{
  NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(UIWindow *window, NSDictionary *bindings) {
    return [window isKeyWindow];
  }];
  
  return [[self getAllActiveWindows] filteredArrayUsingPredicate:filterPredicate];
}

// MARK: React-Native Related
// --------------------------

- (RCTAppDelegate *)reactAppDelegate
{
  id<UIApplicationDelegate> appDelegate =
    [[UIApplication sharedApplication] delegate];
  
  #ifdef USE_RCT_APP_DELEGATE
  if(![appDelegate isKindOfClass:[RCTAppDelegate class]]){
    return nil;
  };
  
  return (RCTAppDelegate *) appDelegate;
  #else
  NSString *appDelegateClassName = NSStringFromClass([appDelegate class]);
  if([appDelegateClassName isEqualToString:@"RCTAppDelegate"]){
    return (RCTAppDelegate *)appDelegate;
  };
  #endif
  
  return nil;
}

- (RCTSurfacePresenterBridgeAdapter *)reactBridgeAdapter
{
  #ifdef USE_RCT_APP_DELEGATE
  RCTAppDelegate *reactAppDelegate = [self reactAppDelegate];
  
  if(reactAppDelegate == nil){
    return [[UIApplication sharedApplication] reactBridgeAdapter];
  };
  
  return [reactAppDelegate bridgeAdapter];
  #else
  
  return [[UIApplication sharedApplication] reactBridgeAdapter];
  #endif
}

- (RCTRootViewFactory *)reactRootViewFactory
{
  return nil;
}

- (RCTSurfacePresenter *) reactSurfacePresenter
{
  RCTSurfacePresenterBridgeAdapter *reactBridgeAdapter = [self reactBridgeAdapter];
  
  if(reactBridgeAdapter == nil){
    return nil;
  };
  
  return [reactBridgeAdapter surfacePresenter];
}

- (RCTMountingManager *)reactMountingManager
{
  RCTSurfacePresenter *reactSurfacePresenter = [self reactSurfacePresenter];
  
  if(reactSurfacePresenter == nil){
    return nil;
  };
  
  return [reactSurfacePresenter mountingManager];
}

- (RCTComponentViewRegistry *)reactComponentViewRegistry
{
  RCTMountingManager *reactMountingManager = [self reactMountingManager];
  
  if(reactMountingManager == nil){
    return nil;
  };
  
  return [reactMountingManager componentViewRegistry];
}

- (RCTScheduler *)reactScheduler
{
  RCTSurfacePresenter *reactSurfacePresenter = [self reactSurfacePresenter];
  if(reactSurfacePresenter == nil){
    return nil;
  };
  
  return [reactSurfacePresenter scheduler];
}

#if RCT_NEW_ARCH_ENABLED && __cplusplus
/// Note - Prefer to use:
/// ```
/// RCTScheduler *reactScheduler = [self reactScheduler];
/// std::shared_ptr<facebook::react::UIManager> = *uiManager [reactScheduler uiManager];
///
/// ```
- (facebook::react::UIManager *)reactUIManager
{
  RCTScheduler *reactScheduler = [self reactScheduler];
  if(reactScheduler == nil){
    return nil;
  };
  
  return [reactScheduler uiManager].get();
}
#endif
@end

