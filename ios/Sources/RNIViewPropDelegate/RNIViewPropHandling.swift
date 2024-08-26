//
//  RNIViewPropHandling.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation
import DGSwiftUtilities


public protocol RNIViewPropHandling where Self:
  RNIViewPropDelegate & StringKeyPathMapping {
  
  static var propKeyPathMap:
    Dictionary<String, PartialKeyPath<KeyPathRoot>> { get };
    
  associatedtype Events: RawRepresentable<String> & CaseIterable;
};
