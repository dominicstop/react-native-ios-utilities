//
//  RNIBaseView.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

#ifdef RCT_NEW_ARCH_ENABLED
#import <react-native-ios-utilities/RNIBaseView.h>

#import <react/renderer/components/RNIosUtilitiesViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/EventEmitters.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/Props.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"

#import "react-native-ios-utilities/Swift.h"

using namespace facebook::react;

@interface RNIBaseView () <RNIViewLifecycleEventsNotifying>

@end

@implementation RNIBaseView {
  UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<IosUtilitiesViewComponentDescriptor>();
}

// This is meant to be overriden
- (Class _Nonnull)viewDelegateClass {
  return [UIView class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  
  if(self == nil) {
    return nil;
  };
  
  Class viewDelegateClass = [self viewDelegateClass];
  if(![viewDelegateClass isSubclassOfClass: [UIView class]]) {
    return nil;
  };
  
  if(![viewDelegateClass conformsToProtocol:@protocol(RNIViewLifecycleEventsNotifiable)]) {
    return nil;
  };
  
  UIView<RNIViewLifecycleEventsNotifiable> *viewDelegate =
    [[viewDelegateClass new] initWithFrame:frame];
  
  self.lifecycleEventDelegate = viewDelegate;
  self.contentView = viewDelegate;

  static const auto defaultProps = std::make_shared<const IosUtilitiesViewProps>();
  self->_props = defaultProps;
    
  if ([viewDelegate respondsToSelector:@selector(notifyOnInitWithSender:frame:)]) {
    [viewDelegate notifyOnInitWithSender:self frame:frame];
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<IosUtilitiesViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<IosUtilitiesViewProps const>(props);

  [super updateProps:props oldProps:oldProps];
}

@end
#endif
