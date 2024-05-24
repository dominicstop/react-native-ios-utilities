//
//  RNILayoutMetrics.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit

@objc
public class RNILayoutMetrics: NSObject {

  // MARK: - Embedded Types
  // ----------------------

  @objc
  public enum RNIDisplayType: Int, CustomStringConvertible {
    case none = 0;
    case flex = 1;
    case inline = 2;
    
    public var description: String {
      switch self {
        case .none:
          return "none";
          
        case .flex:
          return "flex";
          
        case .inline:
          return "inline";
      };
    };
  };

  @objc
  public enum RNIPositionType: Int, CustomStringConvertible {
    case `static` = 0;
    case relative = 1;
    case absolute = 2;
    
    public var description: String {
      switch self {
        case .static:
          return "static";
        case .relative:
          return "relative";
        case .absolute:
          return "absolute";
      };
    };
  };
  
  @objc
  public enum RNILayoutDirection: Int, CustomStringConvertible {
    case undefined = 0;
    case leftToRight = 1;
    case rightToLeft = 2;
    
    public var description: String {
      switch self {
        case .undefined:
          return "undefined";
          
        case .leftToRight:
          return "leftToRight";
          
        case .rightToLeft:
          return "rightToLeft";
      };
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  @objc public var frame: CGRect = .zero;
  @objc public var contentInsets: UIEdgeInsets = .zero;
  @objc public var overflowInset: UIEdgeInsets = .zero;
  
  @objc public var contentFrame: CGRect = .zero;
  @objc public var paddingFrame: CGRect = .zero;
  
  @objc public var displayTypeRaw: Int = RNIDisplayType.flex.rawValue;
  @objc public var positionTypeRaw: Int = RNIPositionType.relative.rawValue;
  @objc public var layoutDirectionRaw: Int = RNILayoutDirection.leftToRight.rawValue;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var displayType: RNIDisplayType? {
    .init(rawValue: self.displayTypeRaw);
  };
  
  public var positionType: RNIPositionType? {
    .init(rawValue: self.positionTypeRaw);
  };
  
  public var layoutDirection: RNILayoutDirection? {
    .init(rawValue: self.positionTypeRaw);
  };
  
  public override var description: String {
    let strings: [String] = [
      "RNILayoutMetrics:",
      "\n - frame:", self.frame.debugDescription,
      "\n - contentFrame: ", self.contentFrame.debugDescription,
      "\n - paddingFrame: ", self.paddingFrame.debugDescription,
      "\n - displayType: ", self.displayType?.description ?? "N/A",
      "\n - positionType: ", self.positionType?.description ?? "N/A",
      "\n - layoutDirection: ", self.layoutDirection?.description ?? "N/A",
    ];
    
    return strings.reduce(into: "") {
      $0 = $0 + $1;
    };
  };
};
