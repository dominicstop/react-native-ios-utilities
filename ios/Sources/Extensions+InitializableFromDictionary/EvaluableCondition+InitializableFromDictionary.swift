//
//  EvaluableCondition+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/30/23.
//

import Foundation
import DGSwiftUtilities
import ComputableLayout

extension EvaluableCondition: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString: String = try dict.getValueFromDictionary(forKey: "mode");
    
    switch modeString {
      case "frameRect":
        let frameRect = try dict.getValueFromDictionary(
          forKey: "of",
          type: FrameRectValue.self
        );
        
        let keyPath = try dict.getKeyPathFromDictionary(
          forKey: "valueForKey",
          rootType: CGRect.self,
          valueType: CGFloat.self
        );
        
        let condition = try dict.getValueFromDictionary(
          forKey: "condition",
          type: NumericLogicalExpression<CGFloat>.self
        );
        
        self = .frameRect(
          of: frameRect,
          valueForKey: keyPath,
          condition: condition
        );

      case "size":
        let sizeValue = try dict.getValueFromDictionary(
          forKey: "of",
          type: SizeValue.self
        );
        
        let keyPath = try dict.getKeyPathFromDictionary(
          forKey: "valueForKey",
          rootType: CGSize.self,
          valueType: CGFloat.self
        );
        
        let condition = try dict.getValueFromDictionary(
          forKey: "condition",
          type: NumericLogicalExpression<CGFloat>.self
        );
        
        self = .size(
          of: sizeValue,
          valueForKey: keyPath,
          condition: condition
        );

      case "safeAreaInsets":
        let keyPath = try dict.getKeyPathFromDictionary(
          forKey: "valueForKey",
          rootType: UIEdgeInsets.self,
          valueType: CGFloat.self
        );
        
        let condition = try dict.getValueFromDictionary(
          forKey: "condition",
          type: NumericLogicalExpression<CGFloat>.self
        );
        
        self = .safeAreaInsets(
          valueForKey: keyPath,
          condition: condition
        );

      case "deviceIdiom":
        let value = try dict.getEnumFromDictionary(
          forKey: "isEqualTo",
          type: UIUserInterfaceIdiom.self
        );
        
        self = .deviceIdiom(is: value);

      case "deviceOrientation":
        let value = try dict.getEnumFromDictionary(
          forKey: "isEqualTo",
          type: UIDeviceOrientation.self
        );
        
        self = .deviceOrientation(is: value);

      case "horizontalSizeClass":
        let value = try dict.getEnumFromDictionary(
          forKey: "isEqualTo",
          type: UIUserInterfaceSizeClass.self
        );
        
        self = .horizontalSizeClass(is: value);

      case "verticalSizeClass":
        let value = try dict.getEnumFromDictionary(
          forKey: "isEqualTo",
          type: UIUserInterfaceSizeClass.self
        );
        
        self = .verticalSizeClass(is: value);

      case "interfaceStyle":
        // TODO: WIP - To be implemented
        fatalError("WIP - To be implemented");
        
        // let value = try dict.getEnumFromDictionary(
        //   forKey: "isEqualTo",
        //   type: UserInterfaceStyle.self
        // );
        //
        // self = .interfaceStyle(
        //   is: value
        // );

      case "interfaceLevel":
        // TODO: WIP - To be implemented
        fatalError("WIP - To be implemented");
        
        // let value = try dict.getEnumFromDictionary(
        //   forKey: "isEqualTo",
        //   type: UserInterfaceLevel.self
        // );
        
        // self = .interfaceLevel(
        //   is:
        // );
        
      case "interfaceOrientation":
        let value = try dict.getEnumFromDictionary(
          forKey: "isEqualTo",
          type: UIInterfaceOrientation.self
        );
        
        self = .interfaceOrientation(is: value);

      case "activeAppearance":
        // TODO: WIP - To be implemented
        fatalError("WIP - To be implemented");
        
        // let value = try dict.getEnumFromDictionary(
        //   forKey: "isEqualTo",
        //   type: UserInterfaceActiveAppearance.self
        // );
        //
        // self = .activeAppearance(
        //   is:
        // );

      case "layoutDirection":
        let value = try dict.getEnumFromDictionary(
          forKey: "isEqualTo",
          type: UITraitEnvironmentLayoutDirection.self
        );
        
        self = .layoutDirection(is: value);

      case "isFlagTrue":
        let value = try dict.getKeyPathFromDictionary(
          forKey: "isEqualToKey",
          rootType: EvaluableConditionContext.self,
          valueType: Bool.self
        );
        
        self = .isFlagTrue(forKey: value);

      case "deviceFlags":
        let value = try dict.getKeyPathFromDictionary(
          forKey: "isEqualToKey",
          rootType: UIDevice.self,
          valueType: Bool.self
        );
        
        self = .deviceFlags(forKey: value);

      case "deviceString":
        let keyPath = try dict.getKeyPathFromDictionary(
          forKey: "isEqualToKey",
          rootType: UIDevice.self,
          valueType: String.self
        );
        
        let stringComparisonMode = try dict.getEnumFromDictionary(
          forKey: "stringComparisonMode",
          type: StringComparisonMode.self
        );
        
        let isCaseSensitive = try dict.getValueFromDictionary(
          forKey: "isCaseSensitive",
          type: Bool.self
        );
        
        let stringValue = try dict.getValueFromDictionary(
          forKey: "stringValue",
          type: String.self
        );
        
        self = .deviceString(
          forKey: keyPath,
          mode: stringComparisonMode,
          isCaseSensitive: isCaseSensitive,
          stringValue: stringValue
        );

      case "customFlag":
        let flag = try dict.getValueFromDictionary(
          forKey: "value",
          type: Bool.self
        );
        
        self = .customFlag(flag);

      case "negate":
        let value = try dict.getValueFromDictionary(
          forKey: "value",
          type: EvaluableCondition.self
        );
        
        self = .negate(value);

      case "ifAnyAreTrue":
        let valuesRaw = try dict.getValueFromDictionary(
          forKey: "values",
          type: Array<Dictionary<String, Any>>.self
        );
        
        let values = valuesRaw.compactMap {
          try? EvaluableCondition(fromDict: $0);
        };
        
        self = .ifAnyAreTrue(values);

      case "ifAllAreTrue":
        let valuesRaw = try dict.getValueFromDictionary(
          forKey: "values",
          type: Array<Dictionary<String, Any>>.self
        );
        
        let values = valuesRaw.compactMap {
          try? EvaluableCondition(fromDict: $0);
        };
        
        self = .ifAllAreTrue(values);
        
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
