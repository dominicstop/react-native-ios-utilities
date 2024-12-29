//
//  ComputableLayout+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/22/23.
//

import Foundation
import DGSwiftUtilities
import ComputableLayout


extension ComputableLayout: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {

    let horizontalAlignment = try dict.getEnum(
      forKey: "horizontalAlignment",
      type: ComputableLayoutHorizontalAlignment.self
    );
    
    let verticalAlignment = try dict.getEnum(
      forKey: "verticalAlignment",
      type: ComputableLayoutVerticalAlignment.self
    );
    
    let width = try dict.getValue(
      forKey: "width",
      type: ComputableLayoutValue.self
    );
    
    let height = try dict.getValue(
      forKey: "height",
      type: ComputableLayoutValue.self
    );
    
    let marginLeft = try? dict.getValue(
      forKey: "marginLeft",
      type: ComputableLayoutValue.self
    );
    
    let marginRight = try? dict.getValue(
      forKey: "marginRight",
      type: ComputableLayoutValue.self
    );
    
    let marginTop = try? dict.getValue(
      forKey: "marginTop",
      type: ComputableLayoutValue.self
    );
    
    let marginBottom = try? dict.getValue(
      forKey: "marginBottom",
      type: ComputableLayoutValue.self
    );
    
    let paddingLeft = try? dict.getValue(
      forKey: "paddingLeft",
      type: ComputableLayoutValue.self
    );
    
    let paddingRight = try? dict.getValue(
      forKey: "paddingRight",
      type: ComputableLayoutValue.self
    );
    
    let paddingTop = try? dict.getValue(
      forKey: "paddingTop",
      type: ComputableLayoutValue.self
    );
    
    let paddingBottom = try? dict.getValue(
      forKey: "paddingBottom",
      type: ComputableLayoutValue.self
    );
    
    let offsetX = try? dict.getValue(
      forKey: "offsetX",
      type: ComputableLayoutValue.self
    );
    
    let offsetY = try? dict.getValue(
      forKey: "offsetY",
      type: ComputableLayoutValue.self
    );
    
    self.init(
      horizontalAlignment: horizontalAlignment,
      verticalAlignment: verticalAlignment,
      width: width,
      height: height,
      marginLeft: marginLeft,
      marginRight: marginRight,
      marginTop: marginTop,
      marginBottom: marginBottom,
      paddingLeft: paddingLeft,
      paddingRight: paddingRight,
      paddingTop: paddingTop,
      paddingBottom: paddingBottom,
      offsetX: offsetX,
      offsetY: offsetY
    );
  };
};

// MARK: - Dictionary+ComputableLayout
// -----------------------------------

public extension Dictionary where Key == String {
  
  func getComputableLayoutConfig(forKey key: String) throws -> ComputableLayout {
    let dictConfig = try self.getDict(forKey: key)
    return try .init(fromDict: dictConfig);
  };
  
  func getValue(forKey key: String) throws -> ComputableLayout {
    try self.getComputableLayoutConfig(forKey: key);
  };
};
