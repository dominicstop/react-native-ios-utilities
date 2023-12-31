//
//  CAGradientLayerType+InitialzableFromString.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 4/12/21.
//

import Foundation
import DGSwiftUtilities

extension CAGradientLayerType: InitializableFromString {

  public init(fromString string: String) throws {
    switch string {
      case "axial":
        self = .axial;
        
      case "radial":
        self = .radial;
        
      case "conic" :
        guard #available(iOS 12.0, *) else {
          throw RNIUtilitiesError(
            errorCode: .guardCheckFailed,
            description: "conic requires iOS 12+",
            extraDebugValues: [
              "string": string,
            ]
          );
        };
        
        self = .conic;
        
      default:
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Invalid string value",
          extraDebugValues: [
            "string": string,
          ]
        );
    }
  };
};
