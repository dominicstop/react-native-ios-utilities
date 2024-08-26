//
//  RNIViewPropDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation
import DGSwiftUtilities


@objc
public protocol RNIViewPropDelegate {
  
  typealias KeyPathRoot = Self;
  
  // MARK: Fabric + Paper
  // --------------------
  
  @objc
  var reactProps: NSDictionary { set get };
  
  @objc
  weak var parentReactView: RNIContentViewParentDelegate? { set get };
  
  @objc
  optional func notifyDidSetProps(
    sender: RNIContentViewParentDelegate
  );
  
  // MARK: Fabric Only
  // -----------------
  
  #if RCT_NEW_ARCH_ENABLED
  @objc
  optional func notifyOnUpdateProps(
    sender: RNIContentViewParentDelegate,
    oldProps: NSDictionary,
    newProps: NSDictionary
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
  
  // MARK: - Internal Only
  // ---------------------
  
  #if RCT_NEW_ARCH_ENABLED
  @objc
  optional func _notifyOnRequestToSetProps(
    sender: RNIContentViewParentDelegate,
    props: NSDictionary
  );
  #else
  
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
