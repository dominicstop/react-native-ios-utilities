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

 static var shared: ClassType = .init();

 func somePromiseCommandThatWillAlwaysResolve(resolve: Resolve, reject: Reject){

 };
 
 func somePromiseCommandThatWillAlwaysReject(resolve: Resolve, reject: Reject){

 };
};
