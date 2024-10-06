//
//  RNIViewLifecycleCommon.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation

public protocol RNIViewLifecycleCommon {

  func notifyOnInit(
    sender: RNIContentViewParentDelegate
  );
  
  func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  );
  
  func notifyOnRequestForCleanup(
    sender: RNIContentViewParentDelegate
  );
  
  #if DEBUG
  func notifyOnReactAppWillReload(
    sender: RNIContentViewParentDelegate,
    notification: NSNotification
  );
  #endif
};

// MARK: - RNIViewLifecycleCommon+Default
// --------------------------------------

public extension RNIViewLifecycleCommon {
  
  func notifyOnInit(
    sender: RNIContentViewParentDelegate
  ) {
    // no-op
  };
  
  func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  ) {
    // no-op
  };
  
  func notifyOnRequestForCleanup(
    sender: RNIContentViewParentDelegate
  ) {
    // no-op
  };
  
  #if DEBUG
  func notifyOnReactAppWillReload(
    sender: RNIContentViewParentDelegate,
    notification: NSNotification
  ) {
    // no-op
  };
  #endif
};
