//
//  RNIBaseView.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#import "RNIBaseView.h"
#import "react-native-ios-utilities/Swift.h"

#import <objc/runtime.h>

#import "react-native-ios-utilities/RNIUtilitiesModule.h"
#import "react-native-ios-utilities/RNIViewRegistry.h"
#import "react-native-ios-utilities/RNIBaseViewPaperPropHolder.h"

#import "react-native-ios-utilities/RNIContentViewParentDelegate.h"
#import "react-native-ios-utilities/RNIContentViewDelegate.h"
#import "react-native-ios-utilities/RNIViewCommandRequestHandling.h"

#import "react-native-ios-utilities/RNIObjcUtils.h"
#import "react-native-ios-utilities/UIApplication+RNIHelpers.h"
#import "react-native-ios-utilities/UIView+RNIHelpers.h"

#ifdef RCT_NEW_ARCH_ENABLED
#include "RNIBaseViewState.h"
#include "RNIBaseViewProps.h"
#include "RNIBaseViewEventEmitter.h"

#import "RCTFabricComponentsPlugins.h"
#import <React/RCTFollyConvert.h>

#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/graphics/Float.h>
#include <react/renderer/core/graphicsConversions.h>
#else
#import "RNIBaseViewPaperEventHandler.h"
#import "RNIBaseViewPaperPropHandler.h"
#import "react-native-ios-utilities/UIView+RNIPaperHelpers.h"

#import <React/UIView+React.h>
#import <React/RCTShadowView.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
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
  BOOL _didDispatchEventOnDidSetViewID;
  NSMutableArray<UIView *> *_reactSubviews;
#ifdef RCT_NEW_ARCH_ENABLED
  UIView * _view;
  RNIBaseViewState::SharedConcreteState _state;
#else
  CGRect _reactFrame;
#endif
}

@synthesize viewID;

// MARK: - Init
// ------------

#ifdef RCT_NEW_ARCH_ENABLED
- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const react::RNIBaseViewProps>();
    _props = defaultProps;
    _reactSubviews = [NSMutableArray new];
    
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
#endif

// NOTE: To be overridden + impl. by child class
- (void)initCommon
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
  
  UIView<RNIContentViewDelegate> *viewDelegate =
    [[viewDelegateClass new] initWithFrame:self.frame];
    
  viewDelegate.parentReactView = self;
  
  self.contentDelegate = viewDelegate;
  self.contentView = viewDelegate;
  
  BOOL shouldNotifyDelegateForInit =
       !self->_didNotifyForInit
    && [viewDelegate respondsToSelector:@selector(notifyOnInitWithSender:)];
  
  if(shouldNotifyDelegateForInit) {
    self->_didNotifyForInit = YES;
    [viewDelegate notifyOnInitWithSender:self];
  };
  
#if !RCT_NEW_ARCH_ENABLED
  BOOL shouldNotifyDelegateToSetupConstraints =
    [viewDelegate respondsToSelector:@selector(_notifyOnRequestToSetupConstraintsWithSender:)];
    
  if(shouldNotifyDelegateToSetupConstraints){
     [viewDelegate _notifyOnRequestToSetupConstraintsWithSender:self];
  };
  
  [self.reactEventHandler createSettersForEvents:^(){
    NSMutableArray *events =
      [NSMutableArray arrayWithArray:[self.contentDelegate _getSupportedReactEvents]];
      
  RNILog(
    @"%@\n%@ %@\n%@ %@",
    @"[RNIBaseView initCommon]",
    @" - Class Name:", NSStringFromClass([self class]),
    @" - Supported Events:", events
  );

    [events addObject:@"onDidSetViewID"];
    return events;
  }()];
  
  NSDictionary *propTypeMap =
    [self.contentDelegate _getSupportedReactPropsTypeMap];
    
  [self.reactPropHandler setPropTypeMap:propTypeMap];
  
  NSArray *propList = [self.contentDelegate _getSupportedReactProps];
  [self.reactPropHandler createSettersForProps:propList];
  
  RNILog(
    @"%@\n%@ %@\n%@ %@",
    @"RNIBaseView.initCommon",
    @" - Class Name:", NSStringFromClass([self class]),
    @" - Supported Props:", propList
  );
#endif
}

// MARK: Methods
// -------------

- (void)_dispatchOnDidSetViewIDEventIfNeeded
{
  BOOL shouldDispatchEvent =
       !self->_didDispatchEventOnDidSetViewID
#if RCT_NEW_ARCH_ENABLED
    && self->_eventEmitter != nil;
#else
    && self.window != nil;
#endif

  if(!shouldDispatchEvent){
    return;
  };

  self->_didDispatchEventOnDidSetViewID = YES;
  NSDictionary *dict = @{
    @"viewID": self.viewID,
    @"reactTag": [self reactNativeTag],
  };
  
  [self dispatchViewEventForEventName:@"onDidSetViewID"
                          withPayload:dict];
}

// MARK: Methods - Paper-Only
// --------------------------

#if !RCT_NEW_ARCH_ENABLED
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

  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:@selector(notifyOnUpdateLayoutMetricsWithSender:oldLayoutMetrics:newLayoutMetrics:)];
  
  if (shouldNotifyDelegate) {
    [self.contentDelegate notifyOnUpdateLayoutMetricsWithSender:self
                                                      oldLayoutMetrics:oldLayoutMetrics
                                                      newLayoutMetrics:newLayoutMetrics];
  };
}
#endif

// MARK: - RNIContentViewParentDelegate Commands
// ---------------------------------------------

- (void)setSize:(CGSize)size
{
#if RCT_NEW_ARCH_ENABLED
  if(self->_state != nullptr){
    RNIBaseViewState prevState = self->_state->getData();
    RNIBaseViewState newState = RNIBaseViewState(prevState);
    
    auto newSize = [RNIObjcUtils convertToReactSizeForSize:size];
    newState.frameSize = newSize;
    newState.shouldSetSize = true;
    
    self->_state->updateState(std::move(newState));
    [self->_view setNeedsLayout];
  }
#else
  if(self.bridge == nil){
    return;
  };
  
  RCTUIManager *uiManager = self.bridge.uiManager;
  if(uiManager == nil){
    return;
  };
  
  [uiManager setSize:size forView:self];
#endif
};

- (void)dispatchViewEventForEventName:(NSString *)eventName
                          withPayload:(NSDictionary *)eventPayload
{
#if RCT_NEW_ARCH_ENABLED
  if (self->_eventEmitter == nullptr){
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

#if RCT_NEW_ARCH_ENABLED
- (void)setPadding:(UIEdgeInsets)padding
{
  RNIBaseViewState prevState = self->_state->getData();
  RNIBaseViewState newState = RNIBaseViewState(prevState);
  
  auto newPadding = [RNIObjcUtils convertToReactRectangleEdgesForEdgeInsets:padding];
  newState.padding = newPadding;
  newState.shouldSetPadding = true;
  
  self->_state->updateState(std::move(newState));
  [self->_view setNeedsLayout];
}

- (void)setPositionType:(RNIPositionType)positionType
{
  RNIBaseViewState prevState = self->_state->getData();
  RNIBaseViewState newState = RNIBaseViewState(prevState);
  
  newState.positionType =
    [RNIObjcUtils convertToYGPostionTypeForRNIPostionType:positionType];
     
  newState.shouldSetPositionType = true;
  
  self->_state->updateState(std::move(newState));
  [self->_view setNeedsLayout];
}
#endif

// MARK: - View/React Lifecycle - Fabric Only
// ------------------------------------------

#ifdef RCT_NEW_ARCH_ENABLED
-(void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
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
}

- (void)updateEventEmitter:(const facebook::react::EventEmitter::Shared &)eventEmitter
{
  [super updateEventEmitter:eventEmitter];
  [self _dispatchOnDidSetViewIDEventIfNeeded];
}

- (void)updateLayoutMetrics:(const LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const LayoutMetrics &)oldLayoutMetrics
{
  RNILayoutMetrics *layoutMetricsNew = [RNIObjcUtils convertToRNILayoutMetricsForFabricLayoutMetrics:layoutMetrics];
  self.cachedLayoutMetrics = layoutMetricsNew;

  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:@selector(notifyOnUpdateLayoutMetricsWithSender:oldLayoutMetrics:newLayoutMetrics:)];
  
  if (shouldNotifyDelegate) {
    RNILayoutMetrics *layoutMetricsOld = [RNIObjcUtils convertToRNILayoutMetricsForFabricLayoutMetrics:oldLayoutMetrics];
    
    [self.contentDelegate notifyOnUpdateLayoutMetricsWithSender:self
                                                      oldLayoutMetrics:layoutMetricsOld
                                                      newLayoutMetrics:layoutMetricsNew];
  }
  
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
  
  BOOL shouldNotifyDelegateForOnUpdateProps =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnUpdatePropsWithSender:
                                        oldProps:
                                        newProps:)];
    
  if(shouldNotifyDelegateForOnUpdateProps){
    [self.contentDelegate notifyOnUpdatePropsWithSender:self
                                               oldProps:dictPropsOld
                                               newProps:dictPropsNew];
  };
  
  BOOL shouldNotifyDelegateForDidSetProps =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyDidSetPropsWithSender:)];
         
  if(shouldNotifyDelegateForDidSetProps){
    [self.contentDelegate notifyDidSetPropsWithSender:self];
  };

  [super updateProps:props oldProps:oldProps];
}

- (void)updateState:(const State::Shared &)state
           oldState:(const State::Shared &)oldState
{
  auto newState =
    std::static_pointer_cast<const RNIBaseViewState::ConcreteState>(state);
    
  self->_state = newState;
  
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
    
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnUpdateStateWithSender:
                                        oldState:
                                        newState:)];
    
  if(shouldNotifyDelegate){
    [self.contentDelegate notifyOnUpdateStateWithSender:self
                                               oldState:oldStateDict
                                               newState:newStateDict];
  };
    
  [super updateState:state oldState:oldState];
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask
{
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnFinalizeUpdatesWithSender:
                                       updateMaskRaw:
                                          updateMask:)];
    
  if(shouldNotifyDelegate){
    RNIComponentViewUpdateMask *swiftMask =
      [[RNIComponentViewUpdateMask new] initWithRawValue:updateMask];
  
    [self.contentDelegate notifyOnFinalizeUpdatesWithSender:self
                                              updateMaskRaw:updateMask
                                                 updateMask:swiftMask];
  }
  
  [super finalizeUpdates:updateMask];
}

-(void) prepareForRecycle
{
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyOnPrepareForReuseWithSender:)];
  
  if(shouldNotifyDelegate){
    [self.contentDelegate notifyOnPrepareForReuseWithSender:self];
  }
  
  [super prepareForRecycle];
}
#else

// MARK: - View/React Lifecycle - Paper Only
// -----------------------------------------

- (void)didMoveToWindow
{
  [self _dispatchOnDidSetViewIDEventIfNeeded];
  [self reactGetShadowViewWithCompletionHandler:^(RCTShadowView *shadowView) {
    self.cachedShadowView = shadowView;
    if(shadowView == nil){
      return;
    };
  }];
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  if(self.cachedShadowView == nil){
    [self reactGetShadowViewWithCompletionHandler:^(RCTShadowView *shadowView) {
      self.cachedShadowView = shadowView;
      if(shadowView == nil){
        return;
      };
      
      [self _notifyDelegateForLayoutMetricsUpdate];
    }];
    
  } else {
    [self _notifyDelegateForLayoutMetricsUpdate];
  };
  
  RNILog(
    @"%@\n%@ %d\n%@ %@\n%@ %@\n%@ %@",
    @"RNIBaseView.layoutSubviews",
    @" - self.reactSubviews count:", (int)[self.reactSubviews count],
    @" - self.cachedShadowView:", self.cachedShadowView,
    @" - self.frame:", NSStringFromCGRect(self.frame),
    @" - self.cachedLayoutMetrics:", self.cachedLayoutMetrics
  );
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
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
    
  BOOL shouldNotifyDelegate =
       self.contentDelegate != nil
    && [self.contentDelegate respondsToSelector:
         @selector(notifyDidSetPropsWithSender:changedProps:)];
         
  if(shouldNotifyDelegate){
    [self.contentDelegate notifyDidSetPropsWithSender:self
                           changedProps:changedProps];
  };
}
#endif

// MARK: - Dummy Impl.
// -------------------

// This is meant to be overridden by the subclass
+ (Class _Nonnull)viewDelegateClass {
  NSString *errorMessage = [NSString stringWithFormat:
    @"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
  
  throw [NSException exceptionWithName:NSInternalInconsistencyException
                                reason:errorMessage
                              userInfo:nil];
}

// MARK: RNIViewCommandRequestHandling
// -----------------------------------


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

