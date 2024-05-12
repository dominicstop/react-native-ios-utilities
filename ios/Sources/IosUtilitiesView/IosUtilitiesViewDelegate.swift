//
//  IosUtilitiesViewDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit

@objc
public class IosUtilitiesViewDelegate: UIView {
  public var reactProps: NSDictionary = [:];
  
  public override init(frame: CGRect) {
    super.init(frame: frame);
    self._setupContent();
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
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
};

extension IosUtilitiesViewDelegate: RNIViewLifecycleEventsNotifiable {
  
  public func notifyOnMountChildComponentView(
    sender: RNIViewLifecycleEventsNotifying,
    childComponentView: UIView,
    index: NSInteger
  ) {
    print(
      "IosUtilitiesViewDelegate.notifyOnMountChildComponentView",
      "\n - childComponentView:", childComponentView.debugDescription,
      "\n - index:", index,
      "\n - sender.window:", sender.window?.debugDescription ?? "N/A",
      "\n - self.window:", self.window?.debugDescription ?? "N/A",
      "\n"
    );
    
    // Note: Window might not be available yet
    self.addSubview(childComponentView);
  };
  
  public func notifyOnUnmountChildComponentView(
    sender: RNIViewLifecycleEventsNotifying,
    childComponentView: UIView,
    index: NSInteger
  ) {
    childComponentView.removeFromSuperview();
    
    print(
      "IosUtilitiesViewDelegate.notifyOnUnmountChildComponentView",
      "\n - childComponentView:", childComponentView.debugDescription,
      "\n - index:", index,
      "\n - self.window:", self.window?.debugDescription ?? "N/A",
      "\n"
    );
  }
  
  public func notifyOnUpdateLayoutMetrics(
    sender: RNIViewLifecycleEventsNotifying,
    oldLayoutMetrics: RNILayoutMetrics,
    newLayoutMetrics: RNILayoutMetrics
  ) {
    #if RN_FABRIC_ENABLED
    print("Hello Fabric");
    #else
    print("Hello Paper");
    #endif
    
    print(
      "IosUtilitiesViewDelegate.notifyOnUpdateLayoutMetrics",
      "\n - oldLayoutMetric.frame:", oldLayoutMetrics.frame,
      "\n - oldLayoutMetric.frame:", newLayoutMetrics.frame,
      "\n - self.tag:", self.tag,
      "\n - sender.tag:", sender.tag,
      "\n - sender.window:", sender.window?.debugDescription ?? "N/A",
      "\n - self.window:", self.window?.debugDescription ?? "N/A",
      "\n"
    );
  };
  
  public func notifyOnUpdateState(
    sender: RNIViewLifecycleEventsNotifying,
    oldState: NSDictionary?,
    newState: NSDictionary
  ) {
    print(
      "IosUtilitiesViewDelegate.notifyOnUpdateState",
      "\n - oldState:", oldState.debugDescription,
      "\n - newState:", newState,
      "\n"
    );
  };
  
  public func notifyOnFinalizeUpdates(
    sender: RNIViewLifecycleEventsNotifying,
    updateMaskRaw: Int,
    updateMask: RNIComponentViewUpdateMask
  ) {
    
    print(
      "IosUtilitiesViewDelegate.notifyOnFinalizeUpdates",
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
  
  public func notifyOnPrepareForReuse(sender: RNIViewLifecycleEventsNotifying) {
    print(
      "IosUtilitiesViewDelegate.notifyOnPrepareForReuse"
    );
  };
};
