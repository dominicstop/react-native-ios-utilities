//
//  CGPoint+Init.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import Foundation
import DGSwiftUtilities

// TODO: Move to `DGSwiftUtilities`
extension CGPoint: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let x = try dict.getValueFromDictionary(
      forKey: "x",
      type: NSNumber.self
    );
    
    let y = try dict.getValueFromDictionary(
      forKey: "y",
      type: NSNumber.self
    );
    
    self.init(
      x: x.doubleValue,
      y: y.doubleValue
    );
  };
};
