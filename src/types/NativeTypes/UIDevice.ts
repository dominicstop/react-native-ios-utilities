// UIKit - UIDevice

import type { UIDeviceOrientation } from "./UIOrientation";

export type UIUserInterfaceIdiom =
  | 'unspecified'

  /** Min: iOS 3.2 - iPhone and iPod touch style UI */
  | 'phone'

  /** Min: iOS 3.2 - iPad style UI */
  | 'pad'

  /** Min: iOS 9.0 - Apple TV style UI */
  | 'tv'

  /** Min: iOS 9.0 - CarPlay style UI */
  | 'carPlay'

  /** Min: iOS 14.0 - Optimized for Mac UI */
  | 'mac'

  /** Min: iOS 17.0 - Vision UI */
  | 'vision';

export type UIDeviceBatteryState =
  | 'unknown'
  | 'unplugged'
  | 'charging'
  | 'full';

export type UIDevice = {

  /**
   * Synonym for model. 
   * Prior to iOS 16, user-assigned device name (e.g. "My iPhone").
   */
  name: string;

  /** e.g. @"iPhone", @"iPod touch" */
  model: string;

  /** localized version of model */
  localizedModel: string;

  /** e.g. @"iOS" */
  systemName: string;

  /** e.g. @"4.0" */
  systemVersion: string;

  /** 
   * Return current device orientation.  
   * this will return UIDeviceOrientationUnknown unless device orientation 
   * notifications are being generated. 
   */
  orientation: UIDeviceOrientation;

  /** 
   * Available: iOS 6.0
   * UUID that may be used to uniquely identify the device, 
   * same across apps from a single vendor.
   */
  identifierForVendor: string;

  isGeneratingDeviceOrientationNotifications: boolean;

  /** 
   * Available: iOS 3.0
   * Default is: `false`
   */
  isBatteryMonitoringEnabled: boolean;

  /** 
   * Available: iOS 3.0
   * // UIDeviceBatteryStateUnknown if monitoring disabled
   */
  batteryState: UIDeviceBatteryState;

  /** 
   * Available: iOS 3.0
   * // 0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
   */
  batteryLevel: number;

  /** 
   * Available: iOS 3.0
   * Default is: `false`
  */
  isProximityMonitoringEnabled: boolean 

  /** 
   * Available: iOS 3.0
   * // always returns NO if no proximity detector
   */
  proximityState: boolean;

  /** 
   * Available: iOS 4.0
   */
  isMultitaskingSupported: boolean;

  /** 
   * Available: iOS 3.2
   */
  userInterfaceIdiom: UIUserInterfaceIdiom;
};