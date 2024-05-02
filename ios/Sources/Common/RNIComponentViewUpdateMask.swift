//
//  RNIComponentViewUpdateMask.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/2/24.
//

import Foundation

// Mirrors: `RNComponentViewUpdateMask`
// Link: https://github.com/facebook/react-native/blob/67bc65df85d4ee6e00b45ba25882d8ef95d15ca3/packages/react-native/React/Fabric/Mounting/RCTComponentViewProtocol.h#L21-L30
//
// We have to use NSObject so we can use it in objc.
@objc
public final class RNIComponentViewUpdateMask: NSObject, OptionSet, RawRepresentable, CaseIterable {

  // MARK: Options
  // -------------
    
  public static var props: RNIComponentViewUpdateMask {
    return .init(rawValue: 1 << 0);
  };
    
  public static var eventEmitter: RNIComponentViewUpdateMask {
    return .init(rawValue: 1 << 1);
  };
    
  public static var state: RNIComponentViewUpdateMask {
    return .init(rawValue: 1 << 2);
  };
    
  public static var layoutMetrics: RNIComponentViewUpdateMask {
    return .init(rawValue: 1 << 3);
  };
  
  public static var all: RNIComponentViewUpdateMask {
    return [
      .props,
      .eventEmitter,
      .state,
      .layoutMetrics
    ];
  };

  public static var allCases: [RNIComponentViewUpdateMask] {
    return [
      .props,
      .eventEmitter,
      .state,
      .layoutMetrics,
    ];
  };
  
  // MARK: Properties
  // ----------------
  
  @objc
  public let rawValue: NSInteger;
  
  // MARK: Computed Properties
  // -------------------------
  
  var isNone: Bool {
    self.rawValue == 0;
  };
  
  // MARK: Init
  // ----------
  
  @objc
  public init(rawValue: Int) {
    self.rawValue = rawValue;
    super.init();
  };
  
  public override convenience init() {
    self.init(rawValue: 0);
  }
  
  @objc
  @available(swift, obsoleted: 1.0)
  public convenience init(mask: [RNIComponentViewUpdateMask]) {
    self.init(mask);
  };
  
  // MARK: NSObject
  // --------------
  
  public override var hash: Int {
    return self.rawValue;
  };

  public override func isEqual(_ otherObject: Any?) -> Bool {
    guard let otherObject = otherObject as? Self else {
      return false;
    };

    return self.rawValue == otherObject.rawValue
  };
};
