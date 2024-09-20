//
//  RNIViewLifecycleCommon.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation


@objc(RNIViewLifecycleCommonSwift)
public protocol RNIViewLifecycleCommon {

  @objc
  optional func notifyOnInit(
    sender: RNIContentViewParentDelegate
  );
  
  @objc
  optional func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  );
  
  @objc
  optional func notifyOnRequestForCleanup(
    sender: RNIContentViewParentDelegate
  );
};
