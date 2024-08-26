//
//  RNIViewPropDelegate+Default.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation


@objc
fileprivate extension UIView {
  
  #if RCT_NEW_ARCH_ENABLED
  // @objc(_RNIViewPropDelegate_notifyOnRequestToSetPropsWithSender:props:)
  func _notifyOnRequestToSetProps(
    sender: RNIContentViewParentDelegate,
    props: NSDictionary
  ) {
    guard let _self = self as? (any RNIContentView) else { return };
    _self.setValues(withDict: props);
  };
  #endif
};
