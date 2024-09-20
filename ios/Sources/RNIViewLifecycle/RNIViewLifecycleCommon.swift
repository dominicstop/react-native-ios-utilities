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
};
