//
//  RNIDummyTestView.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//

//#import <React/RCTComponent.h>

#import <react-native-ios-utilities/RNIBaseView.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#endif

@protocol RNIViewLifecycleEventsNotifying;
@protocol RNIViewLifecycleEventsNotifiable;

@class RCTBridge;

#if RCT_NEW_ARCH_ENABLED
namespace react = facebook::react;
#endif // RCT_NEW_ARCH_ENABLED

@interface RNIDummyTestView : RNIBaseView

// MARK: - Init
// ------------

#if RCT_NEW_ARCH_ENABLED
- (instancetype)initWithFrame:(CGRect)frame;
#else
- (instancetype)initWithBridge:(RCTBridge *)bridge;
#endif

@end
