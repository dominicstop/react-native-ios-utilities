import type { HostComponent, ViewProps } from 'react-native';
import type {
  DirectEventHandler,
  BubblingEventHandler,
  Int32,
  Float,
  Double
} from 'react-native/Libraries/Types/CodegenTypes';

import { default as RNIDummyTestViewNativeComponent } from './RNIDummyTestViewNativeComponent';
import type { SharedViewEvents } from '../../types/SharedViewEvents';


type SomeEventObjectWithEmptyPayload = Readonly<{}>;

type SomeEventObjectWithObjectPayload = Readonly<{
  someBool: boolean;
  someString: string;
  someStringOptional?: string;
  someInt: Int32;
  someIntOptional?: Int32;
  someFloat: Float;
  someFloatOptional?: Float;
  someDouble: Double;
  someDoubleOptional?: Double;
}>;

export interface RNIDummyTestNativeViewBaseProps extends ViewProps {
  someBool: boolean;

  someString: string;
  someStringOptional?: string;

  someNumber: number;
  someNumberOptional?: number;

  someObject: object;
  someObjectOptional?: object;

  someArray: Array<unknown>;
  someArrayOptional?: Array<unknown>;

  onSomeDirectEventWithEmptyPayload: DirectEventHandler<SomeEventObjectWithEmptyPayload>;
  onSomeDirectEventWithObjectPayload: DirectEventHandler<SomeEventObjectWithObjectPayload>;
  onSomeBubblingEventWithEmptyPayload: BubblingEventHandler<SomeEventObjectWithEmptyPayload>;
  onSomeBubblingEventWithObjectPayload: BubblingEventHandler<SomeEventObjectWithObjectPayload>;
};

export type RNIDummyTestNativeViewProps = 
    SharedViewEvents
  & RNIDummyTestNativeViewBaseProps;

export const RNIDummyTestNativeView = 
  RNIDummyTestViewNativeComponent as unknown as HostComponent<RNIDummyTestNativeViewProps>;
