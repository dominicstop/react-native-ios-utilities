//
//  EvaluableConditionSizeValue+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation
import DGSwiftUtilities
import ComputableLayout


extension EvaluableConditionSizeValue: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString: String = try dict.getValue(forKey: "mode");
    
    switch modeString {
      case "window":
        self = .window;
        
      case "screen":
        self = .screen;
        
      case "statusBar":
        self = .statusBar;
        
      case "targetView":
        self = .targetView;
        
      case "custom":
        let size = try dict.getValue(
          forKey: "value",
          type: CGSize.self
        );
        
        self = .custom(size)
        
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
