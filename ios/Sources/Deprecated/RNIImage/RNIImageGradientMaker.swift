//
//  RNIImageGradientMaker.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/26/22.
//

import UIKit
import DGSwiftUtilities


@available(*, deprecated, message: "Use `ImageConfig` instead")
public struct RNIImageGradientMaker {

  // MARK: Embedded Types
  // --------------------

  public enum PointPresets: String {
    case top, bottom, left, right;
    case bottomLeft, bottomRight, topLeft, topRight;
    
    public var cgPoint: CGPoint {
      switch self {
        case .top   : return CGPoint(x: 0.5, y: 0.0);
        case .bottom: return CGPoint(x: 0.5, y: 1.0);
          
        case .left : return CGPoint(x: 0.0, y: 0.5);
        case .right: return CGPoint(x: 1.0, y: 0.5);
          
        case .bottomLeft : return CGPoint(x: 0.0, y: 1.0);
        case .bottomRight: return CGPoint(x: 1.0, y: 1.0);

        case .topLeft : return CGPoint(x: 0.0, y: 0.0);
        case .topRight: return CGPoint(x: 1.0, y: 0.0);
      };
    };
  };
  
  public enum DirectionPresets: String {
    // horizontal
    case leftToRight, rightToLeft;
    
    // vertical
    case topToBottom, bottomToTop;
    
    // diagonal
    case topLeftToBottomRight, topRightToBottomLeft;
    case bottomLeftToTopRight, bottomRightToTopLeft;
    
    public var point: (start: CGPoint, end: CGPoint) {
      switch self {
        case .leftToRight:
          return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 1.5));
          
        case .rightToLeft:
          return (CGPoint(x: 1.0, y: 0.5), CGPoint(x: 0.0, y: 0.5));
          
        case .topToBottom:
          return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0));
          
        case .bottomToTop:
          return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0));
          
        case .topLeftToBottomRight:
          return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 1.0));
          
        case .topRightToBottomLeft:
          return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0));
          
        case .bottomLeftToTopRight:
          return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0));
          
        case .bottomRightToTopLeft:
          return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0));
      };
    };
  };
  
  // MARK: Static Functions
  // ----------------------
  
  static private func extractCGPoint(dict: Dictionary<String, Any>) -> CGPoint? {
    guard let x = dict["x"] as? CGFloat,
          let y = dict["y"] as? CGFloat
    else { return nil };
    
    return CGPoint(x: x, y: y);
  };
  
  static private func extractPoint(dict: Dictionary<String, Any>, key: String) -> CGPoint? {
    guard let rawValue = dict[key] else { return nil };
  
    if let pointDict = rawValue as? Dictionary<String, Any>,
       let point = Self.extractCGPoint(dict: pointDict) {
      
      return point;
      
    } else if let pointString = rawValue as? String,
              let point = PointPresets(rawValue: pointString) {
      
      return point.cgPoint;
      
    } else {
      return nil;
    };
  };
  
  // MARK: Properties
  // ----------------
  
  public var type: CAGradientLayerType;
  
  public var colors    : [CGColor];
  public var locations : [NSNumber]?;
  public var startPoint: CGPoint;
  public var endPoint  : CGPoint;
  
  public var size: CGSize;
  public var borderRadius: CGFloat;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var gradientLayer: CALayer {
    let layer = CAGradientLayer();
    
    layer.type         = self.type;
    layer.colors       = self.colors;
    layer.locations    = self.locations;
    layer.startPoint   = self.startPoint;
    layer.endPoint     = self.endPoint;
    layer.cornerRadius = self.borderRadius;
    
    return layer;
  };
  
  // MARK: - Init
  // ------------
  
  public init?(dict: Dictionary<String, Any>) {
    guard let colors = dict["colors"] as? NSArray
    else { return nil };
    
    self.colors = colors.compactMap {
      guard let string = $0 as? String,
            let color = UIColor(cssColor: string)
      else { return nil };
      
      return color.cgColor;
    };
    
    self.type = {
      guard let string = dict["type"] as? String,
            let type = CAGradientLayerType(fromString: string)
      else { return .axial };
      
      return type;
    }();
    
    self.locations = {
      guard let locations = dict["locations"] as? NSArray else { return nil };
      return locations.compactMap { $0 as? NSNumber };
    }();
    
    self.startPoint = Self.extractPoint(dict: dict, key: "startPoint")
      ?? PointPresets.top.cgPoint;
    
    self.endPoint = Self.extractPoint(dict: dict, key: "endPoint")
      ?? PointPresets.bottom.cgPoint;
    
    self.size = CGSize(
      width : (dict["width" ] as? CGFloat) ?? 0,
      height: (dict["height"] as? CGFloat) ?? 0
    );
    
    self.borderRadius = dict["borderRadius"] as? CGFloat ?? 0;
  };
  
  // MARK: - Functions
  // -----------------
  
  public mutating func setSizeIfNotSet(_ newSize: CGSize){
    let nextWidth = self.size.width  <= 0
      ? newSize.width
      : self.size.width;
      
    let nextHeight = self.size.height <= 0
      ? newSize.height
      : self.size.height;
  
    self.size = CGSize(width : nextWidth, height: nextHeight);
  };
  
  public func makeImage() -> UIImage {
    return UIGraphicsImageRenderer(size: self.size).image { context in
      let rect = CGRect(origin: .zero, size: self.size);
      
      let gradient = self.gradientLayer;
      gradient.frame = rect;
      gradient.render(in: context.cgContext);
      
      let clipPath = UIBezierPath(
        roundedRect : rect,
        cornerRadius: self.borderRadius
      );
      
      clipPath.addClip();
    };
  };
};
