//
//  Dictionary+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/29/24.
//

import UIKit
import DGSwiftUtilities


public extension Dictionary where Key == String {

  func getTransform(forKey key: String) throws -> Transform3D {
    guard let transformDict = try? self.getDict(forKey: key) else {
      throw GenericError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value from dictionary for key",
        extraDebugValues: [
          "key": key,
        ]
      );
    };
        
    return .init(fromDict: transformDict);
  };
  
  func getSize(forKey key: String) throws -> CGSize {
    guard let sizeDict = try? self.getDict(forKey: key) else {
      throw GenericError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get value from dictionary for key",
        extraDebugValues: [
          "key": key,
        ]
      );
    };
        
    return try .init(fromDict: sizeDict);
  };
};
