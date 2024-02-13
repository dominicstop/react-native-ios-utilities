//
//  RNICleanupMode.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/20/22.
//

import Foundation

@available(*, deprecated, message: "Use `RNIViewCleanupTrigger` instead")
/// If a type conforms to `RNIInternalCleanupMode`,
/// this enum determines how the cleanup routine is triggered.
///
public enum RNICleanupMode: String {
  
  case automatic;
  
  /// Trigger cleanup via view controller lifecycle
  case viewController;
  
  /// Trigger cleanup via react lifecycle `componentWillUnmount` event sent
  /// from the js-side, i.e. via `RNIJSComponentWillUnmountNotifiable`
  case reactComponentWillUnmount;
  
  /// Trigger cleanup when the view moves to `nil` window
  case didMoveToWindowNil;
  
  case disabled;
};

@available(*, deprecated, message: "Use `RNIViewCleanupTrigger` instead")
public extension RNICleanupMode {
  
  var shouldEnableCleanup: Bool {
    self != .disabled;
  };
  
  var shouldAttachToParentVC: Bool {
    self == .viewController;
  };
};
