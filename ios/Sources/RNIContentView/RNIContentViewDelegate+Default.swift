//
//  RNIContentViewDelegate+Default.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/13/24.
//

import UIKit
import DGSwiftUtilities


@objc
fileprivate extension UIView {
  
  #if RCT_NEW_ARCH_ENABLED
  // @objc(_RNIContentViewDelegate_notifyOnRequestToSetPropsWithSender:props:)
  func _notifyOnRequestToSetProps(
    sender: RNIContentViewParentDelegate,
    props: NSDictionary
  ) {
    guard let _self = self as? (any RNIContentView) else { return };
    _self.setValues(withDict: props);
  };
  #else
  func _notifyOnRequestToSetupConstraints(
    sender: RNIContentViewParentDelegate
  ) {
    guard let _self = self as? (any RNIContentView) else { return };
    
    _self.translatesAutoresizingMaskIntoConstraints = false;
    sender.addSubview(_self);
    
    var constraints: [NSLayoutConstraint] = [];
  
    constraints += _self.horizontalAlignment.createHorizontalConstraints(
      forView: _self,
      attachingTo: sender,
      enclosingView: sender,
      preferredWidth: nil
    );
    
    constraints += _self.verticalAlignment.createVerticalConstraints(
      forView: _self,
      attachingTo: sender,
      enclosingView: sender,
      preferredHeight: nil
    );
    
    NSLayoutConstraint.activate(constraints);
  };
  
  func _getSupportedReactEvents() -> [String] {
    guard let _self = self as? (any RNIContentView) else {
      return [];
    };
    
    return _self.allSupportedEventsAsStrings;
  };
  
  func _getSupportedReactProps() -> [String] {
    guard let _self = self as? (any RNIContentView) else {
      return [];
    };
    
    return _self.allSupportedPropsAsStrings;
  };
  #endif
};

