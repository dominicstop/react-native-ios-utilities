//
//  RNIBaseViewState.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/31/24.
//

import Foundation
import DGSwiftUtilities

@objc(RNIBaseViewStateSwift)
public class RNIBaseViewState: NSObject {
  
  public var shouldSetSize: Bool?;
  public var frameSize: CGSize?;
  
  public var shouldSetPadding: Bool?;
  public var padding: UIEdgeInsets?;
  
  public var shouldSetPositionType: Bool?;
  public var positionType: RNILayoutMetrics.RNIPositionType?;
  
  // MARK: - Computed Properties
  // ---------------------------
    
  @objc(shouldSetSize)
  public var shouldSetSizeBoxed: NSNumber? {
    guard let shouldSetSize = self.shouldSetSize else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetSize);
  };
  
  @objc(frameSize)
  public var frameSizeBoxed: NSValue? {
    guard let frameSize = self.frameSize else {
      return nil;
    };
    
    return .init(cgSize: frameSize);
  };
  
  @objc(shouldSetPadding)
  public var shouldSetPaddingBoxed: NSNumber? {
    guard let shouldSetPadding = self.shouldSetPadding else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetPadding);
  };
  
  @objc(padding)
  public var paddingBoxed: NSValue? {
    guard let padding = self.padding else {
      return nil;
    };
    
    return .init(uiEdgeInsets: padding);
  };
  
  @objc(shouldSetPositionType)
  public var shouldSetPositionTypeBoxed: NSNumber? {
    guard let shouldSetPositionType = self.shouldSetPositionType else {
      return nil;
    };
    
    return .init(booleanLiteral: shouldSetPositionType);
  };
  
  @objc(positionType)
  public var positionTypeBoxed: NSNumber? {
    guard let positionType = self.positionType else {
      return nil;
    };
    
    return .init(integerLiteral: positionType.rawValue);
  };
  
  // MARK: - Init
  // ------------
  
  init(
    shouldSetSize: Bool? = nil,
    frameSize: CGSize? = nil,
    shouldSetPadding: Bool? = nil,
    padding: UIEdgeInsets? = nil,
    shouldSetPositionType: Bool? = nil,
    positionType: RNILayoutMetrics.RNIPositionType? = nil
  ) {
    self.shouldSetSize = shouldSetSize
    self.frameSize = frameSize
    self.shouldSetPadding = shouldSetPadding
    self.padding = padding
    self.shouldSetPositionType = shouldSetPositionType
    self.positionType = positionType
  }
};
