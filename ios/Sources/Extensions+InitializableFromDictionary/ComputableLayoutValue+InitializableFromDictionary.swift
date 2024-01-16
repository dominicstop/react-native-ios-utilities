//
//  ComputableLayoutValue+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/22/23.
//

import Foundation
import DGSwiftUtilities
import ComputableLayout

extension ComputableLayoutValue: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    let mode = try dict.getValueFromDictionary(
      forKey: "mode",
      type: ComputableLayoutValueMode.self
    );
    
    let offsetValue = try? dict.getValueFromDictionary(
      forKey: "offsetValue",
      type: ComputableLayoutValueMode.self
    );
    
    let offsetOperation = try? dict.getEnumFromDictionary(
      forKey: "offsetOperation",
      type: NumericOperation.self
    );
    
    let minValue = try? dict.getValueFromDictionary(
      forKey: "minValue",
      type: ComputableLayoutValueMode.self
    );
    
    let maxValue = try? dict.getValueFromDictionary(
      forKey: "maxValue",
      type: ComputableLayoutValueMode.self
    );
    
    self.init(
      mode: mode,
      offsetValue: offsetValue,
      offsetOperation: offsetOperation,
      minValue: minValue,
      maxValue: maxValue
    );
  };
};
