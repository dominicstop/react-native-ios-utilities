//
//  RNIContentViewDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit
import DGSwiftUtilities


@objc
public protocol RNIContentViewDelegate:
  RNIViewPropDelegate where Self: UIView  {
  
  typealias PromiseCompletionBlock = (_ args: NSDictionary) -> Void;
  typealias PromiseRejectionBlock = (_ errorMessage: String) -> Void;
  
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
  optional func notifyOnViewCommandRequest(
    sender: RNIContentViewParentDelegate,
    forCommandName commandName: String,
    withCommandArguments commandArguments: NSDictionary,
    resolve resolveBlock: @escaping PromiseCompletionBlock,
    reject rejectBlock: @escaping PromiseRejectionBlock
  );
  
  // MARK: - Fabric Only
  // -------------------
  
  #if RCT_NEW_ARCH_ENABLED  
  @objc
  optional func shouldRecycleContentDelegate(
    sender: RNIContentViewParentDelegate
  ) -> Bool;
  #endif
  
  // MARK: Internal-Only
  // -------------------
  
  @objc
  optional func _notifyOnRequestToSetupConstraints(
    sender: RNIContentViewParentDelegate
  );
};

