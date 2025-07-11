import { codegenNativeComponent } from 'react-native';
import type {
  BubblingEventHandler,
  Int32,
} from 'react-native/Libraries/Types/CodegenTypes';
import type { HostComponent, ViewProps } from 'react-native';

// stubs
export interface NativeProps extends ViewProps {
  // common/shared props
  rawDataForNative?: string;

  // common/shared events
  onDidSetViewID?: BubblingEventHandler<{}>;
  onViewWillRecycle?: BubblingEventHandler<{}>;
  onRawNativeEvent?: BubblingEventHandler<{}>;

  // value prop stubs
  shouldImmediatelyDetach?: boolean;
  reactChildrenCount: Int32;

  // event prop stubs
  onContentViewDidDetach?: BubblingEventHandler<{}>;
  onViewDidDetachFromParent?: BubblingEventHandler<{}>;
}

// stubs
export default codegenNativeComponent<NativeProps>('RNIDetachedView', {
  excludedPlatforms: ['android'],
  interfaceOnly: true,
}) as HostComponent<NativeProps>;
