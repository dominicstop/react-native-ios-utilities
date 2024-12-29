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
    let x: CGFloat = try dict.getNumber(forKey: "x");
    let y: CGFloat = try dict.getNumber(forKey: "y");
    
    self.init(x: x, y: y);
  };
};
