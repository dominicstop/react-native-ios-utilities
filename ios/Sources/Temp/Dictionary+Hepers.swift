//
//  Dictionary+Hepers.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/22/23.
//

import Foundation
import DGSwiftUtilities

// TODO: Move to `DGSwiftUtilities`
public extension Dictionary where Key == String {
  
  func getValueFromDictionary<T>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
  
    let dictValue = self[key];
    
    guard let dictValue = dictValue else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value from dictionary for key",
        extraDebugValues: [
          "key": key
        ]
      );
    };
    
    guard let value = dictValue as? T else {
      throw RNIUtilitiesError(
        errorCode: .typeCastFailed,
        description: "Unable to parse value from dictionary for key",
        extraDebugValues: [
          "key": key,
          "dictValue": dictValue,
        ]
      );
    };
    
    return value;
  };
  
  func getValueFromDictionary<T: InitializableFromDictionary>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
  
    let dictValue = try self.getValueFromDictionary(
      forKey: key,
      type: Dictionary<String, Any>.self
    );
    
    return try T.init(fromDict: dictValue);
  };
  
  func getValueFromDictionary<T: InitializableFromString>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
  
    let dictValue = try self.getValueFromDictionary(
      forKey: key,
      type: String.self
    );
    
    return try T.init(fromString: dictValue);
  };
  
  func getEnumFromDictionary<T: RawRepresentable<String>>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
  
    let dictValue: String = try self.getValueFromDictionary(forKey: key);
    
    guard let value = T(rawValue: dictValue) else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to convert string from dictionary to enum",
        extraDebugValues: [
          "key": key,
          "dictValue": dictValue
        ]
      );
    };
    
    return value;
  };
  
  func getEnumFromDictionary<
    T: EnumCaseStringRepresentable & CaseIterable
  >(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
  
    let dictValue: String = try self.getValueFromDictionary(forKey: key);
    
    guard let value = T(fromString: dictValue) else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to convert string from dictionary to enum",
        extraDebugValues: [
          "key": key,
          "dictValue": dictValue
        ]
      );
    };
    
    return value;
  };
  
  func getKeyPathFromDictionary<
    KeyPathRoot: StringKeyPathMapping,
    KeyPathValue
  >(
    forKey key: String,
    rootType: KeyPathRoot.Type,
    valueType: KeyPathValue.Type
  ) throws -> KeyPath<KeyPathRoot, KeyPathValue> {
  
    let dictValue: String = try self.getValueFromDictionary(forKey: key);
    
    return try KeyPathRoot.getKeyPath(
      forKey: dictValue,
      valueType: KeyPathValue.self
    );
  };
};
