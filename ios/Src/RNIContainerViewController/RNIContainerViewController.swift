//
//  RNIContextMenuViewController.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 2/1/22.
//

import UIKit;


// TODO: move to sep. library (e.g. `react-native-ios-utilities`)
class RNIContainerViewController: UIViewController {
  
  weak var parentVC: UIViewController?;
  weak var eventsDelegate: RNIContainerViewControllerEventsDelegate?;
  
  var isAttachedToParentVC = false;
  var isBeingPopped = false;
  
  // MARK: - Init
  // ------------
  
  init(view: UIView) {
    super.init(nibName: nil, bundle: nil);
    self.view = view;
  };
  
  // loaded from a storyboard
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder);
  };
  
  // MARK: - Lifecycle
  // -----------------
  
  override func viewWillDisappear(_ animated: Bool) {
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
  
  override func viewDidDisappear(_ animated: Bool) {
    self.eventsDelegate?.onViewControllerWillDisappear?(
      sender: self,
      parentVC: parentVC,
      isBeingPopped: self.isBeingPopped
    );
    
    // reset
    self.isBeingPopped = false;
  };

  // MARK: - Public Methods
  // ----------------------
  
  func attachToParentVC() throws {
    guard !self.isAttachedToParentVC else {
      throw RNIPopoverGenericError(
        code: .runtimeError,
        message: "view controller already has a parent view controller"
      );
    };
    
    // find the nearest parent view controller
    guard let parentVC = RNIUtilities
      .getParent(responder: self, type: UIViewController.self)
    else {
      throw RNIPopoverGenericError(
        code: .nilValue,
        message: "Could not find any view controllers to attach to"
      );
    };
    
    self.parentVC = parentVC;
    self.isAttachedToParentVC = true;
  
    parentVC.addChild(self);
    self.didMove(toParent: parentVC);
  };
  
  func detachFromParentVC(){
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
