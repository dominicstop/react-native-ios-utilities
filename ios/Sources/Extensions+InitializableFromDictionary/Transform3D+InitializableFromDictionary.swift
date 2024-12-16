//
//  Transform3D+InitializableFromDictionary.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import DGSwiftUtilities


import Foundation
import DGSwiftUtilities

// TODO: Move to `DGSwiftUtilities`
extension Transform3D: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) {
    let translateX = try? dict.getValue(
      forKey: "translateX",
      type: NSNumber.self
    );
    
    let translateY = try? dict.getValue(
      forKey: "translateY",
      type: NSNumber.self
    );
    
    let translateZ = try? dict.getValue(
      forKey: "translateZ",
      type: NSNumber.self
    );
    
    let scaleX = try? dict.getValue(
      forKey: "scaleX",
      type: NSNumber.self
    );
    
    let scaleY = try? dict.getValue(
      forKey: "scaleY",
      type: NSNumber.self
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
    
    let perspective = try? dict.getValue(
      forKey: "perspective",
      type: NSNumber.self
    );
    
    let skewX = try? dict.getValue(
      forKey: "skewX",
      type: NSNumber.self
    );
    
    let skewY = try? dict.getValue(
      forKey: "skewY",
      type: NSNumber.self
    );
    
    self.init(
      translateX: translateX as? CGFloat,
      translateY: translateY as? CGFloat,
      translateZ: translateZ as? CGFloat,
      scaleX: scaleX as? CGFloat,
      scaleY: scaleY as? CGFloat,
      rotateX: rotateX,
      rotateY: rotateY,
      rotateZ: rotateZ,
      perspective: perspective as? CGFloat,
      skewX: skewX as? CGFloat,
      skewY: skewY as? CGFloat
    );
  };

  // For backwards compatibility
  @available(*, deprecated, message: "Please use init(fromDict:) instead")
  init(dict: Dictionary<String, Any>) {
    self.init(fromDict: dict);
  };
};
