//
//  UIViewAnimationCurve+InitializableFromString.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import Foundation
import DGSwiftUtilities

extension UIView.AnimationCurve: InitializableFromString {

  public init(fromString string: String) throws {
    let match = Self.allCases.first {
      $0.description == string;
    };
    
    guard let match = match else {
      throw RNIUtilitiesError(
        errorCode: .invalidArgument,
        description: "Invalid string value",
        extraDebugValues: [
          "string": string,
        ]
      );
    };
    
    self = match;
  };
};
