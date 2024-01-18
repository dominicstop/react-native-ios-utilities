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
    let translateX = try? dict.getValueFromDictionary(
      forKey: "translateX",
      type: NSNumber.self
    );
    
    let translateY = try? dict.getValueFromDictionary(
      forKey: "translateY",
      type: NSNumber.self
    );
    
    let translateZ = try? dict.getValueFromDictionary(
      forKey: "translateZ",
      type: NSNumber.self
    );
    
    let scaleX = try? dict.getValueFromDictionary(
      forKey: "scaleX",
      type: NSNumber.self
    );
    
    let scaleY = try? dict.getValueFromDictionary(
      forKey: "scaleY",
      type: NSNumber.self
    );
    
    let rotateX = try? dict.getValueFromDictionary(
      forKey: "rotateX",
      type: Angle<CGFloat>.self
    );
    
    let rotateY = try? dict.getValueFromDictionary(
      forKey: "rotateY",
      type: Angle<CGFloat>.self
    );
    
    let rotateZ = try? dict.getValueFromDictionary(
      forKey: "rotateZ",
      type: Angle<CGFloat>.self
    );
    
    let perspective = try? dict.getValueFromDictionary(
      forKey: "perspective",
      type: NSNumber.self
    );
    
    let skewX = try? dict.getValueFromDictionary(
      forKey: "skewX",
      type: NSNumber.self
    );
    
    let skewY = try? dict.getValueFromDictionary(
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
