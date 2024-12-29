//
//  Angle+InitializableFromDictionary.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import Foundation
import DGSwiftUtilities

extension Angle: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString = try dict.getString(forKey: "mode");
    
    switch modeString {
      case "zero":
        self = .zero;
        
      case "radians":
        let value = try dict.getValue(
          forKey: "value",
          type: T.self
        );
        
        self = .radians(value);
        
      case "degrees":
        let value = try dict.getValue(
          forKey: "value",
          type: T.self
        );
        
        self = .degrees(value);
    
      default:
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Invalid value for modeString",
          extraDebugValues: [
            "modeString": modeString
          ]
        );
    };
  };
};

// MARK: - Dictionary+CGSize
// -------------------------

public extension Dictionary where Key == String {
  
  func getAngle<T>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> Angle<T> {
  
    let angleDict = try self.getDict(forKey: key)
    return try .init(fromDict: angleDict);
  };
  
  func getValue(forKey key: String) throws -> Angle<CGFloat> {
    try self.getAngle(forKey: key);
  };
};
