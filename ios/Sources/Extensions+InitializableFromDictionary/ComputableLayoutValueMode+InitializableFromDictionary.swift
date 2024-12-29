//
//  ComputableLayoutValueMode+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/22/23.
//

import Foundation
import DGSwiftUtilities
import ComputableLayout


extension ComputableLayoutValueMode: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    
    let modeString: String = try dict.getValue(forKey: "mode");
    
    switch modeString {
      case "stretch":
        self = .stretch;
        
      case "constant":
        let value: CGFloat = try dict.getValue(forKey: "value");
        self = .constant(value);
        
      case "percent":
        let percentTarget = try? dict.getEnum(
          forKey: "relativeTo",
          type: ComputableLayoutValuePercentTarget.self
        );
        
        let percentValue: CGFloat =
          try dict.getValue(forKey: "percentValue");
        
        self = .percent(
          relativeTo: percentTarget ?? .targetSize,
          percentValue: percentValue
        );
        
      case "safeAreaInsets":
        let insetKey = try dict.getKeyPath(
          forKey: "insetKey",
          rootType: UIEdgeInsets.self,
          valueType: CGFloat.self
        );
        
        self = .safeAreaInsets(insetKey: insetKey);
        
      case "keyboardScreenRect":
        let rectKey = try dict.getKeyPath(
          forKey: "rectKey",
          rootType: CGRect.self,
          valueType: CGFloat.self
        );
        
        self = .keyboardScreenRect(rectKey: rectKey);
        
      case "keyboardRelativeSize":
        let sizeKey = try dict.getKeyPath(
          forKey: "sizeKey",
          rootType: CGSize.self,
          valueType: CGFloat.self
        );
        
        self = .keyboardRelativeSize(
          sizeKey: sizeKey
        );
        
      case "multipleValues":
        let valuesRaw = try dict.getArray(
          forKey: "values",
          elementType: Dictionary<String, Any>.self
        );
        
        let values = valuesRaw.compactMap {
          try? ComputableLayoutValueMode(fromDict: $0)
        };
        
        self = .multipleValues(values);
        
      case "conditionalLayoutValue":
        let condition = try dict.getValue(
          forKey: "condition",
          type: ComputableLayoutValueEvaluableCondition.self
        );
        
        let trueValue = try? dict.getValue(
          forKey: "trueValue",
          type: ComputableLayoutValueMode.self
        );
        
        let falseValue = try? dict.getValue(
          forKey: "falseValue",
          type: ComputableLayoutValueMode.self
        );
        
        self = .conditionalLayoutValue(
          condition: condition,
          trueValue: trueValue,
          falseValue: falseValue
        );
        
      case "conditionalValue":
        let condition = try dict.getValue(
          forKey: "condition",
          type: EvaluableCondition.self
        );
        
        let trueValue = try? dict.getValue(
          forKey: "condition",
          type: ComputableLayoutValueMode.self
        );
        
        let falseValue = try? dict.getValue(
          forKey: "condition",
          type: ComputableLayoutValueMode.self
        );
        
        self = .conditionalValue(
          condition: condition,
          trueValue: trueValue,
          falseValue: falseValue
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
