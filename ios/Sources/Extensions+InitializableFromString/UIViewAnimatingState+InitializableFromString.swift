//
//  UIViewAnimatingState+InitializableFromString.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/31/24.
//

import UIKit
import DGSwiftUtilities


extension UIViewAnimatingState: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "active":
        self = .active;
        
      case "inactive":
        self = .inactive;
        
      case "stopped":
        self = .stopped;

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
