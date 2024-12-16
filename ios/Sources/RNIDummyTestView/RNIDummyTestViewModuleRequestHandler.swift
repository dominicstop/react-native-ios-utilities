//
//  RNIDummyTestViewModuleRequestHandler.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/25/24.
//

import Foundation
import DGSwiftUtilities


final class RNIDummyTestViewModuleRequestHandler: RNIModuleCommandRequestHandling {

  static let moduleName = "RNIDummyTestViewModule";

  static let commandMapPromise = [
   "somePromiseCommandThatWillAlwaysResolve":
      ClassType.somePromiseCommandThatWillAlwaysResolve,
      
   "somePromiseCommandThatWillAlwaysReject":
      ClassType.somePromiseCommandThatWillAlwaysReject,
  ];
  
  static var initialSharedValues: [String : Any] {
    return [
      "someNumber": 1,
    ];
  };
  
  static let shared: ClassType = .init();
  
  init(){
    let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
    
      let rawValue = self.getSharedValue(forKey: "someNumber");
      let someNumber = (rawValue as? NSNumber) ?? 0.0;
        
      print(
        "NATIVE - RNIDummyTestViewModuleRequestHandler.getSharedValue",
        "\n - key: someNumber",
        "\n - rawValue:", rawValue ?? "N/A",
        "\n - someNumber:", someNumber,
        "\n"
      );
        
      self.setSharedValue(
        forKey: "someNumber",
        withValue: someNumber.doubleValue + 1.0
      );
    }
    
    let _ = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { _ in
      let sharedValues = NSMutableDictionary(dictionary: self.sharedValues);
      let sharedValuesEntryCount = sharedValues.count;
      
      sharedValues.setValue(
        sharedValuesEntryCount,
        forKey: "newValueFromSwift-\(sharedValuesEntryCount)"
      );
      
      RNIUtilitiesManager.shared.overwriteModuleSharedValues(
        forKey: Self.moduleName,
        value: sharedValues
      );
        
      print(
        "NATIVE - RNIDummyTestViewModuleRequestHandler.overwriteModuleSharedValues",
        "\n - sharedValuesEntryCount old", sharedValuesEntryCount,
        "\n - sharedValuesEntryCount new", sharedValues.count,
        "\n - sharedValues:", sharedValues,
        "\n"
      );
    }
  };

  func somePromiseCommandThatWillAlwaysResolve(
    commandArgs: CommandArguments,
    resolve: Resolve
  ) throws {
  
    let someString: String =
      try commandArgs.getValue(forKey: "someString");
      
    let someNumber: Double =
      try commandArgs.getValue(forKey: "someNumber");
      
    let someBool: Bool =
      try commandArgs.getValue(forKey: "someBool");
      
    let someObject: Dictionary<String, Any> =
      try commandArgs.getValue(forKey: "someObject");
      
    let someArray: NSArray =
      try commandArgs.getValue(forKey: "someArray");
      
    let someStringOptional: String? =
      try? commandArgs.getValue(forKey: "someStringOptional");
    
    resolve([
      "message": "Command received",
      "someString": someString,
      "someNumber": someNumber,
      "someBool": someBool,
      "someObject": someObject,
      "someArray": someArray,
      "someStringOptional": someStringOptional as Any,
    ]);
  };
  
  func somePromiseCommandThatWillAlwaysReject(
    commandArgs: CommandArguments,
    resolve: Resolve
  ) throws {
  
    throw RNIUtilitiesError(
      sender: self,
      errorCode: .runtimeError,
      description: "Invoking this command will always fail xx",
      extraDebugValues: [
        "commandArgs": commandArgs,
      ]
    );
  };
};
