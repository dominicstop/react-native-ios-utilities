//
//  CGVector+InitializableFromDictionary.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import Foundation
import DGSwiftUtilities


extension CGVector: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let dx: CGFloat = try dict.getNumber(forKey: "dx");
    let dy: CGFloat = try dict.getNumber(forKey: "dy");
    
    self.init(dx: dx, dy: dy);
  };
};
