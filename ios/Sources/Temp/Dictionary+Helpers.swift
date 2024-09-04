//
//  Dictionary+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/5/24.
//

import Foundation
import DGSwiftUtilities

public extension Dictionary where Key == String {
  
  func getValueFromDictionary<T>(
    forKey key: String,
    type: T.Type = T.self,
    fallbackValue: T
  ) -> T {
  
    let value = try? self.getValueFromDictionary(
      forKey: key,
      type: type
    );
    
    return  value ?? fallbackValue;
  };
  
  func getValueFromDictionary<T: RawRepresentable, U>(
    forKey key: String,
    type: T.Type = T.self,
    rawValueType: U.Type = T.RawValue.self
  ) throws -> T where T: RawRepresentable<U> {
  
    let rawValue = try? self.getValueFromDictionary(
      forKey: key,
      type: U.self
    );
    
    guard let rawValue = rawValue else {
      throw GenericError(
        errorCode: .typeCastFailed,
        description: "Unable to cast value to RawRepresentable.RawValue type",
        extraDebugValues: [
          "key": key,
          "type": type.self,
          "rawValueType": U.self,
        ]
      );
    };
    
    let value = T.init(rawValue: rawValue);
    guard let value = value else {
      throw GenericError(
        errorCode: .invalidValue,
        description: "No matching value in enum",
        extraDebugValues: [
          "key": key,
          "type": type.self,
          "rawValueType": U.self,
        ]
      );
    };
    
    return value;
  };
  
  func getValueFromDictionary<T: RawRepresentable, U>(
    forKey key: String,
    type: T.Type = T.self,
    rawValueType: U.Type = T.RawValue.self,
    fallbackValue: T
  ) -> T where T: RawRepresentable<U> {
  
    let enumValue = try? self.getValueFromDictionary(
      forKey: key,
      type: T.self,
      rawValueType: U.self
    );
    
    guard let enumValue = enumValue else {
      return fallbackValue;
    };
    
    return enumValue;
  };
};
