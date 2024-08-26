//
//  RNIViewPropDelegate+StringKeyPathMapping.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation
import DGSwiftUtilities


public extension RNIViewPropDelegate where Self: StringKeyPathMapping {

  func setValue(forKey key: String, value: Any){
    guard let keyPath = try? Self.getPartialKeyPath(forKey: key)
    else { return };
    
    return self.setValue(withKeyPath: keyPath, value: value);
  };

  func setValues(withDict dict: NSDictionary){
    dict.allKeys.forEach {
      guard let key = $0 as? String,
            let keyPath = try? Self.getPartialKeyPath(forKey: key)
      else { return };
      
      let newValue = dict[$0] is NSNull
        ? nil
        : dict[$0];
      
      self.setValue(withKeyPath: keyPath, value: newValue);
    };
  };
};
