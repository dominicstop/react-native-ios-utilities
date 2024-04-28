// This guard prevent this file to be compiled in the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef IosUtilitiesViewNativeComponent_h
#define IosUtilitiesViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

@interface IosUtilitiesView : RCTViewComponentView
@end

NS_ASSUME_NONNULL_END

#endif /* IosUtilitiesViewNativeComponent_h */
#endif /* RCT_NEW_ARCH_ENABLED */
