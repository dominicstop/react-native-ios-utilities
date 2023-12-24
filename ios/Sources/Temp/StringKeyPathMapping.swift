//
//  StringKeyPathMapping.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/24/23.
//

import Foundation

// TODO: Move to `DGSwiftUtilities`
public protocol StringKeyPathMapping {
  
  static var stringToKeyPathMap: Dictionary<String, PartialKeyPath<Self>> { get };
};

extension StringKeyPathMapping {

  static func getKeyPath<T>(
    forKey stringKey: String,
    type: T.Type
  ) throws -> KeyPath<Self, T> {
  
    guard let value = Self.stringToKeyPathMap[stringKey] else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "No matching key path value for string key",
        extraDebugValues: [
          "stringKey": stringKey,
        ]
      );
    };
    
    guard let keyPath = value as? KeyPath<Self, T> else {
      throw RNIUtilitiesError(
        errorCode: .typeCastFailed,
        description: "Unable to cast partial key path to target type ",
        extraDebugValues: [
          "stringKey": stringKey,
          "value": value,
          "targetType": String(describing: T.self),
        ]
      );
    };
    
    return keyPath;
  };
};
