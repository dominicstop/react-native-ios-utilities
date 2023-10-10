import { StyleSheet, Text, View } from 'react-native';

import { RNIDetachedView } from 'react-native-ios-utilities';

export default function App() {
  return (
    <View style={styles.container}>
      <RNIDetachedView style={styles.detachedView}>
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
