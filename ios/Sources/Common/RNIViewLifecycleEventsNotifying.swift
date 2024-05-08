//
//  RNIViewLifecycleEventsNotifying.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit

@objc
public protocol RNIViewLifecycleEventsNotifying where Self: UIView  {

  var cachedLayoutMetrics: RNILayoutMetrics { get };
  
  func setSize(_: CGSize);
};
