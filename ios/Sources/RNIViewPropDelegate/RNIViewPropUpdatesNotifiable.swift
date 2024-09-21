//
//  RNIViewPropUpdatesNotifiable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/9/24.
//

import Foundation


public protocol RNIViewPropUpdatesNotifiable {
  
  func notifyDidSetProps(
    sender: RNIContentViewParentDelegate
  );
  
  // MARK: - Fabric Only
  // -------------------
  
  #if RCT_NEW_ARCH_ENABLED
  func notifyOnUpdateProps(
    sender: RNIContentViewParentDelegate,
    oldProps: NSDictionary,
    newProps: NSDictionary
  );
  #else
  
  // MARK: - Paper-Only
  // ------------------
  
  func notifyDidSetProps(
    sender: RNIContentViewParentDelegate,
    changedProps: Array<String>
  );
  #endif
};


public extension RNIViewPropUpdatesNotifiable {

  func notifyDidSetProps(
    sender: RNIContentViewParentDelegate
  ) {
    // no-op
  };
  
  // MARK: Fabric Only
  // -----------------
  
  #if RCT_NEW_ARCH_ENABLED
  func notifyOnUpdateProps(
    sender: RNIContentViewParentDelegate,
    oldProps: NSDictionary,
    newProps: NSDictionary
  ) {
    // no-op
  };
  #else
  
  // MARK: - Paper-Only
  // ------------------
  
  func notifyDidSetProps(
    sender: RNIContentViewParentDelegate,
    changedProps: Array<String>
  ) {
    // no-op
  };
  #endif
};
