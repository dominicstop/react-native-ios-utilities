#ifdef RCT_NEW_ARCH_ENABLED
#import <react-native-ios-utilities/IosUtilitiesView.h>

#import <react/renderer/components/RNIosUtilitiesViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/EventEmitters.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/Props.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"

#import "react-native-ios-utilities/Swift.h"

using namespace facebook::react;

@interface IosUtilitiesView () <RCTIosUtilitiesViewViewProtocol, RNIViewLifecycleEventsNotifying>

@end

@implementation IosUtilitiesView {
    UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<IosUtilitiesViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    
    static const auto defaultProps = std::make_shared<const IosUtilitiesViewProps>();
    _props = defaultProps;
    
    UIView<RNIViewLifecycleEventsNotifiable> *viewDelegate =
      [[IosUtilitiesViewDelegate new] initWithFrame:frame];
      
    self.lifecycleEventDelegate = viewDelegate;
    self.contentView = viewDelegate;
    
    if ([viewDelegate respondsToSelector:@selector(notifyOnInitWithSender:frame:)]) {
      [viewDelegate notifyOnInitWithSender:self frame:frame];
    }
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<IosUtilitiesViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<IosUtilitiesViewProps const>(props);

    if (oldViewProps.color != newViewProps.color) {
      const char *colorStringRaw = newViewProps.color.c_str();
      NSString *colorString = [NSString stringWithUTF8String:colorStringRaw];
      UIColor *color = [Utils hexStringToColor:colorString];
      [_view setBackgroundColor: color];
    }

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> IosUtilitiesViewCls(void)
{
    return IosUtilitiesView.class;
}

@end
#endif
