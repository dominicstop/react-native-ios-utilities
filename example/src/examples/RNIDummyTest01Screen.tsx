/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';

import { StyleSheet, Text, View, type ViewStyle } from 'react-native';
import { RNIDummyTestNativeView, RNIUtilitiesModule, RNIDummyTestViewModule, type SharedNativeValueMap } from 'react-native-ios-utilities';

const TEST_OBJECT = {
  someBool: true,
  someString: "abc",
  someInt: 123,
  someDouble: 3.14,

  someArrayEmpty: [],
  someArrayNull: null,
  someArrayUndefined: undefined,
  someArrayString: ['abc', 'def', 'ghi'],
  someArrayInt: [123, 456, 789],
  someArrayDouble: [3.14, 0.25, 0.5],
  someArrayMixed: ['abc', 123, 3.14, true, {}, [], null, undefined],

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
    key1WithStringValue: 'abc',
    key2WithIntValue: 123,
    key3WithDoubleValue: 3.14,
    key4WithBooleanValue: true,
    key5WithEmptyObjectValue: [],
    key6WithEmptyObjectValue: {},
    key7WithNullValue: null,
    key7WithUndefinedValue: undefined,
  },
};

const TEST_ARRAY = [
  true,
  false,
  123,
  3.14,
  -100,
  "hello world",
  "abc",
  null,
  undefined,
  TEST_OBJECT,
];

export function RNIDummyTest01Screen() {
  const viewID = React.useRef<string | undefined>();

  React.useEffect(() => {
    // @ts-ignore
    const nativeFabricUIManager = global?.nativeFabricUIManager;
    const isUsingNewArch = nativeFabricUIManager != null;

    console.log(`isUsingNewArch: ${isUsingNewArch}`);
    false && console.log('global: ', Object.keys(global));
    // console.log('global.RNIUtilitiesModule', global.RNIUtilitiesModule);
    // console.log('global.RNIUtilitiesModule.dummyFunction', global.RNIUtilitiesModule?.dummyFunction);
    // console.log('global.RNIUtilitiesModule.dummyFunction()', global.RNIUtilitiesModule?.dummyFunction?.(0));
    // console.log('global.RNIUtilitiesModule.viewCommandRequest', global.RNIUtilitiesModule?.viewCommandRequest);
    //console.log('global.NativeModules.RNIUtilitiesModule:', NativeModules.RNIUtilitiesModule);
    console.log('RNIUtilitiesModule:', Object.keys(RNIUtilitiesModule ?? []));
    
    false && setTimeout(async () => {
      console.log("viewID.current:", viewID.current);

      const result = await RNIUtilitiesModule?.viewCommandRequest?.(
        viewID.current!,
        'someViewCommand',
        TEST_OBJECT
      );
      console.log("viewCommandRequest:", result);
    }, 1000);

    false && setInterval(() => {
      const result = RNIDummyTestViewModule.getSharedValueSomeNumber();
      console.log(
        "JS - RNIDummyTestViewModule.getSharedValueSomeNumber:",
        "\n - result:", result
      );

      const oldValue = RNIDummyTestViewModule.getSharedValueSomeNumber();
      const newValue = (oldValue ?? 0) + 0.1;

      console.log(
        "JS - RNIDummyTestViewModule.setSharedValueSomeNumber:",
        "\n - oldValue:", oldValue,
        "\n - newValue:", newValue,
      );

      RNIDummyTestViewModule.setSharedValueSomeNumber(newValue);
    }, 500);

    false && setInterval(() => {
      const result = RNIDummyTestViewModule.getAllModuleSharedValues();
      console.log(
        "JS - RNIDummyTestViewModule.getAllModuleSharedValues:",
        "\n - result:", result
      );
    }, 1000);

    false && setInterval(() => {
      const sharedValuesOld = RNIDummyTestViewModule.getAllModuleSharedValues();
      const sharedValuesCount = Object.keys(sharedValuesOld).length;

      const newSharedValues: SharedNativeValueMap = {
        ...sharedValuesOld,
      };

      const newKey = `newValueFromJS-${sharedValuesCount}`;
      newSharedValues[newKey] = sharedValuesCount;

      RNIDummyTestViewModule.overwriteModuleSharedValues(newSharedValues);

      console.log(
        "JS - RNIDummyTestViewModule.overwrite:",
        "\n - sharedValuesOldCount:", sharedValuesCount,
        "\n - newSharedValues:", newSharedValues
      );
    }, 750);

    setTimeout(async () => {
      console.log(
        "Module.somePromiseCommandThatWillAlwaysResolve",
        "\n - invoking..."
      );

      const result = await RNIDummyTestViewModule.somePromiseCommandThatWillAlwaysResolve(
        /* someString: */ "abc",
        /* someNumber: */ 123,
        /* someBool  : */ true,
        /* someObject: */ TEST_OBJECT,
        /* someArray : */ TEST_ARRAY,
      );

      //alert("somePromiseCommandThatWillAlwaysResolve - resolve");

      console.log(
        "Module.somePromiseCommandThatWillAlwaysResolve",
        "\n - result:", result
      );
    }, 2000);
  }, []);

  const [counter, setCounter] = React.useState(0);
  const [isIntervalActive] = React.useState(true);

  const intervalRef = React.useRef<NodeJS.Timeout | undefined>();

  React.useEffect(() => {
    return;
    if (!isIntervalActive) return;

    const intervalID = setInterval(() => {
      setCounter((prevValue) => prevValue + 1);
      //RNIUtilitiesModule.dummyFunction(counter);
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
        someBool={false}
        someString={(counter % 2 === 0) ? "abc" : "def"}
        someStringOptional={(counter % 2 === 0) ? 'def' : undefined}
        someNumber={123}
        someNumberOptional={(counter % 2 === 0) ? 3.14 : undefined}
        someObject={TEST_OBJECT}
        someObjectOptional={(counter % 2 === 0) ? {} : undefined}
        someArray={TEST_ARRAY}
        someArrayOptional={(counter % 2 === 0) ? [4, 5, 6] : undefined}
        onSomeDirectEventWithEmptyPayload={({nativeEvent}) => {
          console.log(
            "RNIDummyTestNativeView.onSomeDirectEventWithEmptyPayload",
            "\n - nativeEvent:", nativeEvent
          );
        }}
        onSomeDirectEventWithObjectPayload={({nativeEvent}) => {
          console.log(
            "RNIDummyTestNativeView.onSomeDirectEventWithObjectPayload",
            "\n - nativeEvent:", nativeEvent
          );
        }}
        onSomeBubblingEventWithEmptyPayload={({nativeEvent}) => {
          console.log(
            "RNIDummyTestNativeView.onSomeBubblingEventWithEmptyPayload",
            "\n - nativeEvent:", nativeEvent
          );
        }}
        onSomeBubblingEventWithObjectPayload={({nativeEvent}) => {
          console.log(
            "RNIDummyTestNativeView.onSomeBubblingEventWithObjectPayload",
            "\n - nativeEvent:", nativeEvent
          );
        }}
        onDidSetViewID={({nativeEvent}) => {
          viewID.current = nativeEvent.viewID;
          console.log(
            "RNIDummyTestNativeView.onDidSetViewID",
            "\n - nativeEvent:", nativeEvent
          );
        }}
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
