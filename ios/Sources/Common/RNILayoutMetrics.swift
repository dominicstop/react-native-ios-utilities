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
  public enum RNIDisplayType: Int {
    case none = 0;
    case flex = 1;
    case inline = 2;
  };

  @objc
  public enum RNIPositionType: Int {
    case `static` = 0;
    case relative = 1;
    case absolute = 2;
  };
  
  @objc
  public enum RNILayoutDirection: Int {
    case undefined = 0;
    case leftToRight = 1;
    case rightToLeft = 2;
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
  
  public var displayType: RNIDisplayType {
    .init(rawValue: self.displayTypeRaw) ?? .flex;
  };
  
  public var positionType: RNIPositionType? {
    .init(rawValue: self.positionTypeRaw) ?? .relative;
  };
  
  public var layoutDirection: RNILayoutDirection? {
    .init(rawValue: self.positionTypeRaw) ?? .leftToRight;
  };
};
