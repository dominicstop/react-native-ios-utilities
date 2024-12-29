//
//  AnimationConfig+InitializableFromDictionary.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/22/23.
//

import Foundation
import DGSwiftUtilities

extension AnimationConfig: InitializableFromDictionary {
  
  public init(fromDict dict: Dictionary<String, Any>) throws {
    let modeString = try dict.getString(forKey: "mode");
    
    switch modeString {
      case "animator":
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Not supported",
          extraDebugValues: [
            "modeString": modeString
          ]
        );
        
      case "presetCurve":
        let duration = try dict.getValue(
          forKey: "duration",
          type: TimeInterval.self
        );
        
        let curve = try dict.getValue(
          forKey: "curve",
          type: UIView.AnimationCurve.self
        );
        
        self = .presetCurve(
          duration: duration,
          curve: curve
        );
        
      case "presetSpring":
        let duration = try dict.getValue(
          forKey: "duration",
          type: TimeInterval.self
        );
        
        let dampingRatio = try dict.getValue(
          forKey: "dampingRatio",
          type: CGFloat.self
        );
        
        self = .presetSpring(
          duration: duration,
          dampingRatio: dampingRatio
        );
        
      case "bezierCurve":
        let duration = try dict.getValue(
          forKey: "duration",
          type: TimeInterval.self
        );
        
        let controlPoint1 = try dict.getValue(
          forKey: "controlPoint1",
          type: CGPoint.self
        );
        
        let controlPoint2 = try dict.getValue(
          forKey: "controlPoint2",
          type: CGPoint.self
        );
        
        self = .bezierCurve(
          duration: duration,
          controlPoint1: controlPoint1,
          controlPoint2: controlPoint2
        );
        
      case "springDamping":
        let duration = try dict.getValue(
          forKey: "duration",
          type: TimeInterval.self
        );
        
        let dampingRatio = try dict.getValue(
          forKey: "dampingRatio",
          type: CGFloat.self
        );
        
        let initialVelocity = try? dict.getValue(
          forKey: "initialVelocity",
          type: CGVector.self
        );
        
        let maxVelocity = try? dict.getValue(
          forKey: "maxVelocity",
          type: CGFloat.self
        );
        
        self = .springDamping(
          duration: duration,
          dampingRatio: dampingRatio,
          initialVelocity: initialVelocity,
          maxVelocity: maxVelocity
        );
        
      case "springPhysics":
        let duration = try dict.getValue(
          forKey: "duration",
          type: TimeInterval.self
        );
        
        let mass = try dict.getValue(
          forKey: "mass",
          type: CGFloat.self
        );
        
        let stiffness = try dict.getValue(
          forKey: "stiffness",
          type: CGFloat.self
        );
        
        let damping = try dict.getValue(
          forKey: "damping",
          type: CGFloat.self
        );
        
        let initialVelocity = try? dict.getValue(
          forKey: "initialVelocity",
          type: CGVector.self
        );
        
        let maxVelocity = try? dict.getValue(
          forKey: "maxVelocity",
          type: CGFloat.self
        );
        
        self = .springPhysics(
          duration: duration,
          mass: mass,
          stiffness: stiffness,
          damping: damping,
          initialVelocity: initialVelocity,
          maxVelocity: maxVelocity
        );
        
      case "springGesture":
        let duration = try dict.getValue(
          forKey: "duration",
          type: TimeInterval.self
        );
        
        let dampingRatio = try dict.getValue(
          forKey: "dampingRatio",
          type: CGFloat.self
        );
        
        let maxGestureVelocity = try dict.getValue(
          forKey: "maxGestureVelocity",
          type: CGFloat.self
        );
        
        self = .springGesture(
          duration: duration,
          dampingRatio: dampingRatio,
          maxGestureVelocity: maxGestureVelocity
        );
        
      default:
        throw RNIUtilitiesError(
          errorCode: .invalidArgument,
          description: "Invalid value for modeString",
          extraDebugValues: [
            "modeString": modeString
          ]
        );
    };
  };
};

// MARK: - Dictionary+AnimationConfig
// ----------------------------------

public extension Dictionary where Key == String {
  
  func getAnimationConfig(forKey key: String) throws -> AnimationConfig {
    let dictConfig = try self.getDict(forKey: key)
    return try .init(fromDict: dictConfig);
  };
  
  func getValue(forKey key: String) throws -> AnimationConfig {
    try self.getAnimationConfig(forKey: key);
  };
};
