//
//  RNIBaseView.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import <UIKit/UIKit.h>

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#endif

// MARK: - Forward Declarations
// ----------------------------

@protocol RNIViewLifecycleEventsNotifying;
@protocol RNIContentViewDelegate;

@class RCTBridge;
@class RNILayoutMetrics;

typedef NS_ENUM(NSInteger, RNIPositionType);

// MARK: - RNIBaseView
// -------------------

@interface RNIBaseView:
#ifdef RCT_NEW_ARCH_ENABLED
  RCTViewComponentView<RNIViewLifecycleEventsNotifying>
#else
  RCTView<RNIViewLifecycleEventsNotifying>
#endif

// MARK: - Properties
// ------------------

#if !RCT_NEW_ARCH_ENABLED
@property (nonatomic, weak) RCTBridge *bridge;
#endif

@property (nonatomic, strong, nullable) NSObject<RNIContentViewDelegate> *contentDelegate;

@property (nonatomic, strong, nullable) RNILayoutMetrics *cachedLayoutMetrics;

// MARK: - Init
// ------------

#if RCT_NEW_ARCH_ENABLED
- (nonnull instancetype)initWithFrame:(CGRect)frame;
#else
- (nonnull instancetype)initWithBridge:(RCTBridge *)bridge;
#endif

- (void) initCommon;

// MARK: - Methods
// ---------------

- (nonnull Class) viewDelegateClass;

- (void)setSize:(CGSize)size;

- (void)setPadding:(UIEdgeInsets)padding;

- (void)setPositionType:(RNIPositionType)positionType;

@end
