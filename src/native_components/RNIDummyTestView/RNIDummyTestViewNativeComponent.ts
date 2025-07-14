import { codegenNativeComponent } from 'react-native';
import type {
  DirectEventHandler,
  BubblingEventHandler,
} from 'react-native/Libraries/Types/CodegenTypes';
import type { HostComponent, ViewProps } from 'react-native';

// stubs
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

  // event stubs
  onSomeDirectEventWithEmptyPayload: DirectEventHandler<{}>;
  onSomeDirectEventWithObjectPayload: DirectEventHandler<{}>;
  onSomeBubblingEventWithEmptyPayload: BubblingEventHandler<{}>;
  onSomeBubblingEventWithObjectPayload: DirectEventHandler<{}>;
  onDidSetViewID: BubblingEventHandler<{}>;
}

export default codegenNativeComponent<NativeProps>('RNIDummyTestView', {
  excludedPlatforms: ['android'],
  interfaceOnly: true,
}) as HostComponent<NativeProps>;
