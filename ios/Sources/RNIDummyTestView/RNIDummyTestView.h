//
//  RNIDummyTestView.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//

//#import <React/RCTComponent.h>

#import "RNIBaseView.h"

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#endif

@protocol RNIContentViewParentDelegate;
@protocol RNIContentViewDelegate;

@class RCTBridge;

#if RCT_NEW_ARCH_ENABLED
namespace react = facebook::react;
#endif

@interface RNIDummyTestView : RNIBaseView

@end
