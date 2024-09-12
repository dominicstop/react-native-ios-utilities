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
  
  typealias PropKeyPathMap = Dictionary<String, PartialKeyPath<KeyPathRoot>>;
  
  associatedtype Events: RawRepresentable<String> & CaseIterable;
  
  static var propKeyPathMap: PropKeyPathMap { get };
  
  static var propKeyPathMapInternal: PropKeyPathMap? { get };
};
