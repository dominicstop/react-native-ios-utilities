import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { HostComponent, ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  color?: string;
}

export default codegenNativeComponent<NativeProps>('IosUtilitiesView', {
  excludedPlatforms: ['android'],
}) as HostComponent<NativeProps>;
