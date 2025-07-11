import { codegenNativeComponent } from 'react-native';
import type { HostComponent, ViewProps } from 'react-native';
import type { BubblingEventHandler } from 'react-native/Libraries/Types/CodegenTypes';

// stubs
export interface NativeProps extends ViewProps {
  // common/shared props
  rawDataForNative?: string;

  // common/shared events
  onDidSetViewID?: BubblingEventHandler<{}>;
  onViewWillRecycle?: BubblingEventHandler<{}>;
  onRawNativeEvent?: BubblingEventHandler<{}>;
}

// stubs
export default codegenNativeComponent<NativeProps>('RNIWrapperView', {
  excludedPlatforms: ['android'],
  interfaceOnly: true,
}) as HostComponent<NativeProps>;
