//
//  RNIDetachedViewContentTargetMode.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 1/8/24.
//

import Foundation

public enum RNIDetachedViewContentTargetMode: String {
  /// The subview is the "content"
  case subview;
  
  /// The `RNIDetachedView` itself is the "content"
  case wrapper;
};
