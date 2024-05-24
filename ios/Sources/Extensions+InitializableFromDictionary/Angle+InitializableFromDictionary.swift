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
    let modeString = try dict.getValueFromDictionary(
      forKey: "mode",
      type: String.self
    );
    
    switch modeString {
      case "zero":
        self = .zero;
        
      case "radians":
        let value = try dict.getValueFromDictionary(
          forKey: "value",
          type: T.self
        );
        
        self = .radians(value);
        
      case "degrees":
        let value = try dict.getValueFromDictionary(
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
