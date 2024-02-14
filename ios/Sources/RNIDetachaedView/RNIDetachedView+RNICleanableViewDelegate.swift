//
//  RNIDetachedView+RNICleanableViewDelegate.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/14/24.
//

import Foundation


extension RNIDetachedView: RNICleanableViewDelegate {

  public func notifyOnViewCleanupRequest(
    sender: RNICleanableViewSenderType,
    item: RNICleanableViewItem
  ) -> Bool {
  
    let isViewInactive = self.superview == nil || self.window == nil;
    return isViewInactive && !self._didTriggerCleanup;
  };
  
  public func notifyOnViewCleanupWillBegin(){
    if let touchHandler = self.touchHandler,
       let contentView = self.contentView {
       
      touchHandler.detach(from: contentView);
      self.touchHandler = nil;
    };
  };
  
  public func notifyOnViewCleanupCompletion() {
    self._didTriggerCleanup = true;
  };
};
