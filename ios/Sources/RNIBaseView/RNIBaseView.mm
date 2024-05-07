//
//  RNIBaseView.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIBaseView.h"

#import "react-native-ios-utilities/Swift.h"
#import <react-native-ios-utilities/RNIObjcUtils.h>

#import "RCTFabricComponentsPlugins.h"

#include "RNIBaseViewState.h"

#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/graphics/Float.h>
#include <react/renderer/core/graphicsConversions.h>


using namespace facebook;
using namespace react;

@interface RNIBaseView () <RNIViewLifecycleEventsNotifying>
@end

@implementation RNIBaseView {
  UIView * _view;
  RNIBaseViewState::SharedConcreteState _state;
}

// MARK: - Init
// ------------

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if(self == nil) {
    return nil;
  }
  
  Class viewDelegateClass = [self viewDelegateClass];
  if(![viewDelegateClass isSubclassOfClass: [UIView class]]) {
    return nil;
  }
  
  if(![viewDelegateClass conformsToProtocol:@protocol(RNIViewLifecycleEventsNotifiable)]) {
    return nil;
  }
  
  UIView<RNIViewLifecycleEventsNotifiable> *viewDelegate =
    [[viewDelegateClass new] initWithFrame:frame];
  
  self.lifecycleEventDelegate = viewDelegate;
  self.contentView = viewDelegate;
    
  if ([viewDelegate respondsToSelector:@selector(notifyOnInitWithSender:frame:)]) {
    [viewDelegate notifyOnInitWithSender:self frame:frame];
  }
  
  return self;
}

// MARK: - Functions
// -----------------

- (void) setSize:(CGSize)size {
  if(self->_state != nullptr){
    RNIBaseViewState prevState = self->_state->getData();
    RNIBaseViewState newState = RNIBaseViewState(prevState);
    
    auto newSize = [RNIObjcUtils convertToReactSizeForSize:size];
    newState.frameSize = newSize;
    
    self->_state->updateState(std::move(newState));
    [self->_view setNeedsLayout];
  }
};

// MARK: - Fabric Lifecycle
// ------------------------

-(void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                         index:(NSInteger)index
{
  BOOL shouldNotifyDelegate =
       self.lifecycleEventDelegate != nil
    && [self.lifecycleEventDelegate respondsToSelector:@selector(notifyOnMountChildComponentViewWithSender:childComponentView:index:)];
  
  if(shouldNotifyDelegate){
    [self.lifecycleEventDelegate notifyOnMountChildComponentViewWithSender:self
                                                        childComponentView:childComponentView
                                                                     index:index];
  }
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView
                            index:(NSInteger)index
{
  BOOL shouldNotifyDelegate =
       self.lifecycleEventDelegate != nil
    && [self.lifecycleEventDelegate respondsToSelector:@selector(notifyOnMountChildComponentViewWithSender:childComponentView:index:)];
  
  if(shouldNotifyDelegate){
    [self.lifecycleEventDelegate notifyOnUnmountChildComponentViewWithSender:self
                                                          childComponentView:childComponentView
                                                                      index:index];
  }
}

- (void)updateLayoutMetrics:(const LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const LayoutMetrics &)oldLayoutMetrics
{
  BOOL shouldNotifyDelegate =
       self.lifecycleEventDelegate != nil
    && [self.lifecycleEventDelegate respondsToSelector:@selector(notifyOnUpdateLayoutMetricsWithSender:oldLayoutMetrics:newLayoutMetrics:)];
  
  if (shouldNotifyDelegate) {
    RNILayoutMetrics *layoutMetricsOld = [RNIObjcUtils createRNILayoutMetricsFrom:oldLayoutMetrics];
    RNILayoutMetrics *layoutMetricsNew = [RNIObjcUtils createRNILayoutMetricsFrom:layoutMetrics];
    
    [self.lifecycleEventDelegate notifyOnUpdateLayoutMetricsWithSender:self
                                                      oldLayoutMetrics:layoutMetricsOld
                                                      newLayoutMetrics:layoutMetricsNew];
  }
  
  [super updateLayoutMetrics:layoutMetrics oldLayoutMetrics:oldLayoutMetrics];
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
       self.lifecycleEventDelegate != nil
    && [self.lifecycleEventDelegate respondsToSelector:@selector(notifyOnUpdateStateWithSender:oldState:newState:)];
    
  if(shouldNotifyDelegate){
    [self.lifecycleEventDelegate notifyOnUpdateStateWithSender:self
                                                      oldState:oldStateDict
                                                      newState:newStateDict];
  };
    
  [super updateState:state oldState:oldState];
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask
{
  BOOL shouldNotifyDelegate =
       self.lifecycleEventDelegate != nil
    && [self.lifecycleEventDelegate respondsToSelector:@selector(notifyOnUnmountChildComponentViewWithSender:childComponentView:index:)];
    
  if(shouldNotifyDelegate){
    RNIComponentViewUpdateMask *swiftMask =
      [[RNIComponentViewUpdateMask new] initWithRawValue:updateMask];
  
    [self.lifecycleEventDelegate notifyOnFinalizeUpdatesWithSender:self
                                                     updateMaskRaw:updateMask
                                                        updateMask:swiftMask];
  }
  
  [super finalizeUpdates:updateMask];
}

-(void) prepareForRecycle
{
  BOOL shouldNotifyDelegate =
       self.lifecycleEventDelegate != nil
    && [self.lifecycleEventDelegate respondsToSelector:@selector(notifyOnPrepareForReuseWithSender:)];
  
  if(shouldNotifyDelegate){
    [self.lifecycleEventDelegate notifyOnPrepareForReuseWithSender:self];
  }
  
  [super prepareForRecycle];
}

// MARK: - Dummy Impl.
// -------------------

// This is meant to be overridden by the subclass
- (Class _Nonnull)viewDelegateClass {
  return [UIView class];
}

@end
#endif
