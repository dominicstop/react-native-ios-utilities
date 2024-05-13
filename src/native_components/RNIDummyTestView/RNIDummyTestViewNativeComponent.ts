import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { HostComponent, ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  someBool: string;
  someString: string;
  someStringOptional: string;
  someNumber: string;
  someNumberOptional: string;
  someObject: string;
  someObjectOptional: string;
  someArray: string;
  someArrayOptional: string;
}

export default codegenNativeComponent<NativeProps>('RNIDummyTestView', {
  excludedPlatforms: ['android'],
  interfaceOnly: true,
}) as HostComponent<NativeProps>;
