//
//  RNIBaseView.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import <UIKit/UIKit.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#endif

@protocol RNIViewLifecycleEventsNotifying;
@protocol RNIViewLifecycleEventsNotifiable;

@class RNILayoutMetrics;

// Interface visible in Swift
@interface RNIBaseView:
#ifdef RCT_NEW_ARCH_ENABLED
  RCTViewComponentView<RNIViewLifecycleEventsNotifying>
#else // RCT_NEW_ARCH_ENABLED
   RCTView<RNIViewLifecycleEventsNotifying>
#endif // paper

@property (nonatomic, strong, nullable) NSObject<RNIViewLifecycleEventsNotifiable> *lifecycleEventDelegate;
@property (nonatomic, strong, nullable) RNILayoutMetrics *cachedLayoutMetrics;

- (nonnull Class) viewDelegateClass;

- (void)setSize:(CGSize)size;

@end
