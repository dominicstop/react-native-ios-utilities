//
//  RNIDummyTestViewDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//

import UIKit
import DGSwiftUtilities

@objc
public final class RNIDummyTestViewDelegate: UIView, RNIContentView {

  public static var propKeyPathMap: PropKeyPathMap {
    return [
      "someBool": \.someBool,
      "someString": \.someString,
      "someStringOptional": \.someStringOptional,
      "someNumber": \.someNumber,
      "someNumberOptional": \.someNumberOptional,
      "someObject": \.someObject,
      "someObjectOptional": \.someObjectOptional,
      "someArray": \.someArray,
      "someArrayOptional": \.someArrayOptional,
    ];
  };
  
  public enum Events: String, CaseIterable {
    case onSomeDirectEventWithEmptyPayload;
    case onSomeDirectEventWithObjectPayload;
    case onSomeBubblingEventWithEmptyPayload;
    case onSomeBubblingEventWithObjectPayload;
  }
  
  // MARK: Properties
  // ----------------
  
  var _didSendEvents = false;
  
  // MARK: - Properties - RNIContentViewDelegate
  // -------------------------------------------
  
  public weak var parentReactView: RNIContentViewParentDelegate?;
  
  // MARK: Properties - Props
  // ------------------------
  
  public var reactProps: NSDictionary = [:] {
    willSet {
      print("RNIDummyTestViewDelegate.reactProps - newValue:", newValue);
    }
  };
  
  @objc
  public var someBool: Bool = false {
    willSet {
      print("RNIDummyTestViewDelegate.someBool - newValue:", newValue);
    }
  };
  
  @objc
  public var someString: String = "" {
    willSet {
      print("RNIDummyTestViewDelegate.someString - newValue:", newValue);
    }
  };
  
  @objc
  public var someStringOptional: String? {
    willSet {
      print(
        "RNIDummyTestViewDelegate.someStringOptional - newValue:",
        newValue?.debugDescription ?? "N/A"
      );
    }
  };
  
  @objc
  public var someNumber: NSNumber = -1 {
    willSet {
      print("RNIDummyTestViewDelegate.someNumber - newValue:", newValue);
    }
  };
  
  @objc
  public var someNumberOptional: NSNumber? {
    willSet {
      print(
        "RNIDummyTestViewDelegate.someNumberOptional - newValue:",
        newValue?.debugDescription ?? "N/A"
      );
    }
  };
  
  @objc
  public var someObject: NSDictionary = [:] {
    willSet {
      print("RNIDummyTestViewDelegate.someObject - newValue:", newValue);
    }
  };
  
  @objc
  public var someObjectOptional: NSDictionary? {
    willSet {
      print(
        "RNIDummyTestViewDelegate.someObjectOptional - newValue:",
        newValue?.debugDescription ?? "N/A"
      );
    }
  };
  
  @objc
  public var someArray: NSArray = [] {
    willSet {
      print("RNIDummyTestViewDelegate.someArray - newValue:", newValue);
    }
  };
  
  @objc
  public var someArrayOptional: NSArray? {
    willSet {
      print(
        "RNIDummyTestViewDelegate.someArrayOptional - newValue:",
        newValue?.debugDescription ?? "N/A"
      );
    }
  };
  
  // MARK: Init
  // ----------
  
  public static func instanceMaker(
    sender: RNIContentViewParentDelegate,
    frame: CGRect
  ) -> RNIContentViewDelegate {
  
    return Self.init(frame: frame);
  };
  
  public override init(frame: CGRect) {
    super.init(frame: frame);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  }
  
  // MARK: Functions
  // ---------------
  
  public override func didMoveToWindow() {
    guard self.window != nil,
          let parentReactView = self.parentReactView
    else { return };
    
    self._dispatchEvents();
    
    print(
      "RNIDummyTestViewDelegate.didMoveToWindow",
      "\n - reactProps:", self.reactProps.description,
      "\n - reactNativeTag:", self.parentReactView?.reactNativeTag ?? -1,
      "\n - parentReactView.viewID:", self.parentReactView?.viewID ?? "N/A",
      "\n - parentReactView.contentDelegate:", self.parentReactView?.contentDelegate.description ?? "N/A",
      "\n - parentReactView.cachedLayoutMetrics", self.parentReactView?.cachedLayoutMetrics?.description ?? "N/A",
      "\n"
    );
    
    let viewID: RNINativeViewIdentifier = {
      let dict: Dictionary<String, Any> = [
        "viewID": self.parentReactView!.viewID!,
      ];
      
      return try! .init(fromDict: dict);
    }();
    
    let matchingViewForViewID = viewID.getAssociatedView();
    
    let reactTag: RNINativeViewIdentifier = {
      let dict: Dictionary<String, Any> = [
        "reactTag": self.parentReactView?.reactNativeTag?.intValue ?? -1,
      ];
      
      return try! .init(fromDict: dict);
    }();
    
    let matchingViewForReactTag = reactTag.getAssociatedView();
    
    print(
      "RNIDummyTestViewDelegate.didMoveToWindow",
      "\n - RNINativeViewIdentifier.viewID:", viewID,
      "\n - matchingViewForViewID:", matchingViewForViewID.debugDescription,
      "\n - RNINativeViewIdentifier.reactTag:", reactTag,
      "\n - matchingViewForReactTag:", matchingViewForReactTag.debugDescription,
      "\n"
    );
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 10){
      parentReactView.setSize(.init(width: 300, height: 300));
    };
  };
  
  func _setupContent(){
    self.backgroundColor = .systemPink;
  
    let label = UILabel();
    label.text = "Fabric View (sort of) in Swift";
    
    label.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(label);
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(
        equalTo: self.centerXAnchor
      ),
      label.centerYAnchor.constraint(
        equalTo: self.centerYAnchor
      ),
    ]);
  };
  
  func _dispatchEvents(){
    let eventPayload: [String: Any] = [
      "someBool": true,
      "someString": "abc",
      "someNumber": 123,
      "someObject": [
        "someBool": true,
        "someString": "abc",
      ],
      "someArray": [],
    ];
    
    self.dispatchEvent(
      for: .onSomeDirectEventWithEmptyPayload,
      withPayload: [:]
    );
    
    self.dispatchEvent(
      for: .onSomeDirectEventWithObjectPayload,
      withPayload: eventPayload
    );
    
    self.dispatchEvent(
      for: .onSomeBubblingEventWithEmptyPayload,
      withPayload: [:]
    );
    
    self.dispatchEvent(
      for: .onSomeBubblingEventWithObjectPayload,
      withPayload: eventPayload
    );
  };
};

extension RNIDummyTestViewDelegate: RNIContentViewDelegate {

  public typealias KeyPathRoot = RNIDummyTestViewDelegate;

  // MARK: Paper + Fabric
  // --------------------
  
  public func notifyOnInit(sender: RNIContentViewParentDelegate) {
    self._setupContent();
  };
    
  public func notifyOnMountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  ) {
    #if !RCT_NEW_ARCH_ENABLED
    superBlock();
    #endif
    
    self._dispatchEvents();
    self.reactGetLayoutMetrics {
      print(
        "RNIDummyTestViewDelegate.notifyOnMountChildComponentView",
        "\n - childComponentView.reactGetLayoutMetrics:", $0?.description ?? "N/A",
        "\n"
      );
    };
    
    print(
      "RNIDummyTestViewDelegate.notifyOnMountChildComponentView",
      "\n - childComponentView:", childComponentView.debugDescription,
      "\n - childComponentView.reactNativeTag:", childComponentView.reactNativeTag?.stringValue ?? "N/A",
      "\n - childComponentView.reactNativeID:", childComponentView.reactNativeID ?? "N/A",
      "\n - index:", index,
      "\n - sender.window:", sender.window?.debugDescription ?? "N/A",
      "\n - self.window:", self.window?.debugDescription ?? "N/A",
      "\n - self.reactSubviews.count::", sender.reactSubviews.count,
      "\n - sender.reactSubviews:", sender.reactSubviews,
      "\n"
    );
    
    // Note: Window might not be available yet
    self.addSubview(childComponentView);
  };
  
  public func notifyOnUnmountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  ) {
    #if !RCT_NEW_ARCH_ENABLED
    superBlock();
    #endif
    
    childComponentView.removeFromSuperview();
    
    print(
      "RNIDummyTestViewDelegate.notifyOnUnmountChildComponentView",
      "\n - childComponentView:", childComponentView.debugDescription,
      "\n - index:", index,
      "\n - self.window:", self.window?.debugDescription ?? "N/A",
      "\n"
    );
  }
  
  public func notifyDidSetProps(sender: RNIContentViewParentDelegate) {
    self._dispatchEvents();
    
    print(
      "RNIDummyTestViewDelegate.notifyDidSetProps",
      "\n - someBool:", self.someBool,
      "\n - someString:", self.someString,
      "\n - someStringOptional:", self.someStringOptional.debugDescription,
      "\n - someNumber:", self.someNumber,
      "\n - someNumberOptional:", self.someNumberOptional.debugDescription,
      "\n - someObject:", self.someObject,
      "\n - someObjectOptional:", self.someObjectOptional.debugDescription,
      "\n - someArray:", self.someArray,
      "\n - someArrayOptional:", self.someArrayOptional.debugDescription,
      "\n"
    );
    
    print(
      "RNIDummyTestViewDelegate.notifyDidSetProps",
      "\n - sender.rawProps:", sender.rawProps,
      "\n"
    );
  };
  
  public func notifyOnUpdateLayoutMetrics(
    sender: RNIContentViewParentDelegate,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  ) {
    #if RN_FABRIC_ENABLED
    print("Hello Fabric");
    #else
    print("Hello Paper");
    #endif
    
    print(
      "RNIDummyTestViewDelegate.notifyOnUpdateLayoutMetrics",
      "\n - oldLayoutMetric.frame:", oldLayoutMetrics.frame,
      "\n - oldLayoutMetric.frame:", newLayoutMetrics.frame,
      "\n - self.reactNativeTag:", self.reactNativeTag?.stringValue ?? "N/A",
      "\n - sender.reactNativeTag:", sender.reactNativeTag?.stringValue ?? "N/A",
      "\n - sender.window:", sender.window?.debugDescription ?? "N/A",
      "\n - self.window:", self.window?.debugDescription ?? "N/A",
      "\n"
    );
  };
  
  public func notifyOnViewCommandRequest(
    sender: RNIContentViewParentDelegate,
    forCommandName commandName: String,
    withCommandArguments commandArguments: NSDictionary,
    resolve resolveBlock: (NSDictionary) -> Void,
    reject rejectBlock: (String) -> Void
  ) {
  
    print(
      "RNIDummyTestViewDelegate.notifyOnViewCommandRequest",
      "\n - commandName:", commandName,
      "\n - commandArguments.count:", commandArguments.count,
      "\n - commandArguments.keys:", commandArguments.allKeys,
      "\n - commandArguments:", commandArguments,
      "\n"
    );
    
    resolveBlock([
      "someString": "abc",
      "someInt": 123,
      "someDouble": 3.14,
      "someBool": true
    ]);
  };
  
  // MARK: Fabric Only
  // -----------------

  #if RCT_NEW_ARCH_ENABLED
  public func notifyOnUpdateProps(
    sender: RNIContentViewParentDelegate,
    oldProps: NSDictionary,
    newProps: NSDictionary
  ) {
    print(
      "RNIDummyTestViewDelegate.notifyOnUpdateProps",
      "\n - oldProps:", oldProps.debugDescription,
      "\n - newProps:", newProps,
      "\n"
    );
  };
  
  public func notifyOnUpdateState(
    sender: RNIContentViewParentDelegate,
    oldState: NSDictionary?,
    newState: NSDictionary
  ) {
    print(
      "RNIDummyTestViewDelegate.notifyOnUpdateState",
      "\n - oldState:", oldState.debugDescription,
      "\n - newState:", newState,
      "\n"
    );
  };
  
  public func notifyOnFinalizeUpdates(
    sender: RNIContentViewParentDelegate,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  ) {
    
    print(
      "RNIDummyTestViewDelegate.notifyOnFinalizeUpdates",
      "\n - updateMaskRaw:", updateMaskRaw,
      "\n - updateMask.contains(.eventEmitter):", updateMask.contains(.eventEmitter),
      "\n - updateMask.contains(.layoutMetrics):", updateMask.contains(.layoutMetrics),
      "\n - updateMask.contains(.props):", updateMask.contains(.props),
      "\n - updateMask.contains(.state):", updateMask.contains(.state),
      "\n - updateMask.contains(.all):", updateMask.contains(.all),
      "\n - updateMask.isNone:", updateMask.isNone,
      "\n"
    );
  };
  
  public func notifyOnPrepareForReuse(sender: RNIContentViewParentDelegate) {
    print(
      "RNIDummyTestViewDelegate.notifyOnPrepareForReuse"
    );
  };
  
  public func shouldRecycleContentDelegate(sender: RNIContentViewParentDelegate) -> Bool {
    return false;
  }
  #else
  
  // MARK: - Paper Only
  // ------------------
  
  public override func didSetProps(_ changedProps: [String]!) {
    self._dispatchEvents();
  };
  #endif
};
