//
//  UIView+RNIFabricHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/9/24.
//

#import <UIKit/UIKit.h>


@class RCTSurfaceHostingView;
@class RCTFabricSurface;

#if __cplusplus
namespace facebook::react {
  class SurfaceHandler;
  struct LayoutMetrics;
}
#endif

@interface UIView (RNIFabricHelpers)

#if __cplusplus
- (nullable RCTSurfaceHostingView *)reactGetClosestParentSurfaceHostingView;

- (nullable RCTFabricSurface *)reactGetClosestFabricSurface;

- (nullable facebook::react::SurfaceHandler *)reactGetSurfaceHandler;

- (nullable facebook::react::LayoutMetrics *)reactGetFabricLayoutMetrics;
#endif

@end

