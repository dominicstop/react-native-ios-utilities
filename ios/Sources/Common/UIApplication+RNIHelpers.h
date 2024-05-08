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

@interface UIApplication (RNIHelpers)

- (RCTAppDelegate *)reactAppDelegate;

- (RCTSurfacePresenterBridgeAdapter *)reactBridgeAdapter;

- (RCTRootViewFactory *)reactRootViewFactory;

- (RCTSurfacePresenter *) reactSurfacePresenter;

- (RCTMountingManager *)reactMountingManager;

- (RCTComponentViewRegistry *)componentViewRegistry;

@end
