#import <UIKit/UIKit.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#else
#import <React/RCTView.h>
#endif

@protocol RNIViewLifecycleEventsNotifying;
@protocol RNIViewLifecycleEventsNotifiable;

// Interface visible in Swift
@interface IosUtilitiesView:
#ifdef RCT_NEW_ARCH_ENABLED
  RCTViewComponentView<RNIViewLifecycleEventsNotifying>
#else // RCT_NEW_ARCH_ENABLED
   RCTView<RNIViewLifecycleEventsNotifying>
#endif // paper

@property (nonatomic, strong, nullable) NSObject<RNIViewLifecycleEventsNotifiable> *lifecycleEventDelegate;

@end
