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
    let modeString: String = try dict.getValue(forKey: "mode");
    
    switch modeString {
      case "frameRect":
        let frameRect = try dict.getValue(
          forKey: "of",
          type: FrameRectValue.self
        );
        
        let keyPath = try dict.getKeyPath(
          forKey: "valueForKey",
          rootType: CGRect.self,
          valueType: CGFloat.self
        );
        
        let condition = try dict.getValue(
          forKey: "condition",
          type: NumericLogicalExpression<CGFloat>.self
        );
        
        self = .frameRect(
          of: frameRect,
          valueForKey: keyPath,
          condition: condition
        );

      case "size":
        let sizeValue = try dict.getValue(
          forKey: "of",
          type: SizeValue.self
        );
        
        let keyPath = try dict.getKeyPath(
          forKey: "valueForKey",
          rootType: CGSize.self,
          valueType: CGFloat.self
        );
        
        let condition = try dict.getValue(
          forKey: "condition",
          type: NumericLogicalExpression<CGFloat>.self
        );
        
        self = .size(
          of: sizeValue,
          valueForKey: keyPath,
          condition: condition
        );

      case "safeAreaInsets":
        let keyPath = try dict.getKeyPath(
          forKey: "valueForKey",
          rootType: UIEdgeInsets.self,
          valueType: CGFloat.self
        );
        
        let condition = try dict.getValue(
          forKey: "condition",
          type: NumericLogicalExpression<CGFloat>.self
        );
        
        self = .safeAreaInsets(
          valueForKey: keyPath,
          condition: condition
        );

      case "deviceIdiom":
        let value = try dict.getEnum(
          forKey: "isEqualTo",
          type: UIUserInterfaceIdiom.self
        );
        
        self = .deviceIdiom(is: value);

      case "deviceOrientation":
        let value = try dict.getEnum(
          forKey: "isEqualTo",
          type: UIDeviceOrientation.self
        );
        
        self = .deviceOrientation(is: value);

      case "horizontalSizeClass":
        let value = try dict.getEnum(
          forKey: "isEqualTo",
          type: UIUserInterfaceSizeClass.self
        );
        
        self = .horizontalSizeClass(is: value);

      case "verticalSizeClass":
        let value = try dict.getEnum(
          forKey: "isEqualTo",
          type: UIUserInterfaceSizeClass.self
        );
        
        self = .verticalSizeClass(is: value);

      case "interfaceStyle":
        // TODO: WIP - To be implemented
        fatalError("WIP - To be implemented");
        
        // let value = try dict.getEnum(
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
        
        // let value = try dict.getEnum(
        //   forKey: "isEqualTo",
        //   type: UserInterfaceLevel.self
        // );
        
        // self = .interfaceLevel(
        //   is:
        // );
        
      case "interfaceOrientation":
        let value = try dict.getEnum(
          forKey: "isEqualTo",
          type: UIInterfaceOrientation.self
        );
        
        self = .interfaceOrientation(is: value);

      case "activeAppearance":
        // TODO: WIP - To be implemented
        fatalError("WIP - To be implemented");
        
        // let value = try dict.getEnum(
        //   forKey: "isEqualTo",
        //   type: UserInterfaceActiveAppearance.self
        // );
        //
        // self = .activeAppearance(
        //   is:
        // );

      case "layoutDirection":
        let value = try dict.getEnum(
          forKey: "isEqualTo",
          type: UITraitEnvironmentLayoutDirection.self
        );
        
        self = .layoutDirection(is: value);

      case "isFlagTrue":
        let value = try dict.getKeyPath(
          forKey: "isEqualToKey",
          rootType: EvaluableConditionContext.self,
          valueType: Bool.self
        );
        
        self = .isFlagTrue(forKey: value);

      case "deviceFlags":
        let value = try dict.getKeyPath(
          forKey: "isEqualToKey",
          rootType: UIDevice.self,
          valueType: Bool.self
        );
        
        self = .deviceFlags(forKey: value);

      case "deviceString":
        let keyPath = try dict.getKeyPath(
          forKey: "isEqualToKey",
          rootType: UIDevice.self,
          valueType: String.self
        );
        
        let stringComparisonMode = try dict.getEnum(
          forKey: "stringComparisonMode",
          type: StringComparisonMode.self
        );
        
        let isCaseSensitive = try dict.getBool(forKey: "isCaseSensitive");
        let stringValue = try dict.getString(forKey: "stringValue");
        
        self = .deviceString(
          forKey: keyPath,
          mode: stringComparisonMode,
          isCaseSensitive: isCaseSensitive,
          stringValue: stringValue
        );

      case "customFlag":
        let flag = try dict.getBool(forKey: "value");
        self = .customFlag(flag);

      case "negate":
        let value = try dict.getValue(
          forKey: "value",
          type: EvaluableCondition.self
        );
        
        self = .negate(value);

      case "ifAnyAreTrue":
        let valuesRaw = try dict.getArray(
          forKey: "values",
          elementType: Dictionary<String, Any>.self
        );
        
        let values = valuesRaw.compactMap {
          try? EvaluableCondition(fromDict: $0);
        };
        
        self = .ifAnyAreTrue(values);

      case "ifAllAreTrue":
        let valuesRaw = try dict.getArray(
          forKey: "values",
          elementType: Dictionary<String, Any>.self
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
