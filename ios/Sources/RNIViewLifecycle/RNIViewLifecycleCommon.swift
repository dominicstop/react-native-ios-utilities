//
//  RNIViewLifecycleCommon.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/8/24.
//

import Foundation


@objc
public protocol RNIViewLifecycleCommon {
  @objc
  optional func notifyOnInit(
    sender: RNIContentViewParentDelegate
  );
  
  @objc
  optional func notifyOnRequestToSetupLayout(
    sender: RNIContentViewParentDelegate
  );
  
  @objc
  optional func notifyOnMountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  );
  
  @objc
  optional func notifyOnUnmountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  );
  
  @objc
  optional func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  );
};
