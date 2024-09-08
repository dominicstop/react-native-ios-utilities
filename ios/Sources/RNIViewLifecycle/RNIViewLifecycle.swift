//
//  RNIViewLifecycle.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation


#if RCT_NEW_ARCH_ENABLED
public typealias RNIViewLifecycle =
    RNIViewLifecycleCommon
  & RNIViewLifecycleFabric
  & RNIViewPropUpdatesNotifiable;
#else
public typealias RNIViewLifecycle =
    RNIViewLifecycleCommon
  & RNIViewLifecyclePaper
  & RNIViewPropUpdatesNotifiable;
#endif


