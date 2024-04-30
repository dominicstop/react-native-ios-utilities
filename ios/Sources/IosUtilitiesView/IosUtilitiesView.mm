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
  
  static const auto defaultProps = std::make_shared<const IosUtilitiesViewProps>();
  self->_props = defaultProps;

  self = [super initWithFrame:frame];
  if(self == nil){
    return nil;
  };
  
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
      [self.contentView setBackgroundColor: color];
    }

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> IosUtilitiesViewCls(void)
{
    return IosUtilitiesView.class;
}

// MARK: - RNIBaseView
// -------------------

- (Class)viewDelegateClass
{
  return [IosUtilitiesViewDelegate class];
}

@end
#endif
