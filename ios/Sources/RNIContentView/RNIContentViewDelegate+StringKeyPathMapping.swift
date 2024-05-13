//
//  RNIContentViewDelegate+StringKeyPathMapping.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/13/24.
//

import Foundation
import DGSwiftUtilities

public extension RNIContentViewDelegate where Self: StringKeyPathMapping {

  func setValues(withDict dict: NSDictionary){
    dict.allKeys.forEach {
      guard let key = $0 as? String,
            let keyPath = try? Self.getPartialKeyPath(forKey: key)
      else { return };
      
      let newValue = dict[$0];
      self.setValue(withKeyPath: keyPath, value: newValue);
    };
  };
};
