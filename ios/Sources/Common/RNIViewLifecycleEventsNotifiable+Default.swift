//
//  RNIViewLifecycleEventsNotifiable+Default.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/13/24.
//

import DGSwiftUtilities


public extension RNIViewLifecycleEventsNotifiable where Self: StringKeyPathMapping {
  
  func notifyOnUpdateProps(
    sender: RNIViewLifecycleEventsNotifying,
    oldProps: NSDictionary,
    newProps: NSDictionary
  ) {
    self.setValues(withDict: newProps);
  };
};
