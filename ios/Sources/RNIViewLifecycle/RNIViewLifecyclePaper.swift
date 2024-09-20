//
//  RNIViewLifecyclePaper.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation


#if !RCT_NEW_ARCH_ENABLED
public protocol RNIViewLifecyclePaper {

  func notifyOnViewWillInvalidate(
    sender: RNIContentViewParentDelegate
  );
  
  // MARK: - Debug Only
  // ------------------
  
  /// Note: Only gets invoked in paper for some reason
  func notifyOnBridgeWillReload(
    sender: RNIContentViewParentDelegate,
    notification: Notification
  );
};

// MARK: - RNIViewLifecyclePaper+Default
// -------------------------------------

public extension RNIViewLifecyclePaper {

  func notifyOnViewWillInvalidate(
    sender: RNIContentViewParentDelegate
  ) {
    // no-op
  };
  
  /// Note: Only gets invoked in paper for some reason
  func notifyOnBridgeWillReload(
    sender: RNIContentViewParentDelegate,
    notification: Notification
  ) {
    // no-op
  };
};
#endif
