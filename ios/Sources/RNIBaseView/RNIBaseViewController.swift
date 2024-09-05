//
//  RNIBaseViewController.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/5/24.
//

import Foundation


/// Holds/wraps a `RNIBaseView` instance (i.e. `RNIContentViewParentDelegate`)
///
public class RNIBaseViewController: UIViewController {
  
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
  };

  public override func viewDidLayoutSubviews() {
    guard let rootReactView = self.rootReactView else {
      return;
    };
    
    rootReactView.setSize(self.view.bounds.size);
  };
};
