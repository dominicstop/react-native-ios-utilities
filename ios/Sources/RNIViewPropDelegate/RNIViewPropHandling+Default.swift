//
//  RNIViewPropHandling+Default.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation
import DGSwiftUtilities


public extension RNIViewPropHandling where Self: RNIViewPropDelegate  {
  
  static var propKeyPathMapInternal: PropKeyPathMap? {
    return nil;
  };
  
  // MARK: - RNIViewPropHandling+StringKeyPathMapping
  // ------------------------------------------------
  
  static var partialKeyPathMap: Dictionary<String, PartialKeyPath<Self>> {
    return Self.propKeyPathMap;
  };
};
