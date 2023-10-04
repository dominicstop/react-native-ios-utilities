//
//  UIColorHelpers.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import UIKit

public class UIColorHelpers {

  public struct RGBColor {
    var r: CGFloat;
    var g: CGFloat;
    var b: CGFloat;
    
    init(r: Int, g: Int, b: Int) {
      self.r = CGFloat(r) / 255;
      self.g = CGFloat(g) / 255;
      self.b = CGFloat(b) / 255;
    };
  };
  
  // css colors strings to UIColor
  public static let cssColorsToRGB: [String: RGBColor] = [
    // colors red ---------------------------------
    "lightsalmon": RGBColor(r: 255, g: 160, b: 122),
    "salmon"     : RGBColor(r: 250, g: 128, b: 114),
    "darksalmon" : RGBColor(r: 233, g: 150, b: 122),
    "lightcoral" : RGBColor(r: 240, g: 128, b: 128),
    "indianred"  : RGBColor(r: 205, g: 92 , b: 92 ),
    "crimson"    : RGBColor(r: 220, g: 20 , b: 60 ),
    "firebrick"  : RGBColor(r: 178, g: 34 , b: 34 ),
    "red"        : RGBColor(r: 255, g: 0  , b: 0  ),
    "darkred"    : RGBColor(r: 139, g: 0  , b: 0  ),
    // colors orange ----------------------------
    "coral"     : RGBColor(r: 255, g: 127, b: 80),
    "tomato"    : RGBColor(r: 255, g: 99 , b: 71),
    "orangered" : RGBColor(r: 255, g: 69 , b: 0 ),
    "gold"      : RGBColor(r: 255, g: 215, b: 0 ),
    "orange"    : RGBColor(r: 255, g: 165, b: 0 ),
    "darkorange": RGBColor(r: 255, g: 140, b: 0 ),
    // colors green ----------------------------------------
    "lightyellow"         : RGBColor(r: 255, g: 255, b: 224),
    "lemonchiffon"        : RGBColor(r: 255, g: 250, b: 205),
    "lightgoldenrodyellow": RGBColor(r: 250, g: 250, b: 210),
    "papayawhip"          : RGBColor(r: 255, g: 239, b: 213),
    "moccasin"            : RGBColor(r: 255, g: 228, b: 181),
    "peachpuff"           : RGBColor(r: 255, g: 218, b: 185),
    "palegoldenrod"       : RGBColor(r: 238, g: 232, b: 170),
    "khaki"               : RGBColor(r: 240, g: 230, b: 140),
    "darkkhaki"           : RGBColor(r: 189, g: 183, b: 107),
    "yellow"              : RGBColor(r: 255, g: 255, b: 0  ),
    // colors green -------------------------------------
    "lawngreen"        : RGBColor(r: 124, g: 252, b: 0  ),
    "chartreuse"       : RGBColor(r: 127, g: 255, b: 0  ),
    "limegreen"        : RGBColor(r: 50 , g: 205, b: 50 ),
    "lime"             : RGBColor(r: 0  , g: 255, b: 0  ),
    "forestgreen"      : RGBColor(r: 34 , g: 139, b: 34 ),
    "green"            : RGBColor(r: 0  , g: 128, b: 0  ),
    "darkgreen"        : RGBColor(r: 0  , g: 100, b: 0  ),
    "greenyellow"      : RGBColor(r: 173, g: 255, b: 47 ),
    "yellowgreen"      : RGBColor(r: 154, g: 205, b: 50 ),
    "springgreen"      : RGBColor(r: 0  , g: 255, b: 127),
    "mediumspringgreen": RGBColor(r: 0  , g: 250, b: 154),
    "lightgreen"       : RGBColor(r: 144, g: 238, b: 144),
    "palegreen"        : RGBColor(r: 152, g: 251, b: 152),
    "darkseagreen"     : RGBColor(r: 143, g: 188, b: 143),
    "mediumseagreen"   : RGBColor(r: 60 , g: 179, b: 113),
    "seagreen"         : RGBColor(r: 46 , g: 139, b: 87 ),
    "olive"            : RGBColor(r: 128, g: 128, b: 0  ),
    "darkolivegreen"   : RGBColor(r: 85 , g: 107, b: 47 ),
    "olivedrab"        : RGBColor(r: 107, g: 142, b: 35 ),
    // colors cyan -------------------------------------
    "lightcyan"       : RGBColor(r: 224, g: 255, b: 255),
    "cyan"            : RGBColor(r: 0  , g: 255, b: 255),
    "aqua"            : RGBColor(r: 0  , g: 255, b: 255),
    "aquamarine"      : RGBColor(r: 127, g: 255, b: 212),
    "mediumaquamarine": RGBColor(r: 102, g: 205, b: 170),
    "paleturquoise"   : RGBColor(r: 175, g: 238, b: 238),
    "turquoise"       : RGBColor(r: 64 , g: 224, b: 208),
    "mediumturquoise" : RGBColor(r: 72 , g: 209, b: 204),
    "darkturquoise"   : RGBColor(r: 0  , g: 206, b: 209),
    "lightseagreen"   : RGBColor(r: 32 , g: 178, b: 170),
    "cadetblue"       : RGBColor(r: 95 , g: 158, b: 160),
    "darkcyan"        : RGBColor(r: 0  , g: 139, b: 139),
    "teal"            : RGBColor(r: 0  , g: 128, b: 128),
    // colors blue ------------------------------------
    "powderblue"     : RGBColor(r: 176, g: 224, b: 230),
    "lightblue"      : RGBColor(r: 173, g: 216, b: 230),
    "lightskyblue"   : RGBColor(r: 135, g: 206, b: 250),
    "skyblue"        : RGBColor(r: 135, g: 206, b: 235),
    "deepskyblue"    : RGBColor(r: 0  , g: 191, b: 255),
    "lightsteelblue" : RGBColor(r: 176, g: 196, b: 222),
    "dodgerblue"     : RGBColor(r: 30 , g: 144, b: 255),
    "cornflowerblue" : RGBColor(r: 100, g: 149, b: 237),
    "steelblue"      : RGBColor(r: 70 , g: 130, b: 180),
    "royalblue"      : RGBColor(r: 65 , g: 105, b: 225),
    "blue"           : RGBColor(r: 0  , g: 0  , b: 255),
    "mediumblue"     : RGBColor(r: 0  , g: 0  , b: 205),
    "darkblue"       : RGBColor(r: 0  , g: 0  , b: 139),
    "navy"           : RGBColor(r: 0  , g: 0  , b: 128),
    "midnightblue"   : RGBColor(r: 25 , g: 25 , b: 112),
    "mediumslateblue": RGBColor(r: 123, g: 104, b: 238),
    "slateblue"      : RGBColor(r: 106, g: 90 , b: 205),
    "darkslateblue"  : RGBColor(r: 72 , g: 61 , b: 139),
    // colors purple -------------------------------
    "lavender"    : RGBColor(r: 230, g: 230, b: 250),
    "thistle"     : RGBColor(r: 216, g: 191, b: 216),
    "plum"        : RGBColor(r: 221, g: 160, b: 221),
    "violet"      : RGBColor(r: 238, g: 130, b: 238),
    "orchid"      : RGBColor(r: 218, g: 112, b: 214),
    "fuchsia"     : RGBColor(r: 255, g: 0  , b: 255),
    "magenta"     : RGBColor(r: 255, g: 0  , b: 255),
    "mediumorchid": RGBColor(r: 186, g: 85 , b: 211),
    "mediumpurple": RGBColor(r: 147, g: 112, b: 219),
    "blueviolet"  : RGBColor(r: 138, g: 43 , b: 226),
    "darkviolet"  : RGBColor(r: 148, g: 0  , b: 211),
    "darkorchid"  : RGBColor(r: 153, g: 50 , b: 204),
    "darkmagenta" : RGBColor(r: 139, g: 0  , b: 139),
    "purple"      : RGBColor(r: 128, g: 0  , b: 128),
    "indigo"      : RGBColor(r: 75 , g: 0  , b: 130),
    // colors pink ------------------------------------
    "pink"           : RGBColor(r: 255, g: 192, b: 203),
    "lightpink"      : RGBColor(r: 255, g: 182, b: 193),
    "hotpink"        : RGBColor(r: 255, g: 105, b: 180),
    "deeppink"       : RGBColor(r: 255, g: 20 , b: 147),
    "palevioletred"  : RGBColor(r: 219, g: 112, b: 147),
    "mediumvioletred": RGBColor(r: 199, g: 21 , b: 133),
    // colors white ---------------------------------
    "white"        : RGBColor(r: 255, g: 255, b: 255),
    "snow"         : RGBColor(r: 255, g: 250, b: 250),
    "honeydew"     : RGBColor(r: 240, g: 255, b: 240),
    "mintcream"    : RGBColor(r: 245, g: 255, b: 250),
    "azure"        : RGBColor(r: 240, g: 255, b: 255),
    "aliceblue"    : RGBColor(r: 240, g: 248, b: 255),
    "ghostwhite"   : RGBColor(r: 248, g: 248, b: 255),
    "whitesmoke"   : RGBColor(r: 245, g: 245, b: 245),
    "seashell"     : RGBColor(r: 255, g: 245, b: 238),
    "beige"        : RGBColor(r: 245, g: 245, b: 220),
    "oldlace"      : RGBColor(r: 253, g: 245, b: 230),
    "floralwhite"  : RGBColor(r: 255, g: 250, b: 240),
    "ivory"        : RGBColor(r: 255, g: 255, b: 240),
    "antiquewhite" : RGBColor(r: 250, g: 235, b: 215),
    "linen"        : RGBColor(r: 250, g: 240, b: 230),
    "lavenderblush": RGBColor(r: 255, g: 240, b: 245),
    "mistyrose"    : RGBColor(r: 255, g: 228, b: 225),
    // colors gray -----------------------------------
    "gainsboro"     : RGBColor(r: 220, g: 220, b: 220),
    "lightgray"     : RGBColor(r: 211, g: 211, b: 211),
    "silver"        : RGBColor(r: 192, g: 192, b: 192),
    "darkgray"      : RGBColor(r: 169, g: 169, b: 169),
    "gray"          : RGBColor(r: 128, g: 128, b: 128),
    "dimgray"       : RGBColor(r: 105, g: 105, b: 105),
    "lightslategray": RGBColor(r: 119, g: 136, b: 153),
    "slategray"     : RGBColor(r: 112, g: 128, b: 144),
    "darkslategray" : RGBColor(r: 47 , g: 79 , b: 79 ),
    "black"         : RGBColor(r: 0  , g: 0  , b: 0  ),
    // colors brown ----------------------------------
    "cornsilk"      : RGBColor(r: 255, g: 248, b: 220),
    "blanchedalmond": RGBColor(r: 255, g: 235, b: 205),
    "bisque"        : RGBColor(r: 255, g: 228, b: 196),
    "navajowhite"   : RGBColor(r: 255, g: 222, b: 173),
    "wheat"         : RGBColor(r: 245, g: 222, b: 179),
    "burlywood"     : RGBColor(r: 222, g: 184, b: 135),
    "tan"           : RGBColor(r: 210, g: 180, b: 140),
    "rosybrown"     : RGBColor(r: 188, g: 143, b: 143),
    "sandybrown"    : RGBColor(r: 244, g: 164, b: 96 ),
    "goldenrod"     : RGBColor(r: 218, g: 165, b: 32 ),
    "peru"          : RGBColor(r: 205, g: 133, b: 63 ),
    "chocolate"     : RGBColor(r: 210, g: 105, b: 30 ),
    "saddlebrown"   : RGBColor(r: 139, g: 69 , b: 19 ),
    "sienna"        : RGBColor(r: 160, g: 82 , b: 45 ),
    "brown"         : RGBColor(r: 165, g: 42 , b: 42 ),
    "maroon"        : RGBColor(r: 128, g: 0  , b: 0  )
  ];
  
  public static func normalizeHexString(_ hex: String?) -> String {
    guard var hexString = hex else {
      return "00000000";
    };
    
    if hexString.hasPrefix("#") {
      hexString = String(hexString.dropFirst());
    };
    
    if hexString.count == 3 || hexString.count == 4 {
      hexString = hexString.map { "\($0)\($0)" }.joined();
    };
    
    let hasAlpha = hexString.count > 7;
    if !hasAlpha {
      hexString += "ff";
    };
    
    return hexString;
  };
  
  @available(iOS 13.0, *)
  public static func elementColorFromString(_ string: String) -> UIColor? {
    switch string {
      // Label Colors
      case "label":
        return .label;
        
      case "secondaryLabel":
        return .secondaryLabel;
        
      case "tertiaryLabel":
        return .tertiaryLabel;
        
      case "quaternaryLabel":
        return .quaternaryLabel;
        
      // Fill Colors
      case "systemFill":
        return .systemFill;
        
      case "secondarySystemFill":
        return .secondarySystemFill;
        
      case "tertiarySystemFill":
        return .tertiarySystemFill;
        
      case "quaternarySystemFill":
        return .quaternarySystemFill;
        

      // Text Colors
      case "placeholderText":
        return .placeholderText;

      // Standard Content Background Colors
      case "systemBackground":
        return .systemBackground;
        
      case "secondarySystemBackground":
        return .secondarySystemBackground;
        
      case "tertiarySystemBackground":
        return .tertiarySystemBackground;

      // Grouped Content Background Colors
      case "systemGroupedBackground":
        return .systemGroupedBackground;
        
      case "secondarySystemGroupedBackground":
        return .secondarySystemGroupedBackground;
        
      case "tertiarySystemGroupedBackground":
        return .tertiarySystemGroupedBackground;
        
      // Separator Colors
      case "separator":
        return .separator;
        
      case "opaqueSeparator":
        return .opaqueSeparator;
        
      // Link Color
      case "link":
        return .link;

      // Non-adaptable Colors
      case "darkText":
        return .darkText;
        
      case "lightText":
        return .lightText;
        
      default:
        return nil;
    };
  };
  
  public static func systemColorFromString(_ string: String) -> UIColor? {
    switch string {
      // Adaptable Colors
      case "systemBlue":
        return .systemBlue;
        
      case "systemGreen":
        return .systemGreen;
        
      case "systemOrange":
        return .systemOrange;
        
      case "systemPink":
        return .systemPink;
        
      case "systemPurple":
        return .systemPurple;
        
      case "systemRed":
        return .systemRed;
        
      case "systemTeal":
        return .systemTeal;
        
      case "systemYellow":
        return .systemYellow;
        
      default:
        break;
    };
    
    if #available(iOS 13.0, *) {
      switch string {
        case "systemIndigo":
          return .systemIndigo;
          
        //Adaptable Gray Colors
        case "systemGray":
          return .systemGray;
          
        case "systemGray2":
          return .systemGray2;
          
        case "systemGray3":
          return .systemGray3;
          
        case "systemGray4":
          return .systemGray4;
          
        case "systemGray5":
          return .systemGray5;
          
        case "systemGray6":
          return .systemGray6;
          
        default:
          break;
      };
    };
    
    return nil;
  };
  
  /// Parse "react native" color to `UIColor`
  /// Swift impl. of `RCTConvert` color
  public static func parseColor(value: Any) -> UIColor? {
    if let string = value as? String {
      if #available(iOS 13.0, *),
         let color = Self.elementColorFromString(string) {
        
        // a: iOS 13+ ui enum colors
        return color;
        
      } else if let color = Self.systemColorFromString(string) {
        // b: iOS system enum colors
        return color;
        
      } else {
        // c: react-native color string
        return UIColor(cssColor: string);
      };
      
    } else if let dict = value as? NSDictionary {
      // d: react-native DynamicColor object
      return UIColor(dynamicDict: dict);
    };
    
    return nil;
  };
};
