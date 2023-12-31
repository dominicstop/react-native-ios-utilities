//
//  UIImage+InitializableFromString.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 10/2/21.
//

import UIKit
import DGSwiftUtilities

extension UIImage.RenderingMode: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "automatic":
        self = .automatic;
        
      case "alwaysOriginal":
        self = .alwaysOriginal;
        
      case "alwaysTemplate":
        self = .alwaysTemplate;
        
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



@available(iOS 13.0, *)
extension UIImage.SymbolWeight: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "unspecified":
        self = .unspecified;
        
      case "ultraLight":
        self = .ultraLight;
        
      case "thin":
        self = .thin;
        
      case "light":
        self = .light;
        
      case "regular":
        self = .regular;
        
      case "medium":
        self = .medium;
        
      case "semibold":
        self = .semibold;
        
      case "bold":
        self = .bold;
        
      case "heavy":
        self = .heavy;
        
      case "black":
        self = .black;

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

@available(iOS 13.0, *)
extension UIImage.SymbolScale: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "default"    : self = .`default`;
      case "unspecified": self = .unspecified;
      case "small"      : self = .small;
      case "medium"     : self = .medium;
      case "large"      : self = .large;

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
