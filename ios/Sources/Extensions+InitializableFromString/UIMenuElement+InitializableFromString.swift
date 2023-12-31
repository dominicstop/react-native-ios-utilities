//
//  UIMenuElement+InitializableFromString.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 11/12/21.
//

import UIKit
import DGSwiftUtilities

@available(iOS 13, *)
extension UIMenuElement.Attributes: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "hidden":
        self = .hidden;
        
      case "disabled":
        self = .disabled;
        
      case "destructive":
        self = .destructive;
        
      #if !targetEnvironment(macCatalyst)
      #if swift(>=5.7)
      case "keepsMenuPresented":
        guard #available(iOS 16.0, *) else {
          throw RNIUtilitiesError(
            errorCode: .invalidArgument,
            description: "Not supported on iOS 15 and below",
            extraDebugValues: [
              "string": string,
            ]
          );
        };
        
        self = .keepsMenuPresented
      #endif
      #endif
      
      default:
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Invalid string value",
          extraDebugValues: [
            "string": string,
          ]
        );
    };
  };
};

@available(iOS 13, *)
extension UIMenuElement.State: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "on":
        self = .on;
        
      case "off":
        self = .off;
        
      case "mixed":
        self = .mixed;
        
      default:
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Invalid string value",
          extraDebugValues: [
            "string": string,
          ]
        );
    };
  };
};
