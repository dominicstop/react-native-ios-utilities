//
//  UIViewAnimate+InitializableFromString.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 6/18/22.
//

import UIKit
import DGSwiftUtilities

extension UIView.AnimationOptions: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "curveEaseIn":
        self = .curveEaseIn;
        
      case "curveEaseOut":
        self = .curveEaseOut;
        
      case "curveEaseInOut":
        self = .curveEaseInOut;
        
      case "curveLinear":
        self = .curveLinear;
        
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
