//
//  Transform3D+InitializableFromDictionary.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import DGSwiftUtilities


import Foundation
import DGSwiftUtilities


extension Transform3D: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) {
    let translateX = try? dict.getNumber(
      forKey: "translateX",
      type: CGFloat.self
    );
    
    let translateY = try? dict.getNumber(
      forKey: "translateY",
      type: CGFloat.self
    );
    
    let translateZ = try? dict.getNumber(
      forKey: "translateZ",
      type: CGFloat.self
    );
    
    let scaleX = try? dict.getNumber(
      forKey: "scaleX",
      type: CGFloat.self
    );
    
    let scaleY = try? dict.getNumber(
      forKey: "scaleY",
      type: CGFloat.self
    );
    
    let rotateX = try? dict.getValue(
      forKey: "rotateX",
      type: Angle<CGFloat>.self
    );
    
    let rotateY = try? dict.getValue(
      forKey: "rotateY",
      type: Angle<CGFloat>.self
    );
    
    let rotateZ = try? dict.getValue(
      forKey: "rotateZ",
      type: Angle<CGFloat>.self
    );
    
    let perspective = try? dict.getNumber(
      forKey: "perspective",
      type: CGFloat.self
    );
    
    let skewX = try? dict.getNumber(
      forKey: "skewX",
      type: CGFloat.self
    );
    
    let skewY = try? dict.getNumber(
      forKey: "skewY",
      type: CGFloat.self
    );
    
    self.init(
      translateX: translateX,
      translateY: translateY,
      translateZ: translateZ,
      scaleX: scaleX,
      scaleY: scaleY,
      rotateX: rotateX,
      rotateY: rotateY,
      rotateZ: rotateZ,
      perspective: perspective,
      skewX: skewX,
      skewY: skewY
    );
  };

  // For backwards compatibility
  @available(*, deprecated, message: "Please use init(fromDict:) instead")
  init(dict: Dictionary<String, Any>) {
    self.init(fromDict: dict);
  };
};

// MARK: - Dictionary+Transform3D
// ------------------------------

public extension Dictionary where Key == String {
  
  func getTransform(forKey key: String) throws -> Transform3D {
    let transformDict = try self.getDict(forKey: key)
    return .init(fromDict: transformDict);
  };
  
  func getValue(forKey key: String) throws -> Transform3D {
    try self.getTransform(forKey: key);
  };
};
