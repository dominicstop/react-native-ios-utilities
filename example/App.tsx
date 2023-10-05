import { StyleSheet, Text, View } from 'react-native';

import { RNIDummyView } from 'react-native-ios-utilities';

export default function App() {
  return (
    <View style={styles.container}>
      <RNIDummyView>
        <Text>
          "Dummy View - Hello World"
        </Text>
      </RNIDummyView>
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
