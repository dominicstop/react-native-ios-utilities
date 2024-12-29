//
//  ComputableLayoutPreset+InitializableFromDictionary.swift
//  ReactNativeIosAdaptiveModal
//
//  Created by Dominic Go on 1/2/24.
//

import UIKit
import DGSwiftUtilities
import ComputableLayout


extension ComputableLayoutPreset: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString = try dict.getString(forKey: "mode");
    
    switch modeString {
      case "preset":
        let presetString = try dict.getString(forKey: "preset");
        self = try .init(fromString: presetString);
        
      case "layoutConfig":
        let value = try dict.getValue(
          forKey: "value",
          type: ComputableLayout.self
        );
        
        self = .layoutConfig(value);
        
      default:
        throw RNIUtilitiesError(
          errorCode: .invalidValue,
          description: "Invalid string value for mode",
          extraDebugValues: [
            "dict": dict,
            "modeString": modeString,
          ]
        );
    };
  };
};

// MARK: - Dictionary+ComputableLayoutPreset
// -----------------------------------------

public extension Dictionary where Key == String {
  
  func getComputableLayoutPreset(forKey key: String) throws -> ComputableLayoutPreset {
    let dictConfig = try self.getDict(forKey: key)
    return try .init(fromDict: dictConfig);
  };
  
  func getValue(forKey key: String) throws -> ComputableLayoutPreset {
    try self.getComputableLayoutPreset(forKey: key);
  };
};
