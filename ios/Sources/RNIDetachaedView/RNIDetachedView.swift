//
//  RNIDetachaedView.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import ExpoModulesCore
import DGSwiftUtilities

public class RNIDetachedView: ExpoView {

  public enum DetachState {
    case initial;
    case detaching;
    case detached;
  };
  
  public static var detachedView: [WeakRef<RNIDetachedView>] = [];

  // MARK: Properties
  // ----------------
  
  lazy var debugLogger: Logger = .init(options: [.logToOS]);
  
  public weak var eventDelegate: RNIDetachedViewEventsNotifiable?;
  
  private(set) public var touchHandler: RCTTouchHandler?;
  private(set) public weak var cachedSuperview: UIView?;
  
  private(set) public var detachState: DetachState = .initial;
  
  private(set) public var didTriggerCleanup = false;
  
  // MARK: Properties - Props
  // ------------------------
  
  public var shouldCleanupOnComponentWillUnmount = false;
  
  // MARK: Properties - Prop - Events
  // --------------------------------
  
  let onViewDidDetach = EventDispatcher("onViewDidDetach");
  
  // MARK: Init
  // ----------

  public required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext);
  };
  
  // MARK: View-Lifecycle
  // --------------------
  
  public override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview);
    
    guard self.detachState != .detaching,
          let newSuperview = newSuperview,
          newSuperview !== self.cachedSuperview
    else { return };

    self.cachedSuperview = superview;
  };
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview();
  };
  
  public override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow);
  };
  
  public override func didMoveToWindow() {
    super.didMoveToWindow();
  };
  
  public override func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview);
  };
  
  public override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview);
  };
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    
    let logger = Logger(category: "RNIDetachedView", options: [.logToFile]);
    logger.info("layoutSubviews");
    
    if self.detachState == .initial,
       let window = self.window,
       let rootVC = window.rootViewController,
       let rootView = rootVC.view {
      
      self.detach();
      rootView.addSubview(self);
    };
    
    guard self.detachState == .detached else { return };
    self.eventDelegate?.notifyOnLayoutSubviews(sender: self);
  };
  
  // MARK: Functions
  // ---------------
  
  public func detach(completion: (() -> Void)? = nil){
    self.detachState = .detaching;
    
    self.removeFromSuperview();
    Self.detachedView.append(
      .init(with: self)
    );
    
    self.detachState = .detached;
    self.onViewDidDetach.callAsFunction([:]);
    completion?();
  };
  
  public func updateBounds(newSize: CGSize){
    let oldSize = self.bounds.size;
    
    guard let reactBridge = self.appContext?.reactBridge,
          newSize != oldSize
    else { return };
    
    reactBridge.uiManager.setSize(newSize, for: self);
  };
  
  // MARK: Module Functions
  // ----------------------
  
  public func notifyOnComponentWillUnmount(isManuallyTriggered: Bool){
    self.eventDelegate?.notifyOnJSComponentWillUnmount(
      sender: self,
      isManuallyTriggered: isManuallyTriggered
    );
    
    if self.shouldCleanupOnComponentWillUnmount {
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        self.cleanup();
      };
    };
  };
};

// MARK: - RNICleanable
// --------------------

extension RNIDetachedView: RNICleanable {
  
  public func cleanup(){
    guard !self.didTriggerCleanup,
          let bridge = self.appContext?.reactBridge
    else { return };
    
    self.didTriggerCleanup = true;
    
    if let touchHandler = self.touchHandler {
      touchHandler.detach(from: self);
    };
    
    RNIHelpers.recursivelyRemoveFromViewRegistry(
      forReactView: self,
      usingReactBridge: bridge
    );
    
    self.touchHandler = nil;
  };
};
