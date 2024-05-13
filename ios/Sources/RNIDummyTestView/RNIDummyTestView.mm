//
//  RNIDummyTestView.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//

#import "RNIDummyTestView.h"
#import "RNIBaseView.h"

#import "react-native-ios-utilities/Swift.h"
#import "react-native-ios-utilities/UIApplication+RNIHelpers.h"

#import <react-native-ios-utilities/RNIObjcUtils.h>

#if RCT_NEW_ARCH_ENABLED
#include "RNIDummyTestViewComponentDescriptor.h"
#include "RNIBaseViewState.h"
#include "RNIBaseViewProps.h"

#import <React/RCTConversions.h>
#import <React/RCTFabricComponentsPlugins.h>
#import <React/RCTRootComponentView.h>
#import <React/RCTSurfaceTouchHandler.h>

#include <react/renderer/core/ComponentDescriptor.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/graphics/Float.h>
#include <react/renderer/core/graphicsConversions.h>

#import <react/renderer/components/RNIosUtilitiesViewSpec/EventEmitters.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/Props.h>
#import <react/renderer/components/RNIosUtilitiesViewSpec/RCTComponentViewHelpers.h>
#else
#import <React/RCTTouchHandler.h>
#endif

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
#endif

@interface RNIDummyTestView () <
  RNIContentViewParentDelegate,
#ifdef RCT_NEW_ARCH_ENABLED
  RCTRNIDummyTestViewViewProtocol
#else
  RCTInvalidating
#endif
> {
  // TBA
}
@end

@implementation RNIDummyTestView {
}

// MARK: - Init
// ------------

#ifdef RCT_NEW_ARCH_ENABLED
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  return self;
}
#else
- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  self = [super initWithFrame:frame];
  return self;
}
#endif

- (void)initCommon {
  // no-op
}

// MARK: - RNIBaseView
// -------------------

- (Class)viewDelegateClass
{
  return [RNIDummyTestViewDelegate class];
}

// MARK: - Fabric
// --------------

#if RCT_NEW_ARCH_ENABLED
+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RNIDummyTestViewComponentDescriptor>();
}

Class<RCTComponentViewProtocol> RNIDummyTestViewCls(void)
{
  return RNIDummyTestView.class;
}
#endif

@end


