//
//  RNIContentView+Default.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/14/24.
//

import Foundation
import DGSwiftUtilities


public extension RNIContentViewDelegate where Self: RNIContentView  {

  #if !RCT_NEW_ARCH_ENABLED
  var horizontalAlignment: HorizontalAlignmentPosition {
    .stretchTarget
  };
  
  var verticalAlignment: VerticalAlignmentPosition {
    .stretchTarget
  };
  #endif
};
