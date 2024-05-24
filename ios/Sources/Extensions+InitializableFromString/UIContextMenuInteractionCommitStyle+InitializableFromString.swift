//
//  UIContextMenuInteractionCommitStyle+InitializableFromString.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 11/12/21.
//

import UIKit
import DGSwiftUtilities

@available(iOS 13.0, *)
extension UIContextMenuInteractionCommitStyle: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "dismiss":
        self = .dismiss;
        
      case "pop":
        self = .pop;
      
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
