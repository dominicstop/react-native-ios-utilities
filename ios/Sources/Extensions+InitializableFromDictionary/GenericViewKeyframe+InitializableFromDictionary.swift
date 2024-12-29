//
//  GenericViewKeyframe+InitializableFromDictionary.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/29/24.
//

import UIKit
import DGSwiftUtilities


extension GenericViewKeyframe: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) {
    self.init();

    self.opacity = try? dict.getNumber(forKey: "opacity");
    self.backgroundColor = try? dict.getColor(forKey: "backgroundColor");
    self.transform = try? dict.getTransform(forKey: "transform");
    
    self.borderWidth = try? dict.getNumber(forKey: "borderWidth");
    self.borderColor = try? dict.getColor(forKey: "borderColor");
    
    self.shadowColor = try? dict.getColor(forKey: "shadowColor");
    self.shadowOffset = try? dict.getSize(forKey: "shadowOffset");
    self.shadowOpacity = try? dict.getNumber(forKey: "shadowOpacity");
    self.shadowRadius = try? dict.getNumber(forKey: "shadowRadius");
    
    self.cornerRadius = try? dict.getNumber(forKey: "cornerRadius");
    
    self.cornerMask = try? dict.getValue(
      forKey: "cornerMask",
      type: CACornerMask.self
    );
  };
};

// MARK: - Dictionary+CGSize
// -------------------------

public extension Dictionary where Key == String {
  
  func getGenericViewKeyframe<T>(forKey key: String) throws -> GenericViewKeyframe<T> {
    let sizeDict = try self.getDict(forKey: key)
    return .init(fromDict: sizeDict);
  };
  
  func getValue<T>(forKey key: String) throws -> GenericViewKeyframe<T> {
    try self.getGenericViewKeyframe(forKey: key);
  };
};

