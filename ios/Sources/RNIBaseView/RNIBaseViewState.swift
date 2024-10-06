//
//  RNIBaseViewState.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/31/24.
//

import Foundation
import DGSwiftUtilities

@objc(RNIBaseViewStateSwift)
open class RNIBaseViewState: NSObject {
  
  public var frameSize: CGSize?;
  public var shouldSetSize: Bool?;
  
  public var padding: UIEdgeInsets?;
  public var shouldSetPadding: Bool?;
  
  public var positionType: RNILayoutMetrics.RNIPositionType?;
  public var shouldSetPositionType: Bool?;
  
  public var minSize: CGSize?;
  public var shouldSetMinHeight: Bool?;
  public var shouldSetMinWidth: Bool?;
  
  public var maxSize: CGSize?;
  public var shouldSetMaxWidth: Bool?;
  public var shouldSetMaxHeight: Bool?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  @objc(frameSize)
  public var frameSizeBoxed: NSValue? {
    guard let frameSize = self.frameSize else {
      return nil;
    };
    
    return .init(cgSize: frameSize);
  };
  
  @objc(shouldSetSize)
  public var shouldSetSizeBoxed: NSNumber? {
    guard let shouldSetSize = self.shouldSetSize else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetSize);
  };
  
  @objc(padding)
  public var paddingBoxed: NSValue? {
    guard let padding = self.padding else {
      return nil;
    };
    
    return .init(uiEdgeInsets: padding);
  };
  
  @objc(shouldSetPadding)
  public var shouldSetPaddingBoxed: NSNumber? {
    guard let shouldSetPadding = self.shouldSetPadding else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetPadding);
  };
  
  @objc(positionType)
  public var positionTypeBoxed: NSNumber? {
    guard let positionType = self.positionType else {
      return nil;
    };
    
    return .init(integerLiteral: positionType.rawValue);
  };
  
  @objc(shouldSetPositionType)
  public var shouldSetPositionTypeBoxed: NSNumber? {
    guard let shouldSetPositionType = self.shouldSetPositionType else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetPositionType);
  };
  
  @objc(minSize)
  public var minSizeBoxed: NSValue? {
    guard let minSize = self.minSize else {
      return nil;
    };
    
    return .init(cgSize: minSize);
  };
  
  @objc(shouldSetMinHeight)
  public var shouldSetMinHeightBoxed: NSNumber? {
    guard let shouldSetMinHeight = self.shouldSetMinHeight else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetMinHeight);
  };
  
  @objc(shouldSetMinWidth)
  public var shouldSetMinWidthBoxed: NSNumber? {
    guard let shouldSetMinWidth = self.shouldSetMinWidth else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetMinWidth);
  };
  
  @objc(maxSize)
  public var maxSizeBoxed: NSValue? {
    guard let maxSize = self.maxSize else {
      return nil;
    };
    
    return .init(cgSize: maxSize);
  };
  
  @objc(shouldSetMaxWidth)
  public var shouldSetMaxWidthBoxed: NSNumber? {
    guard let shouldSetMaxWidth = self.shouldSetMaxWidth else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetMaxWidth);
  };
  
  @objc(shouldSetMaxHeight)
  public var shouldSetMaxHeightBoxed: NSNumber? {
    guard let shouldSetMaxHeight = self.shouldSetMaxHeight else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetMaxHeight);
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    shouldSetSize: Bool? = nil,
    frameSize: CGSize? = nil,
    shouldSetPadding: Bool? = nil,
    padding: UIEdgeInsets? = nil,
    shouldSetPositionType: Bool? = nil,
    positionType: RNILayoutMetrics.RNIPositionType? = nil,
    minSize: CGSize? = nil,
    shouldSetMinHeight: Bool? = nil,
    shouldSetMinWidth: Bool? = nil,
    maxSize: CGSize? = nil,
    shouldSetMaxWidth: Bool? = nil,
    shouldSetMaxHeight: Bool? = nil
  ) {
    self.shouldSetSize = shouldSetSize;
    self.frameSize = frameSize;
    self.shouldSetPadding = shouldSetPadding;
    self.padding = padding;
    self.shouldSetPositionType = shouldSetPositionType;
    self.positionType = positionType;
    self.positionType = positionType;
    self.minSize = minSize;
    self.shouldSetMinHeight = shouldSetMinHeight;
    self.shouldSetMinWidth = shouldSetMinWidth;
    self.maxSize = maxSize;
    self.shouldSetMaxWidth = shouldSetMaxWidth;
    self.shouldSetMaxHeight = shouldSetMaxHeight;
  }
};
