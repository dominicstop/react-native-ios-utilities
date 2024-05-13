//
//  RNIContentViewDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit


@objc
public protocol RNIContentViewDelegate where Self: UIView  {
  typealias KeyPathRoot = Self;
  
  @objc
  var reactProps: NSDictionary { set get }
  
  @objc
  optional func notifyOnInit(
    sender: RNIContentViewParentDelegate
  );
  
  @objc
  optional func notifyOnMountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger
  );
  
  @objc
  optional func notifyOnUnmountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger
  );
  
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
};
