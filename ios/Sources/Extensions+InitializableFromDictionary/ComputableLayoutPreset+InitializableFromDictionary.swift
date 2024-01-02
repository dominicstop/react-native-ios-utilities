//
//  ComputableLayoutPreset+InitializableFromDictionary.swift
//  ReactNativeIosAdaptiveModal
//
//  Created by Dominic Go on 1/2/24.
//

import UIKit
import DGSwiftUtilities
import ComputableLayout
import AdaptiveModal


extension ComputableLayoutPreset: InitializableFromDictionary {

  public init(fromString string: String) throws {
    switch string {
      case "automatic":
        self = .automatic;
        
      case "offscreenBottom":
        self = .offscreenBottom;
        
      case "offscreenTop":
        self = .offscreenTop;
        
      case "offscreenLeft":
        self = .offscreenLeft;
        
      case "offscreenRight":
        self = .offscreenRight;
        
      case "halfOffscreenBottom":
        self = .halfOffscreenBottom;
        
      case "halfOffscreenTop":
        self = .halfOffscreenTop;
        
      case "halfOffscreenLeft":
        self = .halfOffscreenLeft;
        
      case "halfOffscreenRight":
        self = .halfOffscreenRight;
        
      case "edgeBottom":
        self = .edgeBottom;
        
      case "edgeTop":
        self = .edgeTop;
        
      case "edgeLeft":
        self = .edgeLeft;
        
      case "edgeRight":
        self = .edgeRight;
        
      case "fitScreen":
        self = .fitScreen;
        
      case "fitScreenHorizontally":
        self = .fitScreenHorizontally;
        
      case "fitScreenVertically":
        self = .fitScreenVertically;
        
      case "center":
        self = .center;
        
      default:
        throw RNIAdaptiveModalError(
          errorCode: .invalidValue,
          description: "Invalid string value",
          extraDebugValues: [
            "string": string
          ]
        );
    };
  };

  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString = try dict.getValueFromDictionary(
      forKey: "mode",
      type: String.self
    );
    
    switch modeString {
      case "preset":
        let presetString = try dict.getValueFromDictionary(
          forKey: "preset",
          type: String.self
        );
        
        self = try .init(fromString: presetString);
        
      case "layoutConfig":
        let value = try dict.getValueFromDictionary(
          forKey: "value",
          type: ComputableLayout.self
        );
        
        self = .layoutConfig(value);
        
      default:
        throw RNIAdaptiveModalError(
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
