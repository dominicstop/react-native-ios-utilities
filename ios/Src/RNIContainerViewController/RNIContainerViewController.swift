//
//  RNIContextMenuViewController.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 2/1/22.
//

import UIKit;


public class RNIContainerViewController: UIViewController {
  
  public weak var parentVC: UIViewController?;
  public weak var eventsDelegate: RNIContainerViewControllerEventsDelegate?;
  
  public var isAttachedToParentVC = false;
  public var isBeingPopped = false;
  
  // MARK: - Init
  // ------------
  
  public init(view: UIView) {
    super.init(nibName: nil, bundle: nil);
    self.view = view;
  };
  
  // loaded from a storyboard
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
  };
  
  // MARK: - Lifecycle
  // -----------------
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated);
    
    self.isBeingPopped = {
      guard let navVC = self.navigationController,
            let parentVC = self.parentVC,
            
            // if parent VC still exist in the stack, then it hasn't been popped yet
            navVC.viewControllers.contains(parentVC)
      else { return false };
      
      return true;
    }();
    
    self.eventsDelegate?.onViewControllerWillDisappear?(
      sender: self,
      parentVC: parentVC,
      isBeingPopped: self.isBeingPopped
    );
  };
  
  public override func viewDidDisappear(_ animated: Bool) {
    self.eventsDelegate?.onViewControllerDidDisappear?(
      sender: self,
      parentVC: parentVC,
      isBeingPopped: self.isBeingPopped
    );
    
    // reset
    self.isBeingPopped = false;
  };

  // MARK: - Public Methods
  // ----------------------
  
  public func attachToParentVC() throws {
    guard !self.isAttachedToParentVC else {
      throw RNIGenericError(
        code: .runtimeError,
        message: "view controller already has a parent view controller"
      );
    };
    
    // find the nearest parent view controller
    guard let parentVC = RNIUtilities
      .getParent(responder: self, type: UIViewController.self)
    else {
      throw RNIGenericError(
        code: .nilValue,
        message: "Could not find any view controllers to attach to"
      );
    };
    
    self.parentVC = parentVC;
    self.isAttachedToParentVC = true;
  
    parentVC.addChild(self);
    self.didMove(toParent: parentVC);
  };
  
  public func detachFromParentVC(){
    guard self.parentVC != nil,
          !self.isAttachedToParentVC
    else { return };
    
    // reset
    self.parentVC = nil;
    self.isAttachedToParentVC = false;
  
    self.willMove(toParent: nil);
    self.removeFromParent();
  };
};
