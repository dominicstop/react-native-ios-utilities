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
  
  public var viewLifecycleDelegates: MulticastDelegate<RNIViewLifecycle> = .init();
  
  public var reactViewPropUpdatesDelegates: MulticastDelegate<RNIViewPropUpdatesNotifiable> = .init();
  
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
    
    self.viewLifecycleDelegates.add(contentDelegate);
    self.reactViewPropUpdatesDelegates.add(contentDelegate);
  };
};

// MARK: - RNIViewLifecycleCommon
// ------------------------------

extension RNIBaseViewEventBroadcaster: RNIViewLifecycleCommon {

  @objc
  public func notifyOnInit(
    sender: RNIContentViewParentDelegate
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnInit?(sender: sender);
    };
  };
  
  @objc
  public func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  ) {
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnUpdateLayoutMetrics?(
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
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnRequestForCleanup?(sender: sender);
    };
  };
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
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnUpdateState?(
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
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnFinalizeUpdates?(
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
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnPrepareForReuse?(sender: sender);
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
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnViewWillInvalidate?(sender: sender);
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
    self.viewLifecycleDelegates.invoke {
      $0.notifyOnBridgeWillReload?(
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
      $0.notifyDidSetProps?(sender: sender);
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
      $0.notifyOnUpdateProps?(
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
      $0.notifyDidSetProps?(
        sender: sender,
        changedProps: changedProps
      );
    };
  };
  #endif
};
