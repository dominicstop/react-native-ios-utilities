//
//  RNIImageOptions.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/28/22.
//

import Foundation
import DGSwiftUtilities


@available(*, deprecated, message: "Use `ImageConfig` instead")
public struct RNIImageOptions {

  // MARK: - Properties
  // ------------------

  var tint: UIColor?;
  var renderingMode: UIImage.RenderingMode;
  var cornerRadius: CGFloat?;
  
  // MARK: - Init
  // ------------
  
  init(dict: Dictionary<String, Any>){
    self.tint = {
      guard let value = dict["tint"],
            let color = UIColor.parseColor(value: value)
      else { return nil };
      
      return color;
    }();
    
    self.renderingMode = {
      guard let string = dict["renderingMode"] as? String,
            let mode = try? UIImage.RenderingMode(fromString: string)
      else { return .automatic };
      
      return mode;
    }();
    
    self.cornerRadius = dict["cornerRadius"] as? CGFloat;
  };
};
