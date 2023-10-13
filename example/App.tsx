import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

import { RNIDetachedView } from 'react-native-ios-utilities';

export default function App() {
  const detachedViewRef = React.useRef<RNIDetachedView>(null);

  React.useEffect(() => {
    console.log("App - component did mount");
  }, []);

  return (
    <View style={styles.container}>
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
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'red',
    alignItems: 'center',
    justifyContent: 'center',
  },
  detachedView: {
    backgroundColor: 'blue',
  },
});
