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
    
    
    self.transform = {
      guard let transformDict = try? dict.getDict(forKey: "transform") else {
        return nil;
      };
        
      return .init(fromDict: transformDict);
    }();
  };
};
