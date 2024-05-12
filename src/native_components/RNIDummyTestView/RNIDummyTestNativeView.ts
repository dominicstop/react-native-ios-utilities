import type { HostComponent, ViewProps } from 'react-native';
import { default as RNIDummyTestViewNativeComponent } from './RNIDummyTestViewNativeComponent';


export interface RNIDummyTestNativeViewProps extends ViewProps {
  someObject: object;
}

export const RNIDummyTestNativeView = 
  RNIDummyTestViewNativeComponent as unknown as HostComponent<RNIDummyTestNativeViewProps>;
