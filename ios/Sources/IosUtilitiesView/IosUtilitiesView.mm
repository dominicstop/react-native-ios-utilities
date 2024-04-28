#ifdef RCT_NEW_ARCH_ENABLED
#import "IosUtilitiesView.h"

#import <react/renderer/components/RNIosUtilitiesViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/EventEmitters.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/Props.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import "Utils.h"

#import "react_native_ios_utilities-Swift.h"

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

    UIView *view = [UIView new];
    self->_view = view;
    
    TestDummyClass *dummy = [TestDummyClass new];
    NSNumber *result = @([dummy addWithA:10 b:20]);
    
    UILabel *label = [UILabel new];
    label.text = [result.stringValue stringByAppendingString:@" Hello World, New Arch "];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];

    NSArray *constraints = @[
      [NSLayoutConstraint constraintWithItem:label
                                   attribute:NSLayoutAttributeCenterX
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:label
                                   attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                    constant:0.0],
                                    
      [NSLayoutConstraint constraintWithItem:label
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:label
                                   attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0
                                    constant:0.0],
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
    self.contentView = view;
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
