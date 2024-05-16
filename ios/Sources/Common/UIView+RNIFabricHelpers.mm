//
//  UIView+RNIFabricHelpers.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/9/24.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "UIView+RNIFabricHelpers.h"

#if __cplusplus
#import "UIView+RNIHelpers.h"

#import <React/RCTSurfaceHostingView.h>
#import <React/RCTFabricSurface.h>
#import <React/RCTViewComponentView.h>
#endif

@implementation UIView (RNIFabricHelpers)
#if __cplusplus
- (RCTSurfaceHostingView *)reactGetClosestParentSurfaceHostingView
{
    return [responder isKindOfClass:[RCTSurfaceHostingView class]];
  }];
  
  if(match == nil){
    return nil;
  };
  
  return (RCTSurfaceHostingView *)match;
}

- (RCTFabricSurface *)reactGetClosestFabricSurface
{
  RCTSurfaceHostingView *surfaceHostingView = [self reactGetClosestParentSurfaceHostingView];
  if(surfaceHostingView == nil){
    return nil;
  };
  
  id<RCTSurfaceProtocol> surface = [surfaceHostingView surface];
  if(![surface isKindOfClass:[RCTFabricSurface class]]){
    return nil;
  };
  
  return (RCTFabricSurface *)surface;
}

/// Note - Prefer to use:
/// ```
/// RCTFabricSurface *fabricSurface = [view reactGetClosestFabricSurface];
/// const SurfaceHandler &surfaceHandler = [fabricSurface surfaceHandler];
/// ```
- (facebook::react::SurfaceHandler *)reactGetSurfaceHandler
{
  RCTFabricSurface *fabricSurface = [self reactGetClosestFabricSurface];
  if(fabricSurface == nil){
    return nil;
  };
  
  Ivar ivar = class_getInstanceVariable([fabricSurface class], "_surfaceHandler");
  ptrdiff_t offset = ivar_getOffset(ivar);
  
  unsigned char* bytes = (unsigned char *)(__bridge void*)fabricSurface;
  auto surfaceHandler = ((std::optional<facebook::react::SurfaceHandler> *)(bytes+offset));
  
  if(!surfaceHandler->has_value()){
    return nil;
  };
  
  return &surfaceHandler->value();
}

- (facebook::react::LayoutMetrics *)reactGetFabricLayoutMetrics
{
  RCTViewComponentView *componentView = (RCTViewComponentView *)self;
  if(componentView == nil){
    return nullptr;
  };
  
  Ivar ivar = class_getInstanceVariable([componentView class], "_layoutMetrics");
  ptrdiff_t offset = ivar_getOffset(ivar);
  
  unsigned char* bytes = (unsigned char *)(__bridge void*)componentView;
  auto layoutMetrics = ((facebook::react::LayoutMetrics *)(bytes+offset));
  
  if(layoutMetrics == nullptr){
    return nullptr;
  };
  
  return layoutMetrics;
}
#endif
@end
