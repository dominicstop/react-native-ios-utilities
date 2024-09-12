//
//  RNIViewPropHandling+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation


public extension RNIViewPropHandling where Self: RNIViewPropDelegate  {
  
  // MARK: TODO - Impl. caching
  static var propKeyPathMapCombined: PropKeyPathMap {
    if let propKeyPathMapInternal = Self.propKeyPathMapInternal {
      return Self.propKeyPathMap.merging(propKeyPathMapInternal) { (current, _) in
        return current;
      };
    };
    
    return Self.propKeyPathMap;
  };
  
  var allSupportedEventsAsStrings: [String] {
    Self.Events.allCases.map {
      $0.rawValue;
    };
  };
  
  var allSupportedPropsAsStrings: [String] {
    Self.propKeyPathMapCombined.map {
      $0.key;
    };
  };
  
  var allSupportedPropsTypeMap: [String: String] {
    Self.propKeyPathMapCombined.reduce(into: [:]) { (result, tuple) in
      result[tuple.key] = tuple.value.valueTypeAsString;
    }
  };

  func dispatchEvent(
    for event: Events,
    withPayload payload: Dictionary<String, Any>
  ){
    guard let parentReactView = self.parentReactView else {
      return;
    };
    
    parentReactView.dispatchViewEvent(
      forEventName: event.rawValue,
      withPayload: payload
    );
  };
};
