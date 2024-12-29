//
//  NumericLogicalExpression+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation
import DGSwiftUtilities


extension NumericLogicalExpression: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString: String = try dict.getValue(forKey: "mode");
    
    switch modeString {
      case "any":
        self = .any;
        
      case "isLessThan":
        let value = try dict.getValueAndCast(
          forKey: "toValue",
          type: T.self
        );
        
        self = .isLessThan(toValue: value);
        
      case "isLessThanOrEqual":
        let value = try dict.getValueAndCast(
          forKey: "toValue",
          type: T.self
        );
        
        self = .isLessThanOrEqual(toValue: value);
        
      case "isEqual":
        let value = try dict.getValueAndCast(
          forKey: "toValue",
          type: T.self
        );
        
        self = .isEqual(toValue: value);
        
      case "isGreaterThan":
        let value = try dict.getValueAndCast(
          forKey: "toValue",
          type: T.self
        );
        
        self = .isGreaterThan(toValue: value);
        
      case "isGreaterThanOrEqual":
        let value = try dict.getValueAndCast(
          forKey: "toValue",
          type: T.self
        );
        
        self = .isGreaterThanOrEqual(toValue: value);
        
      case "isBetweenRange":
        let start = try dict.getValueAndCast(
          forKey: "start",
          type: T.self
        );
        
        let end = try dict.getValueAndCast(
          forKey: "end",
          type: T.self
        );
        
        let isInclusive = try dict.getValueAndCast(
          forKey: "toValue",
          type: Bool.self
        );
        
        self = .isBetweenRange(
          start: start,
          end: end,
          isInclusive: isInclusive
        );
        
      default:
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Invalid value for modeString",
          extraDebugValues: [
            "modeString": modeString
          ]
        );
    };
  };
};
