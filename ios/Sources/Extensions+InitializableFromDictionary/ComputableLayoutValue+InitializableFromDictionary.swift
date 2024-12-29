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
    let mode = try dict.getValue(
      forKey: "mode",
      type: ComputableLayoutValueMode.self
    );
    
    let offsetValue = try? dict.getValue(
      forKey: "offsetValue",
      type: ComputableLayoutValueMode.self
    );
    
    let offsetOperation = try? dict.getEnum(
      forKey: "offsetOperation",
      type: NumericOperation.self
    );
    
    let minValue = try? dict.getValue(
      forKey: "minValue",
      type: ComputableLayoutValueMode.self
    );
    
    let maxValue = try? dict.getValue(
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

// MARK: - Dictionary+ComputableLayoutValue
// -----------------------------------------

public extension Dictionary where Key == String {
  
  func getComputableLayoutValue(forKey key: String) throws -> ComputableLayoutValue {
    let dictConfig = try self.getDict(forKey: key)
    return try .init(fromDict: dictConfig);
  };
  
  func getValue(forKey key: String) throws -> ComputableLayoutValue {
    try self.getComputableLayoutValue(forKey: key);
  };
};
