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

@protocol RNIContentViewParentDelegate;
@protocol RNIContentViewDelegate;

@class RCTBridge;
@class RNILayoutMetrics;

typedef NS_ENUM(NSInteger, RNIPositionType);

// MARK: - RNIBaseView
// -------------------

@interface RNIBaseView:
#ifdef RCT_NEW_ARCH_ENABLED
  RCTViewComponentView<RNIContentViewParentDelegate>
#else
  RCTView<RNIContentViewParentDelegate>
#endif

// MARK: - Properties
// ------------------

#if !RCT_NEW_ARCH_ENABLED
@property (nonatomic, strong, nullable) UIView *contentView;

@property (nonatomic, weak, nullable) RCTBridge *bridge;
#endif

@property (nonatomic, strong, nullable) NSObject<RNIContentViewDelegate> *contentDelegate;

@property (nonatomic, strong, nullable) RNILayoutMetrics *cachedLayoutMetrics;

// MARK: - Init
// ------------

#if RCT_NEW_ARCH_ENABLED
- (nonnull instancetype)initWithFrame:(nonnull CGRect)frame;
#else
- (nonnull instancetype)initWithBridge:(nonnull RCTBridge *)bridge;
#endif

- (void) initCommon NS_REQUIRES_SUPER;

// MARK: - Methods
// ---------------

- (nonnull Class) viewDelegateClass;

- (void)setSize:(CGSize)size;

- (void)setPadding:(UIEdgeInsets)padding;

- (void)setPositionType:(RNIPositionType)positionType;

@end
