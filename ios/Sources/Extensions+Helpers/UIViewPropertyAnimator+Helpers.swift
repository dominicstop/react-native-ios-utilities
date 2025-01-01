//
//  UIViewPropertyAnimator+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 12/31/24.
//

import UIKit
import DGSwiftUtilities


public extension UIViewPropertyAnimator {
  
  var objectMetadataDict: Dictionary<String, Any> {
    [
      "duration": self.duration,
      "delay": self.delay,
      "isInterruptible": self.isInterruptible,
      "isUserInteractionEnabled": self.isUserInteractionEnabled,
      "isManualHitTestingEnabled": self.isManualHitTestingEnabled,
      "scrubsLinearly": self.scrubsLinearly,
      "pausesOnCompletion": self.pausesOnCompletion,
      
      "fractionComplete": self.fractionComplete,
      "isReversed": self.isReversed,
      "state": self.state.caseString,
      "isRunning": self.isRunning,
    ];
  };
  
  func createDidStartEventPayload(
    didCancelPreviousAnimation: Bool? = nil,
    extraPayload: [String: Any]? = nil
  ) -> [String: Any] {
  
    var baseEventDict: [String: Any] = [
      "objectMetadata": self.objectMetadataDict,
    ];
    
    baseEventDict.unwrapAndSet(
      forKey: "didCancelPreviousAnimation",
      with: didCancelPreviousAnimation
    );
    
    baseEventDict.unwrapAndMerge(with: extraPayload);
    return baseEventDict;
  };
  
  func createDidCompleteEventPayload(
    animationPosition: UIViewAnimatingPosition,
    didCancel: Bool? = nil,
    extraPayload: [String: Any]? = nil
  ) -> [String: Any] {
  
    var baseEventDict: [String: Any] = [
      "objectMetadata": self.objectMetadataDict,
      "animationPosition": animationPosition,
    ];
    
    baseEventDict.unwrapAndSet(
      forKey: "didCancel",
      with: didCancel
    );
    
    baseEventDict.unwrapAndMerge(with: extraPayload);
    return baseEventDict;
  };
};
