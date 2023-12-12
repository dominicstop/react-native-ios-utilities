import React from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';

import { RNIDetachedView, Helpers } from 'react-native-ios-utilities';

export default function App() {
  const [shouldMount, setShouldMount] = React.useState(true);
  const detachedViewRef = React.useRef<RNIDetachedView>(null);

  React.useEffect(() => {
    console.log("App - component did mount");
    console.log("shouldMount:", shouldMount);

    (async () => {
      await Helpers.timeout(5000);
      setShouldMount(false);
      console.log("shouldMount:", shouldMount);
    })();
  }, []);

  return (
    <View style={styles.container}>
      {(shouldMount && (
        <RNIDetachedView  
          ref={detachedViewRef}
          style={styles.detachedView}
        >
          <Pressable 
            nativeID='test'
            onPress={() => {
              console.log("I am being pressed...");
            }}
          >
            <Text>
              "Dummy View - Hello World"
            </Text>
          </Pressable>
        </RNIDetachedView>
      ))}
      {(!shouldMount) && (
        <View>
          <Text>
            {`shouldMount: ${shouldMount}`}
          </Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  detachedView: {
    flex: 1,
    backgroundColor: 'blue',
  },
});
