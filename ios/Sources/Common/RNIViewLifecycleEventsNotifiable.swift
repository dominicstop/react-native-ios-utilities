//
//  RNIViewLifecycleEventsNotifiable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit


@objc
public protocol RNIViewLifecycleEventsNotifiable where Self: UIView  {

  @objc
  var reactProps: NSDictionary { set get }
  
  @objc
  optional func notifyOnInit(
    sender: RNIViewLifecycleEventsNotifying,
    frame: CGRect
  );
  
  @objc
  optional func notifyOnUpdateLayoutMetrics(
    sender: RNIViewLifecycleEventsNotifying,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  );
};
