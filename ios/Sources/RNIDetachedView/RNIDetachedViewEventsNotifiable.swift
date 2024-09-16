//
//  RNIDetachedViewEventsNotifiable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/17/24.
//

import Foundation

public protocol RNIDetachedViewEventsNotifiable: AnyObject {
  
  func didDetachContent(
    sender: RNIDetachedViewContent,
    subview: RNIContentViewParentDelegate
  );
  
  func didDetachFromParent(sender: RNIDetachedViewContent);
  
  func didReceiveSubviewToDetach(
    sender: RNIDetachedViewContent,
    subview: RNIContentViewParentDelegate
  );
  
  func onReactChildrenCountDidChange(
    sender: RNIDetachedViewContent,
    oldCount: Int,
    newCount: Int
  );
};

// MARK: - RNIDetachedViewEventsNotifiable+Default
// -----------------------------------------------

public extension RNIDetachedViewEventsNotifiable {
  
  func didDetachContent(
    sender: RNIDetachedViewContent,
    subview: RNIContentViewParentDelegate
  ) {
    // no-op
  };
  
  func didDetachFromParent(sender: RNIDetachedViewContent) {
    // no-op
  };
  
  func didReceiveSubviewToDetach(
    sender: RNIDetachedViewContent,
    subview: RNIContentViewParentDelegate
  ) {
    // no-op
  };
  
  func onReactChildrenCountDidChange(
    sender: RNIDetachedViewContent,
    oldCount: Int,
    newCount: Int
  ) {
    // no-op
  };
};
