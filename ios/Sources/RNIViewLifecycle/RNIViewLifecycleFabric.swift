//
//  RNIViewLifecycleFabric.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation


#if RCT_NEW_ARCH_ENABLED
@objc
public protocol RNIViewLifecycleFabric {

  @objc
  optional func notifyOnUpdateState(
    sender: RNIContentViewParentDelegate,
    oldState: NSDictionary?,
    newState: NSDictionary
  );
  
  @objc
  optional func notifyOnFinalizeUpdates(
    sender: RNIContentViewParentDelegate,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  );
  
  @objc
  optional func notifyOnPrepareForReuse(
    sender: RNIContentViewParentDelegate
  );
};
#endif
