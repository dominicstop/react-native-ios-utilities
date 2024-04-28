#ifdef RCT_NEW_ARCH_ENABLED
#import "IosUtilitiesView.h"

#import <react/renderer/components/RNIosUtilitiesViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/EventEmitters.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/Props.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"

using namespace facebook::react;

@interface IosUtilitiesView () <RCTIosUtilitiesViewViewProtocol>

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

    _view = [[UIView alloc] init];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<IosUtilitiesViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<IosUtilitiesViewProps const>(props);

    if (oldViewProps.color != newViewProps.color) {
        NSString * colorToConvert = [[NSString alloc] initWithUTF8String: newViewProps.color.c_str()];
        [_view setBackgroundColor: [Utils hexStringToColor:colorToConvert]];
    }

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> IosUtilitiesViewCls(void)
{
    return IosUtilitiesView.class;
}

@end
#endif
