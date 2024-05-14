//
//  RNIContentViewDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit
import DGSwiftUtilities

@objc
public protocol RNIContentViewDelegate where Self: UIView  {
  typealias KeyPathRoot = Self;
  
  // MARK: Fabric + Paper
  // --------------------
  
  @objc
  optional func notifyOnInit(
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
  
  // MARK: Fabric Only
  // -----------------
  
  
  #if RCT_NEW_ARCH_ENABLED
  
  @objc
  var reactProps: NSDictionary { set get }
  
  @objc
  optional func notifyOnUpdateProps(
    sender: RNIContentViewParentDelegate,
    oldProps: NSDictionary,
    newProps: NSDictionary
  );
  
  @objc
  optional func notifyOnUpdateState(
    sender: RNIContentViewParentDelegate,
    oldState: NSDictionary?,
    newState: NSDictionary
  );
  
  @objc
  optional func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
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
  #endif
  
  // MARK: Internal-Only
  // -------------------
  
  #if RCT_NEW_ARCH_ENABLED
  @objc
  optional func _notifyOnRequestToSetProps(
    sender: RNIContentViewParentDelegate,
    props: NSDictionary
  );
  #else
  @objc
  optional func _notifyOnRequestToSetupConstraints(
    sender: RNIContentViewParentDelegate
  );
  #endif
};

