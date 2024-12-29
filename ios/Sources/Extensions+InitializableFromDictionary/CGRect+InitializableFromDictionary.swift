//
//  CGRect+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation
import DGSwiftUtilities


extension CGRect: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    if let origin = try? dict.getPoint(forKey: "origin"),
       let size = try? dict.getSize(forKey: "size")
    {
      self.init(origin: origin, size: size);
    };
    
    let x: CGFloat = try dict.getValue(forKey: "x");
    let y: CGFloat = try dict.getValue(forKey: "y");
    let width: CGFloat = try dict.getValue(forKey: "width");
    let height: CGFloat = try dict.getValue(forKey: "height");
    
    self.init(
      x: x,
      y: y,
      width: width,
      height: height
    );
  };
};


