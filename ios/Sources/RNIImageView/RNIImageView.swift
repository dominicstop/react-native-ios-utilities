//
//  RNIImageView.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 4/13/24.
//

import UIKit
import ExpoModulesCore


public class RNIImageView: ExpoView {

  public var imageView: UIImageView?;
  
  public var imageConfig: RNIImageItem?;
  public var imageConfigProp: Dictionary<String, Any> = [:] {
    willSet {
      guard let imageConfig = RNIImageItem(dict: newValue),
            let image = imageConfig.image
      else { return };
      
      self.imageConfig = imageConfig;
      self.imageView?.image = image;
    }
  };
  
  public var preferredSymbolConfiguration: UIImage.SymbolConfiguration?;
  public var preferredSymbolConfigurationProp: Dictionary<String, Any>? {
    willSet {
      defer {
        self.imageView?.preferredSymbolConfiguration = self.preferredSymbolConfiguration;
      };
      
      guard let newValue = newValue else {
        self.preferredSymbolConfiguration = nil;
        return;
      };
      
      self.preferredSymbolConfiguration =
        try? UIImage.SymbolConfiguration.create(fromDict: newValue);
    }
  };
  
  public required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext);
    self._setupView();
  };
  
  func _setupView(){
    let imageView = UIImageView();
    self.imageView = imageView;
    
    imageView.image = self.imageConfig?.image;
    imageView.preferredSymbolConfiguration = self.preferredSymbolConfiguration;
    
    imageView.translatesAutoresizingMaskIntoConstraints = false;
    self.addSubview(imageView);
    
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor
      ),
      imageView.trailingAnchor.constraint(
        equalTo: self.trailingAnchor
      ),
      imageView.topAnchor.constraint(
        equalTo: self.topAnchor
      ),
      imageView.bottomAnchor.constraint(
        equalTo: self.bottomAnchor
      ),
    ]);
  };
};
