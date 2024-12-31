//
//  UIViewAnimatingPosition+InitializableFromString.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/31/24.
//
import UIKit
import DGSwiftUtilities


extension UIViewAnimatingPosition: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "end":
        self = .end;
        
      case "start":
        self = .start;
        
      case "current":
        self = .current;
        
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
