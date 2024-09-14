//
//  RNIBaseViewController.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/5/24.
//

import Foundation
import DGSwiftUtilities

#if !RCT_NEW_ARCH_ENABLED
import React
#endif

/// Holds/wraps a `RNIBaseView` instance (i.e. `RNIContentViewParentDelegate`)
///
open class RNIBaseViewController: UIViewController {

  public var shouldTriggerDefaultCleanup = true;
  
  public weak var rootReactView: RNIContentViewParentDelegate?;
  
  /// Position config for `rootReactView`
  public var positionConfig: AlignmentPositionConfig = .default;
  
  public var contentView: RNIContentViewDelegate? {
    self.rootReactView?.contentDelegate;
  };

  public override func viewDidLoad() {
    guard let rootReactView = self.rootReactView else {
      return;
    };
    
    rootReactView.removeAllAncestorConstraints();
    
    rootReactView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(rootReactView);
    
    self.positionConfig.setIntrinsicContentSizeOverrideIfNeeded(
      forRootReactView: rootReactView,
      withSize: self.view.bounds.size
    );
    
    let constraints = self.positionConfig.createConstraints(
      forView: rootReactView,
      attachingTo: self.view,
      enclosingView: self.view
    );
    
    NSLayoutConstraint.activate(constraints);
    rootReactView.reactViewLifecycleDelegates.add(self);
  };

  public override func viewDidLayoutSubviews() {
    guard let rootReactView = self.rootReactView else {
      return;
    };
    
    self.positionConfig.setIntrinsicContentSizeOverrideIfNeeded(
      forRootReactView: rootReactView,
      withSize: self.view.bounds.size
    );
    
    self.positionConfig.applySize(
      toRootReactView: rootReactView,
      attachingTo: self.view
    );
  };
};

extension RNIBaseViewController: RNIViewLifecycle {
  
  public func notifyOnRequestForCleanup(sender: RNIContentViewParentDelegate) {
    guard self.shouldTriggerDefaultCleanup,
          self.view.window != nil
    else {
      return;
    };
    
    if self.presentingViewController != nil {
      self.dismiss(animated: true);
      
    } else if self.parent != nil {
      self.willMove(toParent: nil);
      self.view.removeFromSuperview();
      self.removeFromParent();
      
    } else {
      self.view.removeFromSuperview();
    };
  };
};
