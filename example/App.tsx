import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

import { RNIDetachedView, Helpers } from 'react-native-ios-utilities';

export default function App() {
  const [shouldMount, setShouldMount] = React.useState(true);
  const detachedViewRef = React.useRef<RNIDetachedView>(null);

  React.useEffect(() => {
    console.log("App - component did mount");

    (async () => {
      await Helpers.timeout(3000);
      console.log("App - setShouldMount: false");
      
      setShouldMount(false);
    })();
  }, []);

  return (
    <View style={styles.container}>
      {(shouldMount && (
        <RNIDetachedView  
          ref={detachedViewRef}
          style={styles.detachedView}
        >
          <View nativeID='test'>
            <Text>
              "Dummy View - Hello World"
            </Text>
          </View>
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
