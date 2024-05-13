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
  func notifyOnRequestToSetProps(
    sender: RNIContentViewParentDelegate,
    props: NSDictionary
  ) {
    guard let _self = self as? (any RNIContentView) else { return };
    _self.setValues(withDict: props);
  };
  #endif
};

