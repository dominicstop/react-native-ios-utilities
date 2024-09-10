//
//  ViewLifecycleEventsNotifiable.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/11/24.
//

import Foundation

public protocol ViewLifecycleEventsNotifiable: AnyObject {
  
  func notifyOnViewWillMoveToWindow(
    sender: UIView,
    newWindow: UIWindow?
  );
  
  func notifyOnViewDidMoveToWindow(
    sender: UIView
  );
  
  func notifyOnViewWillMoveToSuperview(
    sender: UIView,
    newSuperview: UIView?
  );
  
  func notifyOnViewDidMoveToSuperview(
    sender: UIView
  );
  
  func notifyOnViewLayoutSubviews(
    sender: UIView
  );
  
  func notifyOnViewRemovedFromSuperview(
    sender: UIView
  );
  
  func notifyOnViewDidAddSubview(
    sender: UIView,
    subview: UIView
  );
  
  func notifyOnViewWillRemoveSubview(
    sender: UIView,
    subview: UIView
  );
};

// MARK: - ViewLifecycleEventsNotifiable+Default
// ---------------------------------------------

public extension ViewLifecycleEventsNotifiable {
  
  func notifyOnViewWillMoveToWindow(
    sender: UIView,
    newWindow: UIWindow?
  ) {
    // no-op
  };
  
  func notifyOnViewDidMoveToWindow(
    sender: UIView
  ) {
    // no-op
  };
  
  func notifyOnViewWillMoveToSuperview(
    sender: UIView,
    newSuperview: UIView?
  ) {
    // no-op
  };
  
  func notifyOnViewDidMoveToSuperview(
    sender: UIView
  ) {
    // no-op
  };
  
  func notifyOnViewLayoutSubviews(
    sender: UIView
  ) {
    // no-op
  };
  
  func notifyOnViewRemovedFromSuperview(
    sender: UIView
  ) {
    // no-op
  };
  
  func notifyOnViewDidAddSubview(
    sender: UIView,
    subview: UIView
  ) {
    // no-op
  };
  
  func notifyOnViewWillRemoveSubview(
    sender: UIView,
    subview: UIView
  ) {
    // no-op
  };
};
