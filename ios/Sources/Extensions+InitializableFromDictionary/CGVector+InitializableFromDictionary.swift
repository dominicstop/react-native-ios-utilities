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

// MARK: - Dictionary+CGVector
// ---------------------------

public extension Dictionary where Key == String {
  
  func getVector(forKey key: String) throws -> CGVector {
    let dictConfig = try self.getDict(forKey: key)
    return try .init(fromDict: dictConfig);
  };
  
  func getValue(forKey key: String) throws -> CGVector {
    try self.getVector(forKey: key);
  };
};
