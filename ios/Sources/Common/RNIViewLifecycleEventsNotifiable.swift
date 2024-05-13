//
//  RNIViewLifecycleEventsNotifiable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit


@objc
public protocol RNIViewLifecycleEventsNotifiable where Self: UIView  {
  typealias KeyPathRoot = Self;
  
  @objc
  var reactProps: NSDictionary { set get }
  
  @objc
  optional func notifyOnInit(
    sender: RNIViewLifecycleEventsNotifying
  );
  
  @objc
  optional func notifyOnMountChildComponentView(
    sender: RNIViewLifecycleEventsNotifying,
    childComponentView: UIView,
    index: NSInteger
  );
  
  @objc
  optional func notifyOnUnmountChildComponentView(
    sender: RNIViewLifecycleEventsNotifying,
    childComponentView: UIView,
    index: NSInteger
  );
  
  @objc
  optional func notifyOnUpdateProps(
    sender: RNIViewLifecycleEventsNotifying,
    oldProps: NSDictionary,
    newProps: NSDictionary
  );
  
  @objc
  optional func notifyOnUpdateState(
    sender: RNIViewLifecycleEventsNotifying,
    oldState: NSDictionary?,
    newState: NSDictionary
  );
  
  @objc
  optional func notifyOnUpdateLayoutMetrics(
    sender: RNIViewLifecycleEventsNotifying,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  );
  
  @objc
  optional func notifyOnFinalizeUpdates(
    sender: RNIViewLifecycleEventsNotifying,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  );
  
  @objc
  optional func notifyOnPrepareForReuse(
    sender: RNIViewLifecycleEventsNotifying
  );
};
