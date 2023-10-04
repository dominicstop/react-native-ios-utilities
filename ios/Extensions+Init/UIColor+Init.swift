//
//  UIColor+Init.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import UIKit

public extension UIColor {
  
  convenience init(rgba: RGBA){
    self.init(
      red: rgba.r,
      green: rgba.g,
      blue: rgba.b,
      alpha: rgba.a
    );
  };
  
  /// create color from css color code string
  convenience init?(cssColorCode: String) {
    guard let color = UIColorHelpers.cssColorsToRGB[cssColorCode.lowercased()]
    else { return nil };
    
    self.init(red: color.r, green: color.g, blue: color.b, alpha: 1);
  };
  
  /// create color from hex color string
  convenience init?(hexString: String) {
    guard hexString.hasPrefix("#") else { return nil };
    let hexColor: String = UIColorHelpers.normalizeHexString(hexString);
    
    // invalid hex string
    guard hexColor.count == 8 else { return nil };
    
    var hexNumber: UInt64 = 0;
    let scanner = Scanner(string: hexColor);
    
    // failed to convert hex string
    guard scanner.scanHexInt64(&hexNumber) else { return nil };

    self.init(
      red  : CGFloat((hexNumber & 0xff000000) >> 24) / 255,
      green: CGFloat((hexNumber & 0x00ff0000) >> 16) / 255,
      blue : CGFloat((hexNumber & 0x0000ff00) >> 8 ) / 255,
      alpha: CGFloat( hexNumber & 0x000000ff) / 255
    );
  };
  
  /// create color from rgb/rgba string
  convenience init?(rgbString: String){
    // create mutable copy...
    var rgbString = rgbString;
    
    // check if rgba() string
    let hasAlpha = rgbString.hasPrefix("rgba");
    
    // remove "rgb(" or "rgba" prefix
    rgbString = rgbString.replacingOccurrences(
      of: hasAlpha ? "rgba(" : "rgb(",
      with: "",
      options: [.caseInsensitive]
    );
    
    // remove ")" suffix
    rgbString = rgbString.replacingOccurrences(
      of: ")", with: "", options: [.backwards]
    );
    
    // split up the rgb values seperated by ","
    let split = rgbString.components(separatedBy: ",");
    
    // convert to array of float
    let colors = split.compactMap {
      NumberFormatter().number(from: $0) as? CGFloat;
    };
    
    if(colors.count == 3) {
      // create UIColor from rgb(...) string
      self.init(
        red  : colors[0] / 255,
        green: colors[1] / 255,
        blue : colors[2] / 255,
        alpha: 1
      );
      
    } else if(colors.count == 4) {
      // create UIColor from rgba(...) string
      self.init(
        red  : colors[0] / 255,
        green: colors[1] / 255,
        blue : colors[2] / 255,
        alpha: colors[3]
      );
      
    } else {
      // invalid rgb color string
      // color array is < 3 or > 4
      return nil;
    };
  };
  
  /// create color from rgb/rgba/hex/csscolor strings
  convenience init?(cssColor: String){
    // remove whitespace characters
    let colorString = cssColor.trimmingCharacters(in: .whitespacesAndNewlines);
    
    if colorString.hasPrefix("#"){
      self.init(hexString: colorString);
      return;
      
    } else if colorString.hasPrefix("rgb") {
      self.init(rgbString: colorString);
      
    } else if let color = UIColorHelpers.cssColorsToRGB[colorString.lowercased()] {
      self.init(red: color.r, green: color.g, blue: color.b, alpha: 1);
      return;
      
    } else {
      return nil;
    };
  };
  
  /// create color from `DynamicColorIOS` dictionary
  convenience init?(dynamicDict: NSDictionary) {
    guard let dict        = dynamicDict["dynamic"] as? NSDictionary,
          let stringDark  = dict["dark" ] as? String,
          let stringLight = dict["light"] as? String
    else { return nil };
    
    if #available(iOS 13.0, *),
       let colorDark  = UIColor(cssColor: stringDark ),
       let colorLight = UIColor(cssColor: stringLight) {
      
      self.init(dynamicProvider: { traitCollection in
        switch traitCollection.userInterfaceStyle {
          case .dark : return colorDark;
          case .light: return colorLight;
            
          case .unspecified: fallthrough;
          @unknown default : return .clear;
        };
      });
      
    } else {
      self.init(cssColor: stringLight);
    };
  };
  
  @available(iOS 13.0, *)
  convenience init?(elementColorString string: String) {
    guard let parsedColor = UIColorHelpers.elementColorFromString(string) else {
      return nil;
    };
    
    self.init(rgba: parsedColor.rgba);
  };
  
  convenience init?(systemColorString string: String) {
    guard let parsedColor = UIColorHelpers.systemColorFromString(string) else {
      return nil;
    };
    
    self.init(rgba: parsedColor.rgba);
  };
};
