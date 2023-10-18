//
//  RNICleanable.swift
//  react-native-ios-popover
//
//  Created by Dominic Go on 3/13/22.
//

import Foundation

/// When a class implements this protocol, it means that the class has
/// some "clean-up" related code.
///
public protocol RNICleanable: AnyObject {
  
  func cleanup();
  
};
