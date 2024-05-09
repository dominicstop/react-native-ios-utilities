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

#if __cplusplus
- (nullable RCTAppDelegate * )reactAppDelegate;

- (nullable RCTSurfacePresenterBridgeAdapter *)reactBridgeAdapter;

- (nullable RCTRootViewFactory *)reactRootViewFactory;

- (nullable RCTSurfacePresenter *) reactSurfacePresenter;

- (nullable RCTMountingManager *)reactMountingManager;

- (nullable RCTComponentViewRegistry *)reactComponentViewRegistry;

- (nullable RCTScheduler *)reactScheduler;

- (nullable facebook::react::UIManager *)reactUIManager;
#endif

@end
