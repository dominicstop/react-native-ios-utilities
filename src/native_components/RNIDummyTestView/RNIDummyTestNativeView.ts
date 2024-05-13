import type { HostComponent, ViewProps } from 'react-native';
import { default as RNIDummyTestViewNativeComponent } from './RNIDummyTestViewNativeComponent';


export interface RNIDummyTestNativeViewProps extends ViewProps {
  someBool: boolean;

  someString: string;
  someStringOptional?: string;

  someNumber: number;
  someNumberOptional?: number;

  someObject: object;
  someObjectOptional?: object;

  someArray: Array<unknown>;
  someArrayOptional?: Array<unknown>;
};

export const RNIDummyTestNativeView = 
  RNIDummyTestViewNativeComponent as unknown as HostComponent<RNIDummyTestNativeViewProps>;
