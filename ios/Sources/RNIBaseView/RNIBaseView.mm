//
//  RNIBaseView.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import "RNIBaseView.h"
#import "../../Swift.h"

#import <objc/runtime.h>

#import "RNIUtilitiesModule.h"
#import "RNIViewRegistry.h"

#import "RNIContentViewParentDelegate.h"
#import "RNIViewCommandRequestHandling.h"

#import "RNIObjcUtils.h"
#import "UIApplication+RNIHelpers.h"
#import "UIView+RNIHelpers.h"

#ifdef RCT_NEW_ARCH_ENABLED
#include "RNIBaseViewState.h"
#include "RNIBaseViewProps.h"
#include "RNIBaseViewEventEmitter.h"

#import "RCTFabricComponentsPlugins.h"

#import <React/RCTFollyConvert.h>
#import <React/RCTSurfaceTouchHandler.h>

#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/graphics/Float.h>
#include <react/renderer/core/graphicsConversions.h>

#if DEBUG
#import <React/RCTReloadCommand.h>
#endif

#else
#import "RNIBaseViewPaperEventHandler.h"
#import "RNIBaseViewPaperPropHandler.h"

#import "RNIBaseViewPaperPropHolder.h"
#import "UIView+RNIPaperHelpers.h"

#import <React/UIView+React.h>
#import <React/RCTShadowView.h>
#import <React/RCTBridge.h>
#import <React/RCTBridge+Private.h>
#import <React/RCTUIManager.h>
#import <React/RCTTouchHandler.h>

#if DEBUG
#import <React/RCTBridgeConstants.h>
#endif
#endif

#if __cplusplus
using namespace facebook;
using namespace react;
#endif

static BOOL SHOULD_LOG = NO;

@interface RNIBaseView () <RNIContentViewParentDelegate>
@end

@implementation RNIBaseView {
  BOOL _didNotifyForInit;
  BOOL _didAttachContentDelegate;
  BOOL _didDispatchEventOnDidSetViewID;
  
#ifdef RCT_NEW_ARCH_ENABLED
  UIView *_view;
  RNIBaseViewState::SharedConcreteState _state;
  NSMutableArray<UIView *> *_reactSubviewsShim;
  NSMutableArray<NSDictionary *> *_queuedEvents;
  RCTSurfaceTouchHandler *_touchHandlerFabric;
#else
  CGRect _reactFrame;
  RCTTouchHandler *_touchHandlerPaper;
#endif
}

@synthesize viewID;
@synthesize reactSubviewRegistry;
@synthesize intrinsicContentSizeOverride;

#if RCT_NEW_ARCH_ENABLED
@synthesize reactSubviews;
#endif

// MARK: - Init + Setup
// --------------------

#ifdef RCT_NEW_ARCH_ENABLED
- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const react::RNIBaseViewProps>();
    self->_props = defaultProps;
    
    self->_reactSubviewsShim = [NSMutableArray new];
    self->_queuedEvents = [NSMutableArray new];
    
#if DEBUG
  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(handleOnReloadNotification:)
           name:RCTTriggerReloadCommandNotification
         object:nil];
#endif
    
    [self initCommon];
  };
  
  return self;
}
#else
- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  if (self = [super init]) {
    self.bridge = bridge;
    
    self.reactEventHandler =
      [[RNIBaseViewPaperEventHandler new] initWithParentRef:self];
    
    self.reactPropHandler =
      [[RNIBaseViewPaperPropHandler new] initWithParentRef:self];
    
    RNILog(
      @"%@\n%@ %d\n%@ %@\n%@ %@",
      @"RNIBaseView.layoutSubviews",
      @" - self.reactSubviews count:", (int)[self.reactSubviews count],
      @" - self.cachedShadowView:", self.cachedShadowView,
      @" - self.frame:", NSStringFromCGRect(self.frame)
    );
    
    [self initCommon];
  };
  
  return self;
}

- (void)initPaper
{
#if DEBUG
  [[NSNotificationCenter defaultCenter]
    addObserver:self
       selector:@selector(handleOnBridgeWillReloadNotification:)
           name:RCTBridgeWillReloadNotification
         object:nil];
#endif

  if(self.contentDelegate == nil){
    return;
  };
  
  [self.reactEventHandler createSettersIfNeededForEvents:^(){
    NSMutableArray *events =
      [NSMutableArray arrayWithArray:[self.contentDelegate _getSupportedReactEvents]];
      
    RNILog(
      @"%@\n%@ %@\n%@ %@",
      @"[RNIBaseView initCommon]",
      @" - Class Name:", NSStringFromClass([self class]),
      @" - Supported Events:", events
    );
    
    if([[self class] doesSupportBaseEventOnViewWillRecycle]){
      [events addObject:@"onViewWillRecycle"];
    };

    [events addObject:@"onDidSetViewID"];
    return events;
  }()];
  
  NSDictionary *propTypeMap =
    [self.contentDelegate _getSupportedReactPropsTypeMap];
    
  [self.reactPropHandler setPropTypeMapIfNeeded:propTypeMap];
  
  NSArray *propList = [self.contentDelegate _getSupportedReactProps];
  [self.reactPropHandler createSettersIfNeededForProps:propList];
  
  RNILog(
    @"%@\n%@ %@\n%@ %@",
    @"RNIBaseView.initCommon",
    @" - Class Name:", NSStringFromClass([self class]),
    @" - Supported Props:", propList
  );
}
#endif

-(void)initViewDelegate
{
  [[RNIViewRegistry shared] registerView:self];
  
  Class viewDelegateClass = [[self class] viewDelegateClass];
  if(![viewDelegateClass isSubclassOfClass: [UIView class]]) {
    NSString *errorMessage =
      @"[RNIBaseView %@] Error"
      @" - The class returned by getter `[%@ viewDelegateClass]` (i.e. '%@')"
      @" must be a `UIView` subclass";
    
    NSString *currentSelector = NSStringFromSelector(_cmd);
    NSString *className = NSStringFromClass([self class]);
    NSString *delegateClassName = NSStringFromClass([[self class] viewDelegateClass]);
    
    errorMessage =
      [NSString stringWithFormat: errorMessage, currentSelector, className, delegateClassName];
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:errorMessage
                                 userInfo:nil];
  }
  
  if(![viewDelegateClass conformsToProtocol:@protocol(RNIContentViewDelegate)]) {
    NSString *errorMessage =
      @"[RNIBaseView %@] Error"
      @" - The class returned by getter `[%@ viewDelegateClass]` (i.e. '%@')"
      @" does not conform to protocol: '%@'";
    
    NSString *currentSelector = NSStringFromSelector(_cmd);
    NSString *className = NSStringFromClass([self class]);
    NSString *delegateClassName = NSStringFromClass([[self class] viewDelegateClass]);
    NSString *protocolName = NSStringFromProtocol(@protocol(RNIContentViewDelegate));
    
    errorMessage =
      [NSString stringWithFormat: errorMessage, currentSelector, className, delegateClassName, protocolName];
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:errorMessage
                                 userInfo:nil];
  }
  
  UIView<RNIContentViewDelegate> *viewDelegate = ^id{
    BOOL shouldUseDelegateForInit =
      [viewDelegateClass respondsToSelector:@selector(createInstanceWithSender:frame:)];
      
    if(shouldUseDelegateForInit){
      return [viewDelegateClass createInstanceWithSender:self frame:self.frame];
    };
    
    // deprecated
    BOOL shouldInitDelegateUsingInstanceMaker =
      [viewDelegateClass respondsToSelector:@selector(instanceMakerWithSender:frame:)];
    
    // deprecated
    if(shouldInitDelegateUsingInstanceMaker){
      return [viewDelegateClass instanceMakerWithSender:self frame:self.frame];
    };
    
    BOOL isDelegateSubclassOfUIButton =
      [viewDelegateClass isSubclassOfClass:[UIButton class]];
      
    if(isDelegateSubclassOfUIButton) {
      return [viewDelegateClass new];
    };
    
    return [[viewDelegateClass alloc] initWithFrame:self.frame];
  }();
  
  viewDelegate.parentReactView = self;
  
  self.contentDelegate = viewDelegate;
  self.contentView = viewDelegate;
};

// NOTE: To be overridden + impl. by child class
- (void)initCommon
{
  self.recycleCount = @0;
  self.intrinsicContentSizeOverride = CGSizeZero;
  
  self.eventBroadcaster =
    [[RNIBaseViewEventBroadcaster alloc] initWithParentReactView:self];
    
  self.reactSubviewRegistry =
    [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                          valueOptions:NSMapTableWeakMemory];
  
  [self initViewDelegate];
  [self setupAttachContentDelegate];
  
  [self.eventBroadcaster registerDelegatesFromParentReactView];
  
  #if !RCT_NEW_ARCH_ENABLED
  [self initPaper];
  #endif
  
  if(!self->_didNotifyForInit) {
    self->_didNotifyForInit = YES;
    [self.eventBroadcaster notifyOnInitWithSender:self];
  };
}

- (void)setupAttachContentDelegate
{
  BOOL hasCustomLayoutSetup =
    [self.contentDelegate respondsToSelector:@selector(notifyOnRequestToSetupLayoutWithSender:)];
  
  BOOL shouldNotifyDelegateToSetupConstraints =
       !hasCustomLayoutSetup
    && [self.contentDelegate respondsToSelector:@selector(_notifyOnRequestToSetupConstraintsWithSender:)];
    
  if(shouldNotifyDelegateToSetupConstraints){
     [self.contentDelegate _notifyOnRequestToSetupConstraintsWithSender:self];
     self->_didAttachContentDelegate = YES;
     
  } else if(hasCustomLayoutSetup){
    [self.contentDelegate notifyOnRequestToSetupLayoutWithSender:self];
    self->_didAttachContentDelegate = YES;
  };
}

// MARK: Methods (Paper + Fabric)
// ------------------------------

- (void)_dispatchViewEventOnDidSetViewIDIfNeeded
{
  BOOL shouldDispatchEvent =
#if RCT_NEW_ARCH_ENABLED
       !self->_didDispatchEventOnDidSetViewID
    && self->_eventEmitter != nil;
#else
    !self->_didDispatchEventOnDidSetViewID;
#endif

  if(!shouldDispatchEvent){
    return;
  };

  self->_didDispatchEventOnDidSetViewID = YES;
  NSDictionary *dict = @{
    @"viewID": self.viewID,
    @"reactTag": [self reactNativeTag],
    @"recycleCount": self->_recycleCount,
  };
  
  [self dispatchViewEventForEventName:@"onDidSetViewID"
                          withPayload:dict];
}

- (void)_dispatchEventOnViewWillRecycle
{
  BOOL shouldDispatchEvent =
       [[self class] doesSupportBaseEventOnViewWillRecycle]
#if RCT_NEW_ARCH_ENABLED
    && self->_eventEmitter != nil;
#else
    && self.window != nil;
#endif

  if(!shouldDispatchEvent){
    return;
  };
  
  NSDictionary *dict = @{
    @"recycleCount": self->_recycleCount,
  };
  
  [self dispatchViewEventForEventName:@"onViewWillRecycle"
                          withPayload:dict];
}

#if RCT_NEW_ARCH_ENABLED
- (NSArray<UIView *> *)reactSubviews
{
  return self->_reactSubviewsShim;
}
#endif

- (void)requestToRemoveReactSubview:(UIView *)subview
{
#if RCT_NEW_ARCH_ENABLED
  [self->_reactSubviewsShim removeObject:subview];
  
  NSMutableArray<UIView *> *parentReactSubviews = [self valueForKey:@"_reactSubviews"];
  if(parentReactSubviews != nil){
    [parentReactSubviews removeObject:subview];
  };
#else
  [super removeReactSubview:subview];
#endif
}

-(void)remountChildComponentsToContentDelegate
{
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnMountChildComponentViewWithSender:
                                          childComponentView:
                                                       index:
                                                  superBlock:)];
  if(!shouldNotifyDelegate) return;
  
  id superBlock = ^{
    // no-op
  };
  
  NSArray<UIView *> *reactSubviews = [self reactSubviews];
  
  for (int index = 0; index < reactSubviews.count; index++) {
    UIView *currentView = [reactSubviews objectAtIndex:index];
    
    [self.contentDelegate notifyOnMountChildComponentViewWithSender:self
                                                 childComponentView:currentView
                                                              index:index
                                                         superBlock:superBlock];
  };
}

// MARK: Methods - Fabric-Only
// ---------------------------

#if RCT_NEW_ARCH_ENABLED
- (void)dispatchQueuedViewEventsIfNeeded
{
  BOOL shouldDispatchEvent =
       [self->_queuedEvents count] > 0
    && self->_eventEmitter != nil;
    
  if(!shouldDispatchEvent){
    return;
  };

  for (NSDictionary *_queuedEvent in self->_queuedEvents) {
    NSString *eventName = [_queuedEvent valueForKey:@"eventName"];
    NSDictionary *eventPayload = [_queuedEvent valueForKey:@"eventPayload"];
    
    [self dispatchViewEventForEventName:eventName withPayload:eventPayload];
  };
  
  [self->_queuedEvents removeAllObjects];
}

- (void)_resetContentDelegate
{
  self.contentView = nil;
  self.contentDelegate = nil;
  
  self->_didNotifyForInit = NO;
  self->_didAttachContentDelegate = NO;

  [self.contentView removeFromSuperview];
  [self initViewDelegate];
  
  [self.eventBroadcaster registerDelegatesFromParentReactView];
  [self.eventBroadcaster notifyOnInitWithSender:self];
  
  self->_didNotifyForInit = YES;
}
#else

// MARK: Methods - Paper-Only
// --------------------------

- (void)notifyOnPaperSetProp:(NSString *)propName
                   withValue:(id)propValue;
{
  if(!self.contentDelegate) {
    return;
  };
  
  [self.contentDelegate
    _notifyOnRequestToSetPropWithSender:self
                               propName:propName
                              propValue:propValue];
}

- (void)_getAndSetShadowViewIfNeededWithCompletionHandler:(nullable RNIPaperShadowViewCompletionBlock)completionBlock
{
  if(self.cachedShadowView != nil){
    if(completionBlock != nil){
      completionBlock(self.cachedShadowView);
    };
    return;
  };
    
  [self reactGetShadowViewWithCompletionHandler:^(RCTShadowView *shadowView) {
    self.cachedShadowView = shadowView;
    if(shadowView == nil){
      return;
    };
    
    if(completionBlock != nil){
      completionBlock(shadowView);
    };
  }];
}

- (void)_notifyDelegateForLayoutMetricsUpdate
{
  if(self.cachedShadowView == nil){
    return;
  };
  
  RNILayoutMetrics *oldLayoutMetrics = self.cachedLayoutMetrics == nil
    ? [RNILayoutMetrics new]
    : self.cachedLayoutMetrics;
  
  RNILayoutMetrics *newLayoutMetrics = [RNIObjcUtils
      convertToRNILayoutMetricsForPaperLayoutMetrics:self.cachedShadowView.layoutMetrics
                                      withShadowView:self.cachedShadowView];
  
  self.cachedLayoutMetrics = newLayoutMetrics;
  [self.eventBroadcaster notifyOnUpdateLayoutMetricsWithSender:self
                                              oldLayoutMetrics:oldLayoutMetrics
                                              newLayoutMetrics:newLayoutMetrics];
                                              
  BOOL didChangeSize =
       oldLayoutMetrics.frame.size.height != newLayoutMetrics.frame.size.height
    || oldLayoutMetrics.frame.size.width  != newLayoutMetrics.frame.size.width;
    
  if(didChangeSize) {
    [self invalidateIntrinsicContentSize];
  };
}
#endif

// MARK: - RNIContentViewParentDelegate Getters
// --------------------------------------------

- (NSDictionary *)rawProps
{
#if RCT_NEW_ARCH_ENABLED
  const auto &propsRaw =
    *std::static_pointer_cast<RNIBaseViewProps const>(self->_props);
  
  NSDictionary *propsDict =
    [RNIObjcUtils convertToDictForFollyDynamicMap:propsRaw.propsMap];
    
  return propsDict;
#else
  return [self.reactPropHandler.propHolder.propsMap copy];
#endif
}

// MARK: - RNIContentViewParentDelegate Commands (Fabric + Paper)
// --------------------------------------------------------------

- (void)setSize:(CGSize)size
{
#if RCT_NEW_ARCH_ENABLED
  if(self->_state == nullptr) {
    return;
  };
    
  auto newSize = [RNIObjcUtils convertToReactSizeForSize:size];
        
  auto stateCallback = [=](
    const RNIBaseViewState::ConcreteState::Data& oldData
  ) -> StateData::Shared {
  
    RNIBaseViewState newData = RNIBaseViewState(oldData);
    newData.frameSize = newSize;
    newData.shouldSetSize = true;
    
    return std::make_shared<RNIBaseViewState>(newData);
  };
  
  self->_state->updateState(stateCallback);
  [self->_view setNeedsLayout];
#else
  if(self.bridge == nil){
    return;
  };
  
  RCTUIManager *uiManager = self.bridge.uiManager;
  if(uiManager == nil){
    return;
  };
  
  [uiManager setSize:size forView:self];
  [self setNeedsLayout];
#endif
};

- (void)dispatchViewEventForEventName:(NSString *)eventName
                          withPayload:(NSDictionary *)eventPayload
{
#if RCT_NEW_ARCH_ENABLED
  if (self->_eventEmitter == nullptr){
    NSDictionary *_queuedEvent = @{
      @"eventName": eventName,
      @"eventPayload": eventPayload,
    };
    
    [self->_queuedEvents addObject:_queuedEvent];
    return;
  };
 
  auto eventEmitter =
    std::dynamic_pointer_cast<const react::RNIBaseViewEventEmitter>(_eventEmitter);
  
  auto eventNameCxxString = [RNIObjcUtils convertToCxxStringForObjcString:eventName];
  auto eventPayloadDynamic = react::convertIdToFollyDynamic(eventPayload);
  
  eventEmitter->dispatchEvent(eventNameCxxString, eventPayloadDynamic);
#else
  [self.reactEventHandler invokeEventBlockForEventName:eventName
                                           withPayload:eventPayload];
#endif
}

- (void)attachReactTouchHandler
{
  UIGestureRecognizer *reactGestureRecognizer;
#if RCT_NEW_ARCH_ENABLED
  RCTSurfaceTouchHandler *touchHandlerFabric = [RCTSurfaceTouchHandler new];
  self->_touchHandlerFabric = touchHandlerFabric;
  reactGestureRecognizer = reactGestureRecognizer;
  
  [touchHandlerFabric attachToView:self];
#else
  RCTBridge *bridge = [RCTBridge currentBridge];
  RCTTouchHandler *touchHandlerPaper = [[RCTTouchHandler alloc] initWithBridge:bridge];
  self->_touchHandlerPaper = touchHandlerPaper;
  reactGestureRecognizer = touchHandlerPaper;
  
  [touchHandlerPaper attachToView:self];
#endif
}

- (void)detachReactTouchHandler
{
#if RCT_NEW_ARCH_ENABLED
  if(self->_touchHandlerFabric == nil){
    return;
  };
  
  [self->_touchHandlerFabric detachFromView:self];
  self->_touchHandlerFabric = nil;
#else
  if(self->_touchHandlerPaper == nil){
    return;
  };
  
  [self->_touchHandlerPaper detachFromView:self];
  self->_touchHandlerPaper = nil;
#endif
}

- (void)reAttachCotentDelegate
{
  if(self.contentDelegate == nil){
    return;
  };
  
  [self.contentDelegate removeFromSuperview];
  [self setupAttachContentDelegate];
}

// MARK: - RNIContentViewParentDelegate Commands (Fabric Only)
// -----------------------------------------------------------

#if RCT_NEW_ARCH_ENABLED
- (void)setPadding:(UIEdgeInsets)padding
{
  if(self->_state == nullptr) {
    return;
  };
    
  auto newPadding =
    [RNIObjcUtils convertToReactRectangleEdgesForEdgeInsets:padding];
        
  auto stateCallback = [=](
    const RNIBaseViewState::ConcreteState::Data& oldData
  ) -> StateData::Shared {
    
    RNIBaseViewState newData = RNIBaseViewState(oldData);
    newData.padding = newPadding;
    newData.shouldSetPadding = true;
    
    return std::make_shared<RNIBaseViewState>(newData);
  };
  
  self->_state->updateState(stateCallback);
  [self->_view setNeedsLayout];
}

- (void)setPositionType:(RNIPositionType)positionType
{
  auto newPositionType =
    [RNIObjcUtils convertToYGPostionTypeForRNIPostionType:positionType];
        
  auto stateCallback = [=](
    const RNIBaseViewState::ConcreteState::Data& oldData
  ) -> StateData::Shared {
  
    RNIBaseViewState newData = RNIBaseViewState(oldData);
    newData.positionType = newPositionType;
    newData.shouldSetPositionType = true;
    
    return std::make_shared<RNIBaseViewState>(newData);
  };
  
  self->_state->updateState(stateCallback);
  [self->_view setNeedsLayout];
};

- (void)requestToUpdateState:(RNIBaseViewStateSwift *)stateFromSwift
{
  RNIBaseViewState prevState = self->_state->getData();
  RNIBaseViewState newState = RNIBaseViewState(prevState);
  
  BOOL doesNeedLayout = false;
  
  if(stateFromSwift.shouldSetSize != nil) {
    newState.shouldSetSize = stateFromSwift.shouldSetSize.boolValue;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.frameSize != nil){
    CGSize frameSizeObjc = stateFromSwift.frameSize.CGSizeValue;
    
    auto frameSizeReact =
      [RNIObjcUtils convertToReactSizeForSize:frameSizeObjc];
      
    newState.frameSize = frameSizeReact;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.shouldSetPadding != nil) {
    newState.shouldSetPadding = stateFromSwift.shouldSetPadding.boolValue;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.padding != nil){
    UIEdgeInsets paddingObjc = stateFromSwift.frameSize.UIEdgeInsetsValue;
    
    auto paddingReact =
      [RNIObjcUtils convertToReactRectangleEdgesForEdgeInsets:paddingObjc];
      
    newState.padding = paddingReact;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.shouldSetPositionType != nil) {
    newState.shouldSetPositionType =
      stateFromSwift.shouldSetPositionType.boolValue;
      
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.positionType != nil){
    RNIPositionType positionTypeObjc =
      (RNIPositionType)stateFromSwift.positionType.intValue;
      
    auto positionTypeReact =
      [RNIObjcUtils convertToYGPostionTypeForRNIPostionType:positionTypeObjc];
      
    newState.positionType = positionTypeReact;
  };

  if(stateFromSwift.minSize) {
    CGSize minSizeObjc = stateFromSwift.minSize.CGSizeValue;
    
    auto minSizeReact =
      [RNIObjcUtils convertToReactSizeForSize:minSizeObjc];
      
    newState.minSize = minSizeReact;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.shouldSetMinHeight) {
    newState.shouldSetMinHeight = stateFromSwift.shouldSetMinHeight.boolValue;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.shouldSetMinWidth) {
    newState.shouldSetMinWidth = stateFromSwift.shouldSetMinWidth.boolValue;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.maxSize) {
    CGSize maxSizeObjc = stateFromSwift.maxSize.CGSizeValue;
    
    auto maxSizeReact =
      [RNIObjcUtils convertToReactSizeForSize:maxSizeObjc];
      
    newState.maxSize = maxSizeReact;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.shouldSetMaxWidth) {
    newState.shouldSetMaxWidth = stateFromSwift.shouldSetMaxWidth.boolValue;
    doesNeedLayout = YES;
  };
  
  if(stateFromSwift.shouldSetMaxHeight) {
    newState.shouldSetMaxHeight = stateFromSwift.shouldSetMaxHeight.boolValue;
    doesNeedLayout = YES;
  };
  
  self->_state->updateState(std::move(newState));
  
  if(doesNeedLayout){
    [self->_view setNeedsLayout];
  };
};
#endif

// MARK: - View Lifecycle (Fabric + Paper)
// ---------------------------------------

- (void)willMoveToWindow:(UIWindow *)newWindow
{
#if RCT_NEW_ARCH_ENABLED
  BOOL shouldAttachContentDelegate =
       newWindow != nil
    && self->_contentDelegate != nil
    && !self->_didAttachContentDelegate;
    
  if(shouldAttachContentDelegate){
    [self setupAttachContentDelegate];
  };
#else
  [self _getAndSetShadowViewIfNeededWithCompletionHandler:nil];
#endif
  
  [[RNIViewRegistry shared] registerViewUsingReactTagForView:self];

  [self.eventBroadcaster notifyOnViewWillMoveToWindowWithSender:self
                                                      newWindow:newWindow];
}

- (void)didMoveToWindow
{
  #if !RCT_NEW_ARCH_ENABLED
  [self reactGetShadowViewWithCompletionHandler:^(RCTShadowView *shadowView) {
    self.cachedShadowView = shadowView;
    if(shadowView == nil){
      return;
    };
  }];
  #endif
  
  [self.eventBroadcaster notifyOnViewDidMoveToWindowWithSender:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
  [self.eventBroadcaster notifyOnViewWillMoveToSuperviewWithSender:self
                                                      newSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
  [self.eventBroadcaster notifyOnViewDidMoveToSuperviewWithSender:self];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  #if !RCT_NEW_ARCH_ENABLED
  __weak id _self = self;
  [self _getAndSetShadowViewIfNeededWithCompletionHandler:^(RCTShadowView *shadowView) {
    [_self _notifyDelegateForLayoutMetricsUpdate];
  }];
  
  RNILog(
    @"%@\n%@ %d\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseView.layoutSubviews",
    @" - self.reactSubviews count:", (int)[self.reactSubviews count],
    @" - self.cachedShadowView:", self.cachedShadowView,
    @" - self.frame:", NSStringFromCGRect(self.frame),
    @" - self.cachedLayoutMetrics:", self.cachedLayoutMetrics
  );
  #endif
  
  [self.eventBroadcaster notifyOnViewLayoutSubviewsWithSender:self];
}

- (void)removeFromSuperview
{
  [super removeFromSuperview];
  [self.eventBroadcaster notifyOnViewRemovedFromSuperviewWithSender:self];
}

- (void)didAddSubview:(UIView *)subview
{
  [self.eventBroadcaster notifyOnViewDidAddSubviewWithSender:self
                                                     subview:subview];
};

- (void)willRemoveSubview:(UIView *)subview
{
  [self.eventBroadcaster notifyOnViewWillRemoveSubviewWithSender:self
                                                         subview:subview];
};

- (CGSize)intrinsicContentSize
{
  return self.intrinsicContentSizeOverride;
};

// MARK: - React Lifecycle (Fabric Only)
// -------------------------------------

#ifdef RCT_NEW_ARCH_ENABLED
-(void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                         index:(NSInteger)index
{
  [self->_reactSubviewsShim insertObject:childComponentView atIndex:index];
  
  [self.reactSubviewRegistry setObject:childComponentView
                                forKey:childComponentView.reactNativeTag];
  
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnMountChildComponentViewWithSender:
                                          childComponentView:
                                                       index:
                                                  superBlock:)];
  
  if(shouldNotifyDelegate){
    id superBlock = ^{
      [super mountChildComponentView:childComponentView index:index];
    };
    
    [self.contentDelegate notifyOnMountChildComponentViewWithSender:self
                                                 childComponentView:childComponentView
                                                              index:index
                                                         superBlock:superBlock];
  } else {
    [super mountChildComponentView:childComponentView index:index];
  };
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                            index:(NSInteger)index
{
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnMountChildComponentViewWithSender:
                                          childComponentView:
                                                       index:
                                                  superBlock:)];
  
  if(shouldNotifyDelegate){
    id superBlock = ^{
      [super unmountChildComponentView:childComponentView index:index];
    };
    [self.contentDelegate notifyOnUnmountChildComponentViewWithSender:self
                                                   childComponentView:childComponentView
                                                                index:index
                                                           superBlock:superBlock];
  } else {
    [super unmountChildComponentView:childComponentView index:index];
  };
  
  [self->_reactSubviewsShim removeObject:childComponentView];
}

- (void)updateEventEmitter:(const facebook::react::EventEmitter::Shared &)eventEmitter
{
  [super updateEventEmitter:eventEmitter];
  [self _dispatchViewEventOnDidSetViewIDIfNeeded];
  [self dispatchQueuedViewEventsIfNeeded];
}

- (void)updateLayoutMetrics:(const LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const LayoutMetrics &)oldLayoutMetrics
{
  RNILayoutMetrics *layoutMetricsNew = [RNIObjcUtils convertToRNILayoutMetricsForFabricLayoutMetrics:layoutMetrics];
  self.cachedLayoutMetrics = layoutMetricsNew;

  RNILayoutMetrics *layoutMetricsOld = [RNIObjcUtils convertToRNILayoutMetricsForFabricLayoutMetrics:oldLayoutMetrics];
    
  [self.eventBroadcaster notifyOnUpdateLayoutMetricsWithSender:self
                                              oldLayoutMetrics:layoutMetricsOld
                                              newLayoutMetrics:layoutMetricsNew];
  
  BOOL didChangeSize =
    oldLayoutMetrics.frame.size != layoutMetrics.frame.size;
    
  if(didChangeSize) {
    [self invalidateIntrinsicContentSize];
  };
  
  [super updateLayoutMetrics:layoutMetrics oldLayoutMetrics:oldLayoutMetrics];
}

- (void)updateProps:(Props::Shared const &)props
           oldProps:(Props::Shared const &)oldProps
{
  const auto &basePropsOld = *std::static_pointer_cast<RNIBaseViewProps const>(_props);
  const auto &basePropsNew = *std::static_pointer_cast<RNIBaseViewProps const>(props);

  NSDictionary *dictPropsOld = ^{
    if(oldProps == nullptr){
      return @{};
    };
    
    return [RNIObjcUtils convertToDictForFollyDynamicMap:basePropsOld.propsMap];
  }();
  
  NSDictionary *dictPropsNew =
    [RNIObjcUtils convertToDictForFollyDynamicMap:basePropsNew.propsMap];
    
  self.contentDelegate.reactProps = [dictPropsNew copy];
    
  [self.contentDelegate _notifyOnRequestToSetPropsWithSender:self
                                                      props:dictPropsNew];
  
  [self.eventBroadcaster notifyOnUpdatePropsWithSender:self
                                              oldProps:dictPropsOld
                                              newProps:dictPropsNew];
  
  [self.eventBroadcaster notifyDidSetPropsWithSender:self];
  [super updateProps:props oldProps:oldProps];
}

- (void)updateState:(const State::Shared &)state
           oldState:(const State::Shared &)oldState
{
  auto newState =
    std::static_pointer_cast<const RNIBaseViewState::ConcreteState>(state);
    
  if (self->_state == nil){
    self->_state = newState;
  };
  
  RNIBaseViewState nextState = self->_state->getData();
  
  auto newStateData = newState->getData();
  auto newStateDynamic = newStateData.getDynamic();
  
  NSDictionary *newStateDict =
    [RNIObjcUtils convertFollyDynamicToId:&newStateDynamic];
    
  auto _oldState =
    std::static_pointer_cast<const RNIBaseViewState::ConcreteState>(oldState);
  
  std::optional<RNIBaseViewState> oldStateData = std::nullopt;
  
  if(_oldState != nullptr){
    oldStateData = _oldState->getData();
  };
  
  std::optional<folly::dynamic> oldStateDynamic = oldStateData.has_value()
    ? std::make_optional(oldStateData.value().getDynamic())
    : std::nullopt;
  

  NSMutableDictionary *oldStateDict = oldStateDynamic.has_value()
    ? [RNIObjcUtils convertFollyDynamicToId:&newStateDynamic]
    : nil;
    

  [self.eventBroadcaster notifyOnUpdateStateWithSender:self
                                              oldState:oldStateDict
                                              newState:newStateDict];
    
  [super updateState:state oldState:oldState];
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask
{
  RNIComponentViewUpdateMask *swiftMask =
      [[RNIComponentViewUpdateMask new] initWithRawValue:updateMask];
  
  [self.eventBroadcaster notifyOnFinalizeUpdatesWithSender:self
                                             updateMaskRaw:updateMask
                                                updateMask:swiftMask];
                                                  
  [super finalizeUpdates:updateMask];
}

-(void) prepareForRecycle
{
  // reset values
  self->_didDispatchEventOnDidSetViewID = NO;
  self.intrinsicContentSizeOverride = CGSizeZero;
  
  // increment `recycleCount`
  self.recycleCount =
    [NSNumber numberWithInt:[self.recycleCount intValue] + 1];
    
  [self _dispatchEventOnViewWillRecycle];
  [self.eventBroadcaster notifyOnPrepareForReuseWithSender:self];
  [self.eventBroadcaster notifyOnRequestForCleanupWithSender:self];
  
  BOOL shouldAskDelegateIfShouldRecycle =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(shouldRecycleContentDelegateWithSender:)];
  
  BOOL shouldRecycleContentDelegate = YES;
  if(shouldAskDelegateIfShouldRecycle){
    shouldRecycleContentDelegate =
      [self.contentDelegate shouldRecycleContentDelegateWithSender:self];
  };
  
  if(!shouldRecycleContentDelegate){
    [self _resetContentDelegate];
  };
  
  self->_state.reset();

  [self->_reactSubviewsShim removeAllObjects];
  [self->_queuedEvents removeAllObjects];
  
  [self detachReactTouchHandler];
  [self.reactSubviewRegistry removeAllObjects];
  
  [super prepareForRecycle];
}

#if DEBUG
- (void)handleOnReloadNotification:(NSNotification *)notification
{
  [self.eventBroadcaster
    notifyOnReloadCommandInvokedWithSender:self
                              notification:notification];
                              
  [self.eventBroadcaster
    notifyOnReactAppWillReloadWithSender:self
                            notification:notification];
  
  [self.eventBroadcaster notifyOnRequestForCleanupWithSender:self];
}
#endif
#else

// MARK: - React Lifecycle (Paper Only)
// ------------------------------------

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
  [self.reactSubviewRegistry setObject:subview
                                forKey:subview.reactNativeTag];

  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnMountChildComponentViewWithSender:
                                          childComponentView:
                                                       index:
                                                  superBlock:)];
  
  if(shouldNotifyDelegate){
    id superBlock = ^{
      [super insertReactSubview:subview atIndex:atIndex];
    };
    
    [self.contentDelegate notifyOnMountChildComponentViewWithSender:self
                                                 childComponentView:subview
                                                              index:atIndex
                                                         superBlock:superBlock];
                          
  } else {
    [super insertReactSubview:subview atIndex:atIndex];
  };
}

- (void)removeReactSubview:(UIView *)subview
{
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnMountChildComponentViewWithSender:
                                          childComponentView:
                                                       index:
                                                  superBlock:)];
  
  if(shouldNotifyDelegate){
    id superBlock = ^{
      [super removeReactSubview:subview];
    };
    
    [self.contentDelegate
      notifyOnUnmountChildComponentViewWithSender:self
                               childComponentView:subview
                                            index:-1
                                       superBlock:superBlock];
  } else {
    [super removeReactSubview:subview];
  };
}

- (void)didSetProps:(NSArray<NSString *> *)changedProps
{
  self.contentDelegate.reactProps =
    [self.reactPropHandler.propHolder.propsMap copy];
         
  [self.eventBroadcaster notifyDidSetPropsWithSender:self
                                        changedProps:changedProps];
                                        
  [self.eventBroadcaster notifyDidSetPropsWithSender:self];
  [self _dispatchViewEventOnDidSetViewIDIfNeeded];
}

- (void)invalidate
{
  [self.eventBroadcaster notifyOnViewWillInvalidateWithSender:self];
  [self.eventBroadcaster notifyOnRequestForCleanupWithSender:self];
}

#if DEBUG
// Note: Only gets called on paper?
- (void)handleOnBridgeWillReloadNotification:(NSNotification *)notification
{
  [self.eventBroadcaster notifyOnBridgeWillReloadWithSender:self
                                               notification:notification];
                                               
  [self.eventBroadcaster
    notifyOnReactAppWillReloadWithSender:self
                            notification:notification];
  
  [self.eventBroadcaster notifyOnRequestForCleanupWithSender:self];
}
#endif
#endif

// MARK: - Base Event Support
// --------------------------

+ (BOOL)doesSupportBaseEventOnViewWillRecycle
{
  return NO;
}

// MARK: - Dummy Impl.
// -------------------

// This is meant to be overridden by the subclass
+ (Class _Nonnull)viewDelegateClass
{
  NSString *errorMessage = [NSString stringWithFormat:
    @"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
  
  throw [NSException exceptionWithName:NSInternalInconsistencyException
                                reason:errorMessage
                              userInfo:nil];
}

// MARK: - RNIViewCommandRequestHandling
// -------------------------------------

- (void)handleViewRequestForCommandName:(NSString *)commandName
                          withArguments:(NSDictionary *)commandArguments
                                resolve:(RNIPromiseResolveBlock)resolveBlock
                                 reject:(RNIPromiseRejectBlock)rejectBlock
{
  if(!self.contentDelegate){
    NSString *messageRaw =
      @"Unable to forward command request: '%@' "
      @" because the associated view for viewID: '%@'"
      @" of class type: '%@'"
      @" does not have a contentDelegate (self.contentDelegate is nil)";
  
    NSString *className = NSStringFromClass([self class]);
    
    NSString *message =
      [NSString stringWithFormat: messageRaw, commandName, viewID, className];
  
    rejectBlock(message);
  };
  
  SEL targetSelector =
    @selector(notifyOnViewCommandRequestWithSender:forCommandName:withCommandArguments:resolve:reject:);
    
  if(![self.contentDelegate respondsToSelector:targetSelector]){
    NSString *messageRaw =
      @"Unable to forward command request: '%@' "
      @" because the associated view for viewID: '%@'"
      @" of class type: '%@'"
      @" with parent class type: '%@'"
      @" does not implement selector: '%@'";
  
    NSString *className = NSStringFromClass([self class]);
    NSString *contentViewClassName = NSStringFromClass([self.contentView class]);
    NSString *selectorName = NSStringFromSelector(targetSelector);
    
    NSString *message =
      [NSString stringWithFormat: messageRaw, commandName, viewID, contentViewClassName, className, selectorName];
    
    rejectBlock(message);
  };
  
  [self.contentDelegate
    notifyOnViewCommandRequestWithSender:self
                          forCommandName:commandName
                    withCommandArguments:commandArguments
                                 resolve:resolveBlock
                                  reject:rejectBlock];
};

@end
