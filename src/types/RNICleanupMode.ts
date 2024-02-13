

/**
 * @deprecated 
 * Do not use anymore.
 * Use `RNIViewCleanupTrigger` instead.
 */
export type RNICleanupMode = 
  | 'automatic'
  | 'viewController'
  | 'reactComponentWillUnmount'
  | 'disabled';

/**
 * @deprecated 
 * Do not use anymore.
 * Use `RNIViewCleanupMode` instead.
 */
export type RNIInternalCleanupModeProps = {
  /**
   * @deprecated 
   * Do not use anymore.
   * Use `internalViewCleanupMode` instead.
   */
  internalCleanupMode?: RNICleanupMode;
};