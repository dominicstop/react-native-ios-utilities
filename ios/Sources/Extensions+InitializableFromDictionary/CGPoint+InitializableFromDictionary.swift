//
//  CGPoint+Init.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import Foundation
import DGSwiftUtilities


extension CGPoint: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let x: CGFloat = try dict.getNumber(forKey: "x");
    let y: CGFloat = try dict.getNumber(forKey: "y");
    
    self.init(x: x, y: y);
  };
};

// MARK: - Dictionary+CGPoint
// --------------------------

public extension Dictionary where Key == String {
  
  func getPoint(forKey key: String) throws -> CGPoint {
    let dictConfig = try self.getDict(forKey: key)
    return try .init(fromDict: dictConfig);
  };
  
  func getValue(forKey key: String) throws -> CGPoint {
    try self.getPoint(forKey: key);
  };
};
