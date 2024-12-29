//
//  CGSize+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/4/24.
//

import Foundation
import DGSwiftUtilities

extension CGSize: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    let width = try dict.getValue(
      forKey: "width",
      type: CGFloat.self
    );
    
    let height = try dict.getValue(
      forKey: "height",
      type: CGFloat.self
    );
    
    self.init(
      width: width,
      height: height
    )
  };
};

// MARK: - Dictionary+CGSize
// -------------------------

public extension Dictionary where Key == String {
  
  func getSize(forKey key: String) throws -> CGSize {
    let sizeDict = try self.getDict(forKey: key)
    return try .init(fromDict: sizeDict);
  };
  
  func getValue(forKey key: String) throws -> CGSize {
    try self.getSize(forKey: key);
  };
};
