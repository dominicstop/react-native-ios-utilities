//
//  RNIBaseView.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import <UIKit/UIKit.h>
#import "RNIRegistrableView.h"
#import "RNIViewCommandRequestHandling.h"
#import "RNIContentViewParentDelegate.h"

#if RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#import <React/RCTInvalidating.h>
#endif

// MARK: - Forward Declarations
// ----------------------------

@protocol RNIContentViewParentDelegate;
@protocol RNIContentViewDelegate;

@class RNILayoutMetrics;
@class RNIBaseViewEventBroadcaster;

#if RCT_NEW_ARCH_ENABLED
@class RNIBaseViewStateSwift;
#else
@class RCTBridge;
@class RCTShadowView;

@class RNIBaseViewPaperEventHandler;
@class RNIBaseViewPaperPropHandler;
#endif

typedef NS_ENUM(NSInteger, RNIPositionType);

// MARK: - RNIBaseView
// -------------------

@interface RNIBaseView:
#if  RCT_NEW_ARCH_ENABLED
  RCTViewComponentView<
#else
  RCTView<
#endif
    RNIContentViewParentDelegate,
    RNIRegistrableView,
    RNIViewCommandRequestHandling>

// MARK: - Properties - RNIContentViewParentDelegate
// -------------------------------------------------

@property (nonatomic, strong, nonnull) NSMapTable *reactSubviewRegistry;

#if !RCT_NEW_ARCH_ENABLED
@property (nonatomic, strong, nullable) UIView *contentView;
#endif

@property (nonatomic, strong, nullable) UIView<RNIContentViewDelegate> *contentDelegate;

@property (nonatomic, strong, nullable) RNILayoutMetrics *cachedLayoutMetrics;

@property (nonatomic, strong, nonnull) NSNumber *recycleCount;

@property (nonatomic, strong, nonnull) RNIBaseViewEventBroadcaster *eventBroadcaster;

- (nonnull NSDictionary *)rawProps;

// MARK: - Properties - RNIContentViewParentDelegate (Paper Only)
// --------------------------------------------------------------

#if !RCT_NEW_ARCH_ENABLED
@property (nonatomic, weak, nullable) RCTShadowView *cachedShadowView;
#endif

// MARK: - Properties (Paper Only)
// -------------------------------

#if !RCT_NEW_ARCH_ENABLED
@property (nonatomic, weak, nullable) RCTBridge *bridge;

@property (nonatomic, strong, nonnull) RNIBaseViewPaperEventHandler *reactEventHandler;

@property (nonatomic, strong, nonnull) RNIBaseViewPaperPropHandler *reactPropHandler;
#endif

// MARK: - Init
// ------------

#if RCT_NEW_ARCH_ENABLED
- (nonnull instancetype)initWithFrame:(CGRect)frame;
#else
- (nonnull instancetype)initWithBridge:(nonnull RCTBridge *)bridge;
#endif

- (void)initCommon NS_REQUIRES_SUPER;

// MARK: - View Lifecycle (Fabric + Paper)
// ---------------------------------------

- (void)willMoveToWindow:(nullable UIWindow *)newWindow NS_REQUIRES_SUPER;

- (void)didMoveToWindow NS_REQUIRES_SUPER;

- (void)willMoveToSuperview:(nullable UIView *)newSuperview NS_REQUIRES_SUPER;

- (void)didMoveToSuperview NS_REQUIRES_SUPER;

- (void)layoutSubviews NS_REQUIRES_SUPER;

- (void)removeFromSuperview NS_REQUIRES_SUPER;

- (void)didAddSubview:(nonnull UIView *)subview NS_REQUIRES_SUPER;

- (void)willRemoveSubview:(nonnull UIView *)subview NS_REQUIRES_SUPER;

// MARK: - Methods (Paper-Only)
// ----------------------------

#if !RCT_NEW_ARCH_ENABLED
- (void)notifyOnPaperSetProp:(nonnull NSString *)propName
                   withValue:(nullable id)propValue;
#endif

// MARK: - RNIContentViewParentDelegate Commands
// ---------------------------------------------

- (void)setSize:(CGSize)size;

- (void)dispatchViewEventForEventName:(nonnull NSString *)eventName
                          withPayload:(nonnull NSDictionary *)eventPayload NS_SWIFT_NAME(dispatchViewEvent(forEventName:withPayload:));

- (void)attachReactTouchHandler;

- (void)detachReactTouchHandler;

- (void)reAttachCotentDelegate;

#if RCT_NEW_ARCH_ENABLED
- (void)setPadding:(UIEdgeInsets)padding;

- (void)setPositionType:(RNIPositionType)positionType;

- (void)requestToUpdateState:(nonnull RNIBaseViewStateSwift *)stateFromSwift;
#endif

// MARK: - RCTInvalidating (Paper Only)
// ------------------------------------

#if !RCT_NEW_ARCH_ENABLED
- (void)invalidate NS_REQUIRES_SUPER;
#endif

// MARK: - Class Members
// ---------------------

+ (nonnull Class<RNIContentViewDelegate>)viewDelegateClass;

+ (BOOL)doesSupportBaseEventOnViewWillRecycle;

@end
