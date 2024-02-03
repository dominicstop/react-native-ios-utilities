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
    let width = try dict.getValueFromDictionary(
      forKey: "width",
      type: CGFloat.self
    );
    
    let height = try dict.getValueFromDictionary(
      forKey: "height",
      type: CGFloat.self
    );
    
    self.init(
      width: width,
      height: height
    )
  };
};
