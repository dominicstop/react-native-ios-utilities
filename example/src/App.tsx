/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';

import { StyleSheet, Text, View, type ViewStyle } from 'react-native';
import { IosUtilitiesView } from 'react-native-ios-utilities';

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
      <IosUtilitiesView 
        style={[styles.box, boxStyle]}
        color={"#32a852"}
      >
        <Text>{`Counter: ${counter}`}</Text>
      </IosUtilitiesView>
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
