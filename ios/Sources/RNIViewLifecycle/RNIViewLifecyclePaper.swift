//
//  RNIViewLifecyclePaper.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation


#if !RCT_NEW_ARCH_ENABLED
@objc(RNIViewLifecyclePaperSwift)
public protocol RNIViewLifecyclePaper {

  @objc
  optional func notifyOnViewWillInvalidate(
    sender: RNIContentViewParentDelegate
  );
  
  // MARK: - Debug Only
  // ------------------
  
  /// Note: Only gets invoked in paper for some reason
  @objc
  optional func notifyOnBridgeWillReload(
    sender: RNIContentViewParentDelegate,
    notification: Notification
  );
};
#endif
