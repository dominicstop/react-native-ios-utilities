//
//  UIImageSymbolConfiguration+CreatableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 4/14/24.
//

import UIKit
import DGSwiftUtilities

extension UIImage.SymbolConfiguration: CreatableFromDictionary {
  public static func create(fromDict dict: Dictionary<String, Any>) throws -> Self {
    
    if let pointSize = try? dict.getValue(forKey: "pointSize", type: CGFloat.self) {
      return Self.init(pointSize: pointSize);
    };
    
    if let pointSize = try? dict.getValue(forKey: "pointSize", type: CGFloat.self),
       let weight = try? dict.getValue(forKey: "weight", type: UIImage.SymbolWeight.self) {
       
      return Self.init(pointSize: pointSize, weight: weight);
    };
    
    if let pointSize = try? dict.getValue(forKey: "pointSize", type: CGFloat.self),
       let weight = try? dict.getValue(forKey: "weight", type: UIImage.SymbolWeight.self),
       let scale = try? dict.getValue(forKey: "scale", type: UIImage.SymbolScale.self) {
       
      return Self.init(pointSize: pointSize, weight: weight, scale: scale);
    };
    
    if let textStyle = try? dict.getValue(forKey: "textStyle", type: UIFont.TextStyle.self) {
      return Self.init(textStyle: textStyle);
    };
    
    if let textStyle = try? dict.getValue(forKey: "textStyle", type: UIFont.TextStyle.self),
       let scale = try? dict.getValue(forKey: "scale", type: UIImage.SymbolScale.self) {
       
      return Self.init(textStyle: textStyle, scale: scale);
    };
    
    if let weight: UIImage.SymbolWeight = try? dict.getEnum(forKey: "weight") {
      return Self.init(weight: weight);
    };
    
    // TODO: use `FontConfig`
    if let font = try? dict.getValue(forKey: "font", type: UIFont.self) {
      return Self.init(font: font);
    };
    
    // TODO: use `FontConfig`
    if let font = try? dict.getValue(forKey: "font", type: UIFont.self),
       let scale = try? dict.getValue(forKey: "scale", type: UIImage.SymbolScale.self) {
       
      return Self.init(font: font, scale: scale);
    };
    
    if #available(iOS 15.0, *),
       let hierarchicalColor = try? dict.getColor(forKey: "hierarchicalColor") {
       
      return Self.init(hierarchicalColor: hierarchicalColor);
    };
    
    if #available(iOS 15.0, *),
       let paletteColorsRaw = try? dict.getArray(forKey: "paletteColors") {
       
      let paletteColors: [UIColor] = paletteColorsRaw.compactMap {
        .parseColor(value: $0);
      };
      
      return Self.init(paletteColors: paletteColors);
    };
    
    if let modifier = try? dict.getString(forKey: "modifier") {
      switch modifier {
        case "preferringMulticolor":
          guard #available(iOS 15.0, *) else {
            throw RNIUtilitiesError(
              errorCode: .invalidArgument,
              description: "Unsupported, requires iOS 15+",
              extraDebugValues: [
                "dict": dict,
                "modifier": modifier,
              ]
            );
          };
          
          return .preferringMulticolor();
          
        case "preferringMonochrome":
          guard #available(iOS 16, *) else {
            throw RNIUtilitiesError(
              errorCode: .invalidArgument,
              description: "Unsupported, requires iOS 16+",
              extraDebugValues: [
                "dict": dict,
                "modifier": modifier,
              ]
            );
          };
          
          return .preferringMonochrome();
          
        case "unspecified":
          return Self.unspecified as! Self;
        
        default:
          throw RNIUtilitiesError(
            errorCode: .invalidArgument,
            description: "Invalid values modifier value",
            extraDebugValues: [
              "dict": dict,
              "modifier": modifier,
            ]
          );
      };
    };
    
    if let imageSymbolConfigItemsRaw = try? dict.getArray(
      forKey: "imageSymbolConfigItems",
      elementType: Dictionary<String, Any>.self
    ) {
      let items: [Self] = imageSymbolConfigItemsRaw.compactMap {
        try? .create(fromDict: $0);
      };
      
      guard let firstItem = items.first else {
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Invalid values for imageSymbolConfigItems",
          extraDebugValues: [
            "dict": dict
          ]
        );
      };
      
      return items.reduce(firstItem) {
        $0.applying($1);
      };
    };
    
    throw RNIUtilitiesError(
      errorCode: .invalidArgument,
      description: "Invalid values for dict",
      extraDebugValues: [
        "dict": dict
      ]
    );
  };
};
