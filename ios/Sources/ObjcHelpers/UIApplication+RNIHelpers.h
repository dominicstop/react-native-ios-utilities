//
//  UIApplication+RNIHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <UIKit/UIKit.h>

@class RCTAppDelegate;
@class RCTSurfacePresenterBridgeAdapter;
@class RCTRootViewFactory;
@class RCTSurfacePresenter;
@class RCTMountingManager;
@class RCTComponentViewRegistry;
@class RCTScheduler;

#if __cplusplus
namespace facebook::react {
  class UIManager;
}
#endif

@interface UIApplication (RNIHelpers)

- (nonnull NSArray<UIScene*> *)getAllScenesWhereForegroundActive API_AVAILABLE(ios(13.0));

- (nonnull NSArray<UIWindowScene*> *)getAllWindowScenesWhereForegroundActive API_AVAILABLE(ios(13.0));

- (nonnull NSArray<UIWindow *> *)getAllActiveWindows;

- (nonnull NSArray<UIWindow *> *)getAllActiveKeyWindows;

// MARK: React-Native Related
// --------------------------

- (nullable RCTAppDelegate * )reactAppDelegate;

- (nullable RCTSurfacePresenterBridgeAdapter *)reactBridgeAdapter;

- (nullable RCTRootViewFactory *)reactRootViewFactory;

- (nullable RCTSurfacePresenter *) reactSurfacePresenter;

- (nullable RCTMountingManager *)reactMountingManager;

- (nullable RCTComponentViewRegistry *)reactComponentViewRegistry;

- (nullable RCTScheduler *)reactScheduler;

#if RCT_NEW_ARCH_ENABLED && __cplusplus
- (nullable facebook::react::UIManager *)reactUIManager;
#endif

@end
