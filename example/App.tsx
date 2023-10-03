import { StyleSheet, Text, View } from 'react-native';

import * as ReactNativeIosUtilities from 'react-native-ios-utilities';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ReactNativeIosUtilities.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
