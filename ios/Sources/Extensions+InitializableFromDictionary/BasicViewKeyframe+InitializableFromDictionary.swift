//
//  BasicViewKeyframe+InitializableFromDictionary.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/29/24.
//

import UIKit
import DGSwiftUtilities


extension BasicViewKeyframe: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) {
    self.init();
    
    self.opacity = try? dict.getNumber(forKey: "opacity");
    self.backgroundColor = try? dict.getColor(forKey: "backgroundColor");
    self.transform = try? dict.getTransform(forKey: "transform");
  };
};

// MARK: - Dictionary+BasicViewKeyframe
// ------------------------------------

public extension Dictionary where Key == String {
  
  func getBasicKeyframe<T>(forKey key: String) throws -> BasicViewKeyframe<T> {
    let dictConfig = try self.getDict(forKey: key)
    return .init(fromDict: dictConfig);
  };
  
  func getValue<T>(forKey key: String) throws -> BasicViewKeyframe<T> {
    try self.getBasicKeyframe(forKey: key);
  };
};
