/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';

import { StyleSheet, Text, View, type ViewStyle } from 'react-native';
import { RNIDummyTestNativeView } from 'react-native-ios-utilities';

const TEST_OBJECT = {
  someBool: true,
  someString: "abc",
  someInt: 123,
  someDouble: 3.14,

  someArrayEmpty: [],
  someArrayString: ['abc', 'def', 'ghi'],
  someArrayInt: [123, 456, 789],
  someArrayDouble: [3.14, 0.25, 0.5],
  someArrayMixed: ['abc', 123, 3.14, true, {}, []],

  someObjectEmpty: {},
  someObjectString: {
    key1: 'abc',
    key2: 'def',
    key3: 'ghi',
  },
  someObjectInt: {
    key1: 123,
    key2: 456,
    key3: 789,
  },
  someObjectDouble: {
    key1: 3.14,
    key2: 0.25,
    key3: 0.5,
  },
  someObjectMixed: {
    key1: 'abc',
    key2: 123,
    key3: 3.14,
    key4: true,
    key5: [],
    key6: {},
  },
};


export default function App() {
  React.useEffect(() => {
    // @ts-ignore
    const nativeFabricUIManager = global?.nativeFabricUIManager;
    const isUsingNewArch = nativeFabricUIManager != null;

    console.log(`isUsingNewArch: ${isUsingNewArch}`);
  }, []);

  const [counter, setCounter] = React.useState(0);
  const [isIntervalActive] = React.useState(true);

  const intervalRef = React.useRef<NodeJS.Timeout | undefined>();

  React.useEffect(() => {
    if (!isIntervalActive) return;

    const intervalID = setInterval(() => {
      setCounter((prevValue) => prevValue + 1);
    }, 2000);

    intervalRef.current = intervalID;
    return () => {
      clearTimeout(intervalID);
    };
  }, []);

  const boxStyle: ViewStyle = {
    ...((counter % 2 === 0) && {
      height: 100,
    }),
  }

  return (
    <View style={styles.container}>
      <Text>{`Counter: ${counter}`}</Text>
      <RNIDummyTestNativeView 
        nativeID={'nativeID for RNIDummyTestNativeView'}
        style={[styles.box, boxStyle]}
        someBool={true}
        someString={"abc"}
        someStringOptional={'def'}
        someNumber={123}
        someNumberOptional={345}
        someObject={TEST_OBJECT}
        someObjectOptional={{}}
        someArray={[1,2,3]}
        someArrayOptional={[4,5,6]}
      >
        {(counter % 4 === 0) && (
          <Text
            nativeID={'nativeID for RNIDummyTestNativeView child'}
          >
            {`Counter: ${counter}`}
          </Text>
        )}
      </RNIDummyTestNativeView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
