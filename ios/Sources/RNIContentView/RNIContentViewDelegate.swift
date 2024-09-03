//
//  RNIContentViewDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit
import DGSwiftUtilities

@objc
public protocol RNIContentViewDelegate: RNIViewPropDelegate where Self: UIView  {
  
  // MARK: - Fabric + Paper
  // ----------------------
  
  @available(*, deprecated, renamed: "createInstance")
  @objc
  optional static func instanceMaker(
    sender: RNIContentViewParentDelegate,
    frame: CGRect
  ) -> RNIContentViewDelegate;
  
  @objc
  optional static func createInstance(
    sender: RNIContentViewParentDelegate,
    frame: CGRect
  ) -> RNIContentViewDelegate;
  
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
  
  @objc
  optional func notifyOnViewCommandRequest(
    sender: RNIContentViewParentDelegate,
    forCommandName commandName: String,
    withCommandArguments commandArguments: NSDictionary,
    resolve resolveBlock: (NSDictionary) -> Void,
    reject rejectBlock: (String) -> Void
  );
  
  // MARK: - Fabric Only
  // -------------------
  
  #if RCT_NEW_ARCH_ENABLED
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
  
  @objc
  optional func shouldRecycleContentDelegate(
    sender: RNIContentViewParentDelegate
  ) -> Bool;
  #else
  
  // MARK: - Paper Only
  // ------------------
  
  @objc
  optional func notifyOnViewWillInvalidate(
    sender: RNIContentViewParentDelegate
  );
  
  // MARK: - Paper Only (Debug)
  // --------------------------
  
  /// Note: Only gets invoked in paper for some reason
  @objc
  optional func notifyOnBridgeWillReload(
    sender: RNIContentViewParentDelegate,
    notification: Notification
  );
  #endif
  
  // MARK: Internal-Only
  // -------------------
  
  @objc
  optional func _notifyOnRequestToSetupConstraints(
    sender: RNIContentViewParentDelegate
  );
};

