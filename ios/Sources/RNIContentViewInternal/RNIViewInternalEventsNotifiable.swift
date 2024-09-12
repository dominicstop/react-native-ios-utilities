//
//  RNIViewInternalEventsNotifiable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/13/24.
//

import Foundation


public protocol RNIViewInternalEventsNotifiable: AnyObject {
  
  func notifyOnPropsForNativeDidChange(
    oldValue: NSDictionary?,
    newValue: NSDictionary?
  );
};
