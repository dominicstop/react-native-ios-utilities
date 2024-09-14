//
//  VerticalAlignmentPosition+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/15/24.
//

import Foundation
import DGSwiftUtilities


public extension VerticalAlignmentPosition {
  
  var isStretching: Bool {
       self == .stretch
    || self == .stretchTarget;
  };
};
