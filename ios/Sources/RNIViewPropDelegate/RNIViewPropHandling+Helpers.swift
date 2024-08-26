//
//  RNIViewPropHandling+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation


public extension RNIViewPropHandling where Self: RNIViewPropDelegate  {
  
  var allSupportedEventsAsStrings: [String] {
    Events.allCases.map {
      $0.rawValue;
    };
  };
  
  var allSupportedPropsAsStrings: [String] {
    Self.propKeyPathMap.map {
      $0.key;
    };
  };
  
  var allSupportedPropsTypeMap: [String: String] {
    return Self.propKeyPathMap.reduce(into: [:]) { (result, tuple) in
      result[tuple.key] = tuple.value.valueTypeAsString;
    }
  };

  func dispatchEvent(
    for event: Events,
    withPayload payload: Dictionary<String, Any>
  ){
    self.parentReactView?.dispatchViewEvent(
      forEventName: event.rawValue,
      withPayload: payload
    );
  };
};
