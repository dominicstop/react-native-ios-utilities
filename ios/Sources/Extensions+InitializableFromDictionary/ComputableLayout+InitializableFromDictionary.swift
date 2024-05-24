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

    let horizontalAlignment = try dict.getEnumFromDictionary(
      forKey: "horizontalAlignment",
      type: ComputableLayoutHorizontalAlignment.self
    );
    
    let verticalAlignment = try dict.getEnumFromDictionary(
      forKey: "verticalAlignment",
      type: ComputableLayoutVerticalAlignment.self
    );
    
    let width = try dict.getValueFromDictionary(
      forKey: "width",
      type: ComputableLayoutValue.self
    );
    
    let height = try dict.getValueFromDictionary(
      forKey: "height",
      type: ComputableLayoutValue.self
    );
    
    let marginLeft = try? dict.getValueFromDictionary(
      forKey: "marginLeft",
      type: ComputableLayoutValue.self
    );
    
    let marginRight = try? dict.getValueFromDictionary(
      forKey: "marginRight",
      type: ComputableLayoutValue.self
    );
    
    let marginTop = try? dict.getValueFromDictionary(
      forKey: "marginTop",
      type: ComputableLayoutValue.self
    );
    
    let marginBottom = try? dict.getValueFromDictionary(
      forKey: "marginBottom",
      type: ComputableLayoutValue.self
    );
    
    let paddingLeft = try? dict.getValueFromDictionary(
      forKey: "paddingLeft",
      type: ComputableLayoutValue.self
    );
    
    let paddingRight = try? dict.getValueFromDictionary(
      forKey: "paddingRight",
      type: ComputableLayoutValue.self
    );
    
    let paddingTop = try? dict.getValueFromDictionary(
      forKey: "paddingTop",
      type: ComputableLayoutValue.self
    );
    
    let paddingBottom = try? dict.getValueFromDictionary(
      forKey: "paddingBottom",
      type: ComputableLayoutValue.self
    );
    
    let offsetX = try? dict.getValueFromDictionary(
      forKey: "offsetX",
      type: ComputableLayoutValue.self
    );
    
    let offsetY = try? dict.getValueFromDictionary(
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
