//
//  RNIImageMaker.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/1/22.
//

import Foundation

public struct RNIImageMaker {
  
  // MARK: - Properties
  // ------------------

  public let size        : CGSize;
  public let fillColor   : UIColor;
  public let borderRadius: CGFloat;
  
  // MARK: - Init
  // ------------
  
  public init?(dict: NSDictionary) {
    guard let width  = dict["width" ] as? CGFloat,
          let height = dict["height"] as? CGFloat
    else { return nil };
    
    self.size = CGSize(width: width, height: height);
    
    guard let fillColorValue = dict["fillColor" ],
          let fillColor      = UIColor.parseColor(value: fillColorValue)
    else { return nil };
    
    self.fillColor = fillColor;
    
    self.borderRadius = dict["borderRadius"] as? CGFloat ?? 0;
  };
  
  // MARK: - Functions
  // --------------------

  public func makeImage() -> UIImage {
    return UIGraphicsImageRenderer(size: self.size).image { context in
      let rect = CGRect(origin: .zero, size: self.size);
      
      let clipPath = UIBezierPath(
        roundedRect : rect,
        cornerRadius: self.borderRadius
      );
      
      clipPath.addClip();
      self.fillColor.setFill();
      
      context.fill(rect);
    };
  };
};
