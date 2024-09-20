//
//  RNIViewLifecycleFabric.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation


#if RCT_NEW_ARCH_ENABLED
public protocol RNIViewLifecycleFabric {

  func notifyOnUpdateState(
    sender: RNIContentViewParentDelegate,
    oldState: NSDictionary?,
    newState: NSDictionary
  );
  
  func notifyOnFinalizeUpdates(
    sender: RNIContentViewParentDelegate,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  );
  
  func notifyOnPrepareForReuse(
    sender: RNIContentViewParentDelegate
  );
};

// MARK: - RNIViewLifecyclePaper+Default
// -------------------------------------

public extension RNIViewLifecycleFabric {
  
  func notifyOnUpdateState(
    sender: RNIContentViewParentDelegate,
    oldState: NSDictionary?,
    newState: NSDictionary
  ) {
    // no-op
  };
  
  func notifyOnFinalizeUpdates(
    sender: RNIContentViewParentDelegate,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  ) {
    // no-op
  };
  
  func notifyOnPrepareForReuse(
    sender: RNIContentViewParentDelegate
  ) {
    // no-op
  };
};
#endif
