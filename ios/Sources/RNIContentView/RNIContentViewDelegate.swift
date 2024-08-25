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
  optional static func instanceMaker(
    sender: RNIContentViewParentDelegate,
    frame: CGRect
  ) -> RNIContentViewDelegate;
  
  @objc
  var reactProps: NSDictionary { set get }
  
  @objc
  weak var parentReactView: RNIContentViewParentDelegate? { set get }
  
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
  
  @objc
  optional func notifyDidSetProps(
    sender: RNIContentViewParentDelegate
  );
  
  @objc
  optional func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  );
  
  @objc
  optional func notifyOnViewCommandRequest(
    sender: RNIContentViewParentDelegate,
    forCommandName commandName: String,
    withCommandArguments commandArguments: NSDictionary,
    resolve resolveBlock: (NSDictionary) -> Void,
    reject rejectBlock: (String) -> Void
  );
  
  // MARK: Fabric Only
  // -----------------
  
  @objc
  optional func shouldRecycleContentDelegate(
    sender: RNIContentViewParentDelegate
  ) -> Bool;
  
  #if RCT_NEW_ARCH_ENABLED
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
  optional func notifyOnFinalizeUpdates(
    sender: RNIContentViewParentDelegate,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  );
  
  @objc
  optional func notifyOnPrepareForReuse(
    sender: RNIContentViewParentDelegate
  );
  #else
  
  // MARK: - Paper-Only
  // ------------------
  
  @objc
  optional func notifyDidSetProps(
    sender: RNIContentViewParentDelegate,
    changedProps: Array<String>
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
  
  @objc
  optional func _getSupportedReactEvents() -> [String];
  
  @objc
  optional func _getSupportedReactProps() -> [String];
  
  @objc
  optional func _getSupportedReactPropsTypeMap() -> [String: String];
  
  @objc
  optional func _notifyOnRequestToSetProp(
    sender: RNIContentViewParentDelegate,
    propName: String,
    propValue: Any
  );
  #endif
};

