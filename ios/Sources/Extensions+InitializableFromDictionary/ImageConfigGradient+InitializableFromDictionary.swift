//
//  ImageConfigGradient+InitializableFromDictionary.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/16/24.
//

import UIKit
import DGSwiftUtilities


extension ImageConfigGradient: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let type: CAGradientLayerType = try dict.getValue(forKey: "type");
    
    let colors: [CGColor] = try {
      let colorsRaw = try dict.getArray(
        forKey: "colors",
        elementType: String.self
      );
      
      return colorsRaw.compactMap {
        guard let color = UIColor.parseColor(value: $0) else {
          return nil;
        };
        
        return color.cgColor;
      };
    }();
    
    let locations = try? dict.getArray(
      forKey: "locations",
      elementType: NSNumber.self
    );
    
    let size: CGSize = try dict.getValue(forKey: "size");
    
    let cornerRadius = dict.getValue(
      forKey: "cornerRadius",
      type: CGFloat.self,
      fallbackValue: 0
    );
    
    let startPoint = try? dict.getValue(
      forKey: "startPoint",
      type: CGPoint.self
    );
    
    let startPointPreset = try? dict.getEnum(
      forKey: "startPointPreset",
      type: PointPreset.self
    );
    
    guard let startPoint = startPoint ?? startPointPreset?.point else {
      throw RNIUtilitiesError(
        errorCode: .invalidArgument,
        description: "Could not parse value for key: startPoint",
        extraDebugValues: [
          "dict": dict,
        ]
      );
    };
    
    let endPoint = try? dict.getValue(
      forKey: "endPoint",
      type: CGPoint.self
    );
    
    let endPointPreset = try? dict.getEnum(
      forKey: "endPointPreset",
      type: PointPreset.self
    );
    
    guard let endPoint = endPoint ?? endPointPreset?.point else {
      throw RNIUtilitiesError(
        errorCode: .invalidArgument,
        description: "Could not parse value for key: endPoint",
        extraDebugValues: [
          "dict": dict,
        ]
      );
    };
    
    self.init(
      type: type,
      colors: colors,
      locations: locations,
      startPoint: startPoint,
      endPoint: endPoint,
      size: size,
      cornerRadius: cornerRadius
    );
  };
};

// MARK: - Dictionary+ImageConfigGradient
// --------------------------------------

public extension Dictionary where Key == String {
  
  func getImageGradientConfig(forKey key: String) throws -> ImageConfigGradient {
    let dictConfig = try self.getDict(forKey: key)
    return try .init(fromDict: dictConfig);
  };
  
  func getValue(forKey key: String) throws -> ImageConfigGradient {
    try self.getImageGradientConfig(forKey: key);
  };
};
