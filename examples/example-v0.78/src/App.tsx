import * as React from "react";
import { StyleSheet, View } from "react-native";

import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";

import * as LibraryPackageConfig from '../../../package.json';
import * as ExamplePackageConfig from '../package.json';

import { HomeScreen, SHARED_ENV, ROUTE_ITEMS, ROUTE_KEYS, AppMetadataCardContextProvider, IS_USING_NEW_ARCH } from 'react-native-ios-utilities-example-core';

// import * as Core from 'react-native-ios-utilities-example-core';
// console.log('react-native-ios-utilities-example-core', Object.keys(Core));

const shouldEnableTabs =
  SHARED_ENV.enableReactNavigation && SHARED_ENV.enableTabNavigation;

function Tab1StackScreen() {
  if (shouldEnableTabs) {
    const Tab1Stack = createNativeStackNavigator();

    return (
      <Tab1Stack.Navigator initialRouteName='Home'>
        <Tab1Stack.Screen name='Home' component={HomeScreen} />
      </Tab1Stack.Navigator>
    );
  } else {
    return null;
  }
}

function AppContent() {
  if(!SHARED_ENV.enableReactNavigation){
    return (
      <HomeScreen/>
    );
  };

  if (shouldEnableTabs) {
    const TabNavigator = createBottomTabNavigator();

    return (
      <NavigationContainer>
        <TabNavigator.Navigator>
          <TabNavigator.Screen name='Tab1' component={Tab1StackScreen} />
          <TabNavigator.Screen name='Tab2' component={HomeScreen} />
        </TabNavigator.Navigator>
      </NavigationContainer>
    );
  } else if (SHARED_ENV.enableReactNavigation) {
    const Stack = createNativeStackNavigator();

    return (
      <NavigationContainer>
        <Stack.Navigator
          initialRouteName={ROUTE_KEYS.home}
          screenOptions={{
            contentStyle: {
              backgroundColor: (SHARED_ENV.shouldSetAppBackground
                ? "black"
                : undefined
              ),
            },
            headerShadowVisible: false,
            headerStyle: {
              backgroundColor: (SHARED_ENV.shouldSetAppBackground
                ? "black"
                : undefined
              ),
            },
          }}
        >
          {ROUTE_ITEMS.map((item) => (
            <Stack.Screen
              key={item.routeKey}
              name={item.routeKey}
              component={item.component}
            />
          ))}
        </Stack.Navigator>
      </NavigationContainer>
    );
  }

  return <HomeScreen />;
}

export default function App() {
  return (
    <AppMetadataCardContextProvider
      value={{
        metadataOverrideData: {
          libraryName: LibraryPackageConfig.name,
          exampleName: ExamplePackageConfig.name,
          libraryVersion: LibraryPackageConfig.version,
          IS_USING_NEW_ARCH,
          __DEV__,
          exampleDependencies: ExamplePackageConfig.dependencies,
        },
      }}
    >
      <AppContent/>
    </AppMetadataCardContextProvider>
  );
};

const styles = StyleSheet.create({
  navigationBarBannerImage: {
    height: 45,
    width: 115,
    resizeMode: "contain",
  }
});
