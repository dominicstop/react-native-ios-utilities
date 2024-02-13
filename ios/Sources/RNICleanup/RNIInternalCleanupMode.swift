//
//  RNIInternalCleanupMode.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 10/29/22.
//

import Foundation

@available(*, deprecated, message: "Use `RNIViewCleanupMode` instead")
public protocol RNIInternalCleanupMode {

  var cleanupMode: RNICleanupMode { get };
};
