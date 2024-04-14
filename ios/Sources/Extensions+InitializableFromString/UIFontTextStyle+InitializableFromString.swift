//
//  UIFontTextStyle+InitializableFromString.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 4/14/24.
//

import UIKit
import DGSwiftUtilities


extension UIFont.TextStyle: InitializableFromString {
  
  public init(fromString string: String) throws {
    switch string {
      case "body":
        self = .body;
        
      case "callout":
        self = .callout;
        
      case "caption1":
        self = .caption1;
        
      case "caption2":
        self = .caption2;
        
      case "footnote":
        self = .footnote;
        
      case "headline":
        self = .headline;
        
      case "subheadline":
        self = .subheadline;
        
      case "largeTitle":
        self = .largeTitle;
        
      case "extraLargeTitle":
        guard #available(iOS 17.0, *) else {
          throw RNIUtilitiesError(
            errorCode: .guardCheckFailed,
            description: "Not supported",
            extraDebugValues: [
              "string": string,
            ]
          );
        };
        
        self = .extraLargeTitle;
        
      case "extraLargeTitle2":
        guard #available(iOS 17.0, *) else {
          throw RNIUtilitiesError(
            errorCode: .guardCheckFailed,
            description: "Not supported",
            extraDebugValues: [
              "string": string,
            ]
          );
        };
        
        self = .extraLargeTitle2;
        
      case "title1":
        self = .title1;
        
      case "title2":
        self = .title2;
        
      case "title3":
        self = .title3;
      
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
