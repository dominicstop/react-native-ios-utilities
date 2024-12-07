//
//  RNIDetachedView.mm
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

#import "RNIDetachedView.h"

#import "../../Swift.h"
#import "RNIContentViewParentDelegate.h"

#import "UIApplication+RNIHelpers.h"
#import "RNIObjcUtils.h"

#if RCT_NEW_ARCH_ENABLED
#include "RNIDetachedViewComponentDescriptor.h"

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

#import <react/renderer/components/RNIUtilitiesSpec/EventEmitters.h>
#import <react/renderer/components/RNIUtilitiesSpec/RCTComponentViewHelpers.h>
#else
#import <React/RCTTouchHandler.h>
#import <React/RCTInvalidating.h>
#endif

#ifdef RCT_NEW_ARCH_ENABLED
using namespace facebook::react;
#endif


@interface RNIDetachedView () <
  RNIContentViewParentDelegate,
#ifdef RCT_NEW_ARCH_ENABLED
  RCTRNIDetachedViewViewProtocol
#else
  RCTInvalidating
#endif
> {
  // TBA
}
@end

@implementation RNIDetachedView {
}

// MARK: - Init
// ------------

- (void)initCommon {
  [super initCommon];
}

// MARK: - RNIBaseView
// -------------------

+ (Class)viewDelegateClass
{
  return [RNIDetachedViewContent class];
}

+ (BOOL)doesSupportBaseEventOnViewWillRecycle
{
  return YES;
}

// MARK: - Fabric
// --------------

#if RCT_NEW_ARCH_ENABLED
+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RNIDetachedViewComponentDescriptor>();
}

Class<RCTComponentViewProtocol> RNIDetachedViewCls(void)
{
  return RNIDetachedView.class;
}
#endif
@end



