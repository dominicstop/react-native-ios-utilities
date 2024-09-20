//
//  RNIViewLifecycle.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/21/24.
//


@protocol RNIViewLifecycleCommonSwift;
@protocol RNIViewLifecycleFabricSwift;

#if RCT_NEW_ARCH_ENABLED
@protocol RNIViewPropUpdatesNotifiableSwift;
#else
@protocol RNIViewLifecyclePaperSwift;
#endif

@protocol RNIViewLifecycleCommon <RNIViewLifecycleCommonSwift>
@end

@protocol RNIViewPropUpdatesNotifiable <RNIViewPropUpdatesNotifiableSwift>
@end

#if RCT_NEW_ARCH_ENABLED
@protocol RNIViewLifecycleFabric <RNIViewLifecycleFabricSwift>
@end
#else
@protocol RNIViewLifecyclePaper <RNIViewLifecyclePaperSwift>
@end
#endif

@protocol RNIViewLifecycle <
  RNIViewLifecycleCommon,
  RNIViewPropUpdatesNotifiable,
#if RCT_NEW_ARCH_ENABLED
  RNIViewLifecycleFabric
#else
  RNIViewLifecyclePaper
#endif
>
@end
