//
//  RNIViewPropUpdatesNotifiable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/9/24.
//

import Foundation


@objc
public protocol RNIViewPropUpdatesNotifiable {
  
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
};
