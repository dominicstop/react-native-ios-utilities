//
//  RNIContentViewParentDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit
import React


#if RCT_NEW_ARCH_ENABLED
public typealias RNIContentViewParent = UIView
#else
public typealias RNIContentViewParent = RCTView;
#endif

@objc(RNIContentViewParentDelegateSwift)
public protocol RNIContentViewParentDelegate where Self: RNIContentViewParent {

  var cachedLayoutMetrics: RNILayoutMetrics { get };
  
  var reactSubviews: [UIView] { get }
  
  func requestToRemoveReactSubview(_ subview: UIView);
  
  func setSize(_ size: CGSize);
  
  func dispatchViewEvent(
    forEventName eventName: String,
    withPayload payload: Dictionary<String, Any>
  );
  
  // MARK: Fabric Only
  // -----------------
  
  #if RCT_NEW_ARCH_ENABLED
  func setPadding(_ insets: UIEdgeInsets);
  
  func setPositionType(_ positionType: RNILayoutMetrics.RNIPositionType);
  #endif
};
