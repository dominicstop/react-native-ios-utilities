//
//  RNIBaseViewEventBroadcaster.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/9/24.
//

import Foundation
import DGSwiftUtilities


@objc
public class RNIBaseViewEventBroadcaster: NSObject {

  public weak var parentReactView: RNIContentViewParentDelegate?;
  
  public var viewLifecycleDelegates: MulticastDelegate<ViewLifecycleEventsNotifiable> = .init();
  
  public var reactViewLifecycleDelegates: MulticastDelegate<RNIViewLifecycle> = .init();

  public var reactViewPropUpdatesDelegates: MulticastDelegate<RNIViewPropUpdatesNotifiable> = .init();
  
  public var contentViewInternalEvents: MulticastDelegate<RNIViewInternalEventsNotifiable> = .init();
  
  // MARK: Visible to Obj-C
  // ----------------------
  
  @objc
  public init(parentReactView: RNIContentViewParentDelegate) {
    self.parentReactView = parentReactView;
  };
  
  @objc
  public func registerDelegatesFromParentReactView(){
    guard let contentDelegate = self.parentReactView?.contentDelegate else {
      return;
    };
    
    if let viewLifecycleDelegate = contentDelegate as? RNIViewLifecycle {
      self.reactViewLifecycleDelegates.add(viewLifecycleDelegate);
    };
    
    if let propUpdateDelegate = contentDelegate as? RNIViewPropUpdatesNotifiable {
      self.reactViewPropUpdatesDelegates.add(propUpdateDelegate);
    };
  };
};

// MARK: - RNIViewLifecycleCommon
// ------------------------------

extension RNIBaseViewEventBroadcaster: RNIViewLifecycleCommon {

  @objc
  public func notifyOnInit(
    sender: RNIContentViewParentDelegate
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnInit(sender: sender);
    };
  };
  
  @objc
  public func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnUpdateLayoutMetrics(
        sender: sender,
        oldLayoutMetrics: oldLayoutMetrics,
        newLayoutMetrics: newLayoutMetrics
      );
    };
  };
  
  @objc
  public func notifyOnRequestForCleanup(
    sender: RNIContentViewParentDelegate
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnRequestForCleanup(sender: sender);
    };
  };
  
  #if DEBUG
  @objc
  public func notifyOnReactAppWillReload(
    sender: RNIContentViewParentDelegate,
    notification: NSNotification
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnReactAppWillReload(
        sender: sender,
        notification: notification
      );
    };
  };
  #endif
};

// MARK: - RNIViewLifecycleFabric
// ------------------------------

#if RCT_NEW_ARCH_ENABLED
extension RNIBaseViewEventBroadcaster: RNIViewLifecycleFabric {

  @objc
  public func notifyOnUpdateState(
    sender: RNIContentViewParentDelegate,
    oldState: NSDictionary?,
    newState: NSDictionary
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnUpdateState(
        sender: sender,
        oldState: oldState,
        newState: newState
      );
    };
  };
  
  @objc
  public func notifyOnFinalizeUpdates(
    sender: RNIContentViewParentDelegate,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnFinalizeUpdates(
        sender: sender,
        updateMaskRaw: updateMaskRaw,
        updateMask: updateMask
      );
    };
  };
  
  @objc
  public func notifyOnPrepareForReuse(
    sender: RNIContentViewParentDelegate
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnPrepareForReuse(sender: sender);
    };
  };
  
  @objc
  public func notifyOnReloadCommandInvoked(
    sender: RNIContentViewParentDelegate,
    notification: Notification
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnReloadCommandInvoked(
        sender: sender,
        notification: notification
      );
    };
  };
};
#else

// MARK: - RNIViewLifecyclePaper
// -----------------------------

extension RNIBaseViewEventBroadcaster: RNIViewLifecyclePaper {

  @objc
  public func notifyOnViewWillInvalidate(
    sender: RNIContentViewParentDelegate
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnViewWillInvalidate(sender: sender);
    };
  };
  
  // MARK: Debug Only
  // ----------------

  /// Note: Only gets invoked in paper for some reason
  @objc
  public func notifyOnBridgeWillReload(
    sender: RNIContentViewParentDelegate,
    notification: Notification
  ) {
    self.reactViewLifecycleDelegates.invoke {
      $0.notifyOnBridgeWillReload(
        sender: sender,
        notification: notification
      );
    };
  };
};
#endif

// MARK: - RNIViewPropUpdatesNotifiable
// ------------------------------------

extension RNIBaseViewEventBroadcaster: RNIViewPropUpdatesNotifiable {

  @objc
  public func notifyDidSetProps(
    sender: RNIContentViewParentDelegate
  ) {
    self.reactViewPropUpdatesDelegates.invoke {
      $0.notifyDidSetProps(sender: sender);
    };
  };
  
  // MARK: Fabric Only
  // -----------------
  
  #if RCT_NEW_ARCH_ENABLED
  @objc
  public func notifyOnUpdateProps(
    sender: RNIContentViewParentDelegate,
    oldProps: NSDictionary,
    newProps: NSDictionary
  ) {
    self.reactViewPropUpdatesDelegates.invoke {
      $0.notifyOnUpdateProps(
        sender: sender,
        oldProps: oldProps,
        newProps: newProps
      );
    };
  };
  #else
  
  // MARK: Paper Only
  // ----------------
  
  @objc
  public func notifyDidSetProps(
    sender: RNIContentViewParentDelegate,
    changedProps: Array<String>
  ) {
    self.reactViewPropUpdatesDelegates.invoke {
      $0.notifyDidSetProps(
        sender: sender,
        changedProps: changedProps
      );
    };
  };
  #endif
};

extension RNIBaseViewEventBroadcaster: ViewLifecycleEventsNotifiable {
  
  @objc
  public func notifyOnViewWillMoveToWindow(
    sender: UIView,
    newWindow: UIWindow?
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewWillMoveToWindow(
        sender: sender,
        newWindow: newWindow
      );
    };
  };
  
  @objc
  public func notifyOnViewDidMoveToWindow(
    sender: UIView
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewDidMoveToWindow(sender: sender);
    };
  };
  
  @objc
  public func notifyOnViewWillMoveToSuperview(
    sender: UIView,
    newSuperview: UIView?
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewWillMoveToSuperview(
        sender: sender,
        newSuperview: newSuperview
      );
    };
  };
  
  @objc
  public func notifyOnViewDidMoveToSuperview(
    sender: UIView
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewDidMoveToSuperview(sender: sender);
    };
  };
  
  @objc
  public func notifyOnViewLayoutSubviews(
    sender: UIView
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewLayoutSubviews(sender: sender);
    };
  };
  
  @objc
  public func notifyOnViewRemovedFromSuperview(
    sender: UIView
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewRemovedFromSuperview(sender: sender);
    };
  };
  
  @objc
  public func notifyOnViewDidAddSubview(
    sender: UIView,
    subview: UIView
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewDidAddSubview(sender: sender, subview: subview);
    };
  };
  
  @objc
  public func notifyOnViewWillRemoveSubview(
    sender: UIView,
    subview: UIView
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewWillRemoveSubview(sender: sender, subview: subview);
    };
  };
};
