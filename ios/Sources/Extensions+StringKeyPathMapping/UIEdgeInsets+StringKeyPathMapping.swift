//
//  UIEdgeInsets+StringKeyPathMapping.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/24/23.
//

import Foundation

// TODO: Move to `DGSwiftUtilities`
extension UIEdgeInsets: StringKeyPathMapping {
  
  public static let stringToKeyPathMap: Dictionary<String, PartialKeyPath<Self>> = [
    "top": \.top,
    "left": \.left,
    "bottom": \.bottom,
    "right": \.right,
  ];
};
