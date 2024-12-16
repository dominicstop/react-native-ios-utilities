//
//  CGVector+InitializableFromDictionary.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import Foundation
import DGSwiftUtilities

// TODO: Move to `DGSwiftUtilities`
extension CGVector: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let dx = try dict.getValue(
      forKey: "dx",
      type: NSNumber.self
    );
    
    let dy = try dict.getValue(
      forKey: "dy",
      type: NSNumber.self
    );
    
    self.init(
      dx: dx.doubleValue,
      dy: dy.doubleValue
    );
  };
};
