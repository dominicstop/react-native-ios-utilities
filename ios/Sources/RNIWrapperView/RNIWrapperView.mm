//
//  RNIWrapperView.mm
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

#import "RNIWrapperView.h"

#import "../../Swift.h"
#import "RNIContentViewParentDelegate.h"

#import "UIApplication+RNIHelpers.h"
#import "RNIObjcUtils.h"

#if RCT_NEW_ARCH_ENABLED
#include "RNIWrapperViewComponentDescriptor.h"

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


@interface RNIWrapperView () <
  RNIContentViewParentDelegate,
#ifdef RCT_NEW_ARCH_ENABLED
  RCTRNIWrapperViewViewProtocol
#else
  RCTInvalidating
#endif
> {
  // TBA
}
@end

@implementation RNIWrapperView {
}

- (CGSize)intrinsicContentSize
{
  CGSize reactSize = self.cachedLayoutMetrics.frame.size;
  CGSize newSize = [super intrinsicContentSize];
  
  if(newSize.width == 0){
    newSize.width = reactSize.width;
  };
  
  if(newSize.height == 0){
    newSize.height = reactSize.height;
  };
  
  return newSize;
};

// MARK: - RNIBaseView
// -------------------

+ (Class)viewDelegateClass
{
  return [RNIWrapperViewContent class];
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
  return concreteComponentDescriptorProvider<RNIWrapperViewComponentDescriptor>();
}

Class<RCTComponentViewProtocol> RNIWrapperViewCls(void)
{
  return RNIWrapperView.class;
}
#endif
@end



