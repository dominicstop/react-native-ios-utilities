//
//  ComputableLayoutValueEvaluableCondition+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation
import DGSwiftUtilities
import ComputableLayout

extension ComputableLayoutValueEvaluableCondition: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString: String = try dict.getValue(forKey: "mode");
    
    switch modeString {
      case "isNilOrZero":
        let value = try dict.getValue(
          forKey: "value",
          type: ComputableLayoutValueMode.self
        );
      
        self = .isNilOrZero(value);
        
      case "keyboardPresent":
        self = .keyboardPresent;
    
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
