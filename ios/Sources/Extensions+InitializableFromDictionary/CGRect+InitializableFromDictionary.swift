//
//  CGRect+InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation
import DGSwiftUtilities

// TODO: Move to `DGSwiftUtilities`
extension CGRect: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    if let origin = try? dict.getValue(
         forKey: "dx",
         type: CGPoint.self
       ),
       let size = try? dict.getValue(
         forKey: "dy",
         type: CGSize.self
       ) {
      
      self.init(origin: origin, size: size);
    };
    
    let x = try dict.getValue(
      forKey: "x",
      type: CGFloat.self
    );
    
    let y = try dict.getValue(
      forKey: "y",
      type: CGFloat.self
    );
    
    let width = try dict.getValue(
      forKey: "width",
      type: CGFloat.self
    );
    
    let height = try dict.getValue(
      forKey: "height",
      type: CGFloat.self
    );
    
    self.init(
      x: x,
      y: y,
      width: width,
      height: height
    );
  };
};
