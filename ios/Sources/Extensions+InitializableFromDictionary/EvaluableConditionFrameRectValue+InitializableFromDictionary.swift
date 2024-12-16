//
//  EvaluableConditionFrameRectValue+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation
import DGSwiftUtilities
import ComputableLayout

extension EvaluableConditionFrameRectValue: InitializableFromDictionary {
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString: String = try dict.getValue(forKey: "mode");
    
    switch modeString {
      case "window":
        self = .window;
        
      case "targetView":
        self = .targetView;
        
      case "statusBar":
        self = .statusBar;
        
      case "custom":
        let value = try dict.getValue(
          forKey: "value",
          type: CGRect.self
        );
        
        self = .custom(value);
        
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
