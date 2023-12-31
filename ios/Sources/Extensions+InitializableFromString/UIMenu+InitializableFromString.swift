//
//  UIMenu+InitializableFromString.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 11/12/21.
//

import UIKit
import DGSwiftUtilities

@available(iOS 13, *)
extension UIMenu.Options: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "destructive":
        self = .destructive;
        
      case "displayInline":
        self = .displayInline;
      
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

#if !targetEnvironment(macCatalyst)
#if swift(>=5.7)
@available(iOS 16, *)
extension UIMenu.ElementSize: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "small":
        self = .small;
        
      case "medium":
        self = .medium;
        
      case "large":
        self = .large;
        
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
#endif
#endif
