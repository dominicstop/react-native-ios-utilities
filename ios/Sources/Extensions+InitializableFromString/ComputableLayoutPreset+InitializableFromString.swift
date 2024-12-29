//
//  ComputableLayoutPreset+InitializableFromString.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/29/24.
//

import UIKit
import DGSwiftUtilities
import ComputableLayout


extension ComputableLayoutPreset: InitializableFromString {

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
        throw RNIUtilitiesError(
          errorCode: .invalidValue,
          description: "Invalid string value",
          extraDebugValues: [
            "string": string
          ]
        );
    };
  };
};
