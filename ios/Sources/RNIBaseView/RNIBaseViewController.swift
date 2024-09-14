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
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var contentView: RNIContentViewDelegate? {
    self.rootReactView?.contentDelegate;
  };
  
  // MARK: - View Controller Lifecycle
  // ---------------------------------

  public override func viewDidLoad() {
    guard let rootReactView = self.rootReactView else {
      return;
    };
    
    #if DEBUG && false
    self.log();
    #endif
    
    rootReactView.reactViewLifecycleDelegates.add(self);
    
    // MARK: Setup Constraints
    #if !RCT_NEW_ARCH_ENABLED
    rootReactView.removeAllAncestorConstraints();
    #endif
    
    rootReactView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(rootReactView);
        
    let constraints = self.positionConfig.createConstraints(
      forView: rootReactView,
      attachingTo: self.view,
      enclosingView: self.view
    );
    
    NSLayoutConstraint.activate(constraints);
    
    // MARK: Set Initial Size
    let hasValidSize = !self.view.bounds.size.isZero;
    if hasValidSize {
      self.positionConfig.setIntrinsicContentSizeOverrideIfNeeded(
        forRootReactView: rootReactView,
        withSize: self.view.bounds.size
      );
    };
    
    let shouldSetSize =
         hasValidSize
      && self.positionConfig.isStretchingOnBothAxis;
      
    if shouldSetSize {
      self.positionConfig.applySize(
        toRootReactView: rootReactView,
        attachingTo: self.view
      );
    };
  };

  public override func viewDidLayoutSubviews() {
    guard let rootReactView = self.rootReactView else {
      return;
    };
    
    #if DEBUG && false
    self.log();
    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
      self.log();
    };
    #endif
    
    self.positionConfig.setIntrinsicContentSizeOverrideIfNeeded(
      forRootReactView: rootReactView,
      withSize: self.view.bounds.size
    );
    
    self.positionConfig.applySize(
      toRootReactView: rootReactView,
      attachingTo: self.view
    );
  };
  
  // MARK: Methods
  // --------------
  
  #if DEBUG
  func log(funcString: String = #function){
    print(
      "RNIBaseViewController.\(funcString)",
      "\n - positionConfig:", self.positionConfig,
      
      "\n - window.size:",
        self.view.window?.bounds.size.debugDescription ?? "N/A",
        
      "\n - view.size:", self.view.bounds.size,
      
      "\n - view.globalFrame:",
        self.view.globalFrame?.debugDescription ?? "N/A",
        
      "\n - view.layer.frame:",
        self.view.layer.presentation()?.frame.debugDescription ?? "N/A",
        
      "\n - superview.size:",
        self.view.superview?.bounds.size.debugDescription ?? "N/A",
      
      "\n - superview.globalFrame:",
        self.view.superview?.globalFrame?.debugDescription ?? "N/A",
        
      "\n - rootReactView.size:",
        self.rootReactView?.bounds.size.debugDescription ?? "N/A",
        
      "\n - rootReactView.cachedLayoutMetrics.contentFrame:",
        self.rootReactView?.cachedLayoutMetrics?.contentFrame.debugDescription ?? "N/A",
        
      "\n - rootReactView.globalFrame:",
        self.rootReactView?.globalFrame?.debugDescription ?? "N/A",
        
      "\n - rootReactView.layer.frame:",
        self.rootReactView?.layer.presentation()?.frame.debugDescription ?? "N/A",
        
      "\n - rootReactView.intrinsicContentSize:",
        self.rootReactView?.intrinsicContentSize.debugDescription ?? "N/A",
        
      "\n - contentDelegate.bounds.size:",
        self.rootReactView?.contentDelegate.bounds.size.debugDescription ?? "N/A",
        
      "\n - contentDelegate.globalFrame:",
        self.rootReactView?.contentDelegate.globalFrame?.debugDescription ?? "N/A",
        
      "\n - contentDelegate.layer.frame:",
        self.rootReactView?.contentDelegate.layer.presentation()?.frame.debugDescription ?? "N/A",
        
      "\n"
    );
  };
  #endif
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
