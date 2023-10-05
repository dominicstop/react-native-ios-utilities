import { StyleSheet, Text, View } from 'react-native';

// import {  } from 'react-native-ios-utilities';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>
        "Hello World"
      </Text>
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
});
