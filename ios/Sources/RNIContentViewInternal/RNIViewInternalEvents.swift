//
//  RNIViewInternalEvents.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/10/24.
//

import Foundation


public protocol RNIViewInternalEvents {
  
  static var onRawNativeEvent: Self { get };

};
