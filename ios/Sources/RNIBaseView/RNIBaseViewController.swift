//
//  RNIBaseViewController.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/5/24.
//

import Foundation

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
    
    rootReactView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(rootReactView);
    
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
    
    func log(){
      print(
        "RNIBaseViewController.viewDidLayoutSubviews",
        "\n - self.positionConfig:", self.positionConfig,
        "\n - rootView.size:", self.view.bounds.size,
        "\n - rootView.globalFrame:", self.view.globalFrame?.debugDescription ?? "N/A",
        "\n - rootView.layer.frame:", self.view.layer.presentation()?.frame.debugDescription ?? "N/A",
        "\n - rootReactView.size:", rootReactView.bounds.size,
        "\n - rootReactView.cachedLayoutMetrics.contentFrame:", rootReactView.cachedLayoutMetrics?.contentFrame.debugDescription ?? "N/A",
        "\n - rootReactView.globalFrame:", rootReactView.globalFrame?.debugDescription ?? "N/A",
        "\n - rootReactView.layer.frame:", rootReactView.layer.presentation()?.frame.debugDescription ?? "N/A",
        "\n - rootReactView.intrinsicContentSize:", rootReactView.intrinsicContentSize,
        "\n - contentDelegate.bounds.size:", rootReactView.contentDelegate.bounds.size,
        "\n - contentDelegate.globalFrame:", rootReactView.contentDelegate.globalFrame?.debugDescription ?? "N/A",
        "\n - contentDelegate.layer.frame:", rootReactView.contentDelegate.layer.presentation()?.frame.debugDescription ?? "N/A",
        "\n"
      );
    };
    
    #if DEBUG
    log();
    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
      log();
    };
    #endif
    
    switch (
      self.positionConfig.horizontalAlignment,
      self.positionConfig.verticalAlignment
    ) {
      case (.stretch, .stretch):
        fallthrough;
        
      case (.stretchTarget, .stretchTarget):
        rootReactView.setSize(self.view.bounds.size);
        
      case (.stretchTarget, _):
        fallthrough;
        
      case(.stretch, _):
        let newWidth = self.view.bounds.width;
        
        #if RCT_NEW_ARCH_ENABLED
        // TBA
        #else
        guard let shadowView = rootReactView.cachedShadowView,
              rootReactView.intrinsicContentSize.width != newWidth
        else {
          return;
        };
        
        rootReactView.intrinsicContentSizeOverride = .init(
          width: newWidth,
          height: 0
        );
        
        shadowView.minWidth = .init(
          value: Float(newWidth),
          unit: .point
        );
        
        shadowView.dirtyLayout();
        #endif

        case (_, .stretchTarget):
          fallthrough;

        case (_, .stretch):
          let newHeight = self.view.bounds.height;
          
          #if RCT_NEW_ARCH_ENABLED
          // TBA
          #else
          guard let shadowView = rootReactView.cachedShadowView,
                rootReactView.intrinsicContentSize.height != newHeight
          else {
            return;
          };
          
          rootReactView.intrinsicContentSizeOverride = .init(
            width: 0,
            height: newHeight
          );

          shadowView.minHeight = .init(
            value: Float(newHeight),
            unit: .point
          );
          
          shadowView.dirtyLayout();
          #endif

      default:
        break;
    };
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
