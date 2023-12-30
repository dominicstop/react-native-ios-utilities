//
//  InitializableFromString.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation

// TODO: Move to `DGSwiftUtilities`
public protocol InitializableFromString {
  
  init(fromString string: String) throws;
};

extension RawRepresentable where RawValue == String {
  
  init(fromString string: String) throws {
    guard let value = Self.init(rawValue: string) else {
      throw RNIUtilitiesError(
        errorCode: .invalidArgument,
        description: "Invalid string value",
        extraDebugValues: [
          "string": string
        ]
      );
    };
    
    self = value;
  };
};

extension InitializableFromString {
  
  // For backwards compatibility
  @available(*, deprecated, message: "Please use init(fromString:) instead...")
  init?(string: String){
    guard let value = try? Self.init(fromString: string) else { return nil };
    self = value;
  };
};
