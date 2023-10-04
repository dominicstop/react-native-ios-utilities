//
//  UIColor+Helpers.swift
//  IosContextMenuExample
//
//  Created by Dominic Go on 11/12/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
import UIKit;

public extension UIColor {

  typealias RGBA = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat);
  
  var rgba: RGBA {
    var red  : CGFloat = 0;
    var green: CGFloat = 0;
    var blue : CGFloat = 0;
    var alpha: CGFloat = 0;
    
    getRed(&red, green: &green, blue: &blue, alpha: &alpha);
    return (red, green, blue, alpha);
  };
};
