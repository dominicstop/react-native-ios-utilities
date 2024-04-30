//
//  IosUtilitiesViewDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit


@objc
public class IosUtilitiesViewDelegate: UIView, RNIViewLifecycleEventsNotifiable {
  
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
