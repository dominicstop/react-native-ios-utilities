import React from 'react';
import { View } from 'react-native';

import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

import { SHARED_ENV } from './src/constants/SharedEnv';
import { setSharedEnvForRNICleanableViewRegistry, setSharedEnvForRNIUtilitiesModule } from 'react-native-ios-utilities';

import { HomeScreen } from './src/screens/HomeScreen';


setSharedEnvForRNIUtilitiesModule({
  debugShouldLogViewRegistryEntryRemoval: true,
  overrideEnableLogStackTrace: true,
  overrideShouldLogFileMetadata: true,
  overrideShouldLogFilePath: true
});

setSharedEnvForRNICleanableViewRegistry({
  debugShouldLogCleanup: true,
  debugShouldLogRegister: true,
});


const shouldEnableTabs = 
  SHARED_ENV.enableReactNavigation && SHARED_ENV.enableTabNavigation;

function Tab1StackScreen() {
  if(shouldEnableTabs){
    const Tab1Stack = createNativeStackNavigator();

    return (
    <Tab1Stack.Navigator initialRouteName="Home">
      <Tab1Stack.Screen 
        name="Home" 
        component={HomeScreen}
      />
    </Tab1Stack.Navigator>
  );

  } else {
    return null;
  };
};

export default function App() {
  if(SHARED_ENV.shouldRenderNothing){
    return (
      <View/>
    );
  };
  
  if(shouldEnableTabs){
    const TabNavigator = createBottomTabNavigator();

    return(
      <NavigationContainer>
        <TabNavigator.Navigator>
          <TabNavigator.Screen 
            name="Tab1" 
            component={Tab1StackScreen}
          />
          <TabNavigator.Screen 
            name="Tab2" 
            component={HomeScreen}
          />
        </TabNavigator.Navigator>
      </NavigationContainer>
    );
  } else if(SHARED_ENV.enableReactNavigation){
    const Stack = createNativeStackNavigator();

    return(
      <NavigationContainer>
        <Stack.Navigator initialRouteName="Home">
          <Stack.Screen 
            name="Home" 
            component={HomeScreen}
          />
        </Stack.Navigator>
      </NavigationContainer>
    );
  };

  return (
    <HomeScreen/>
  );
};

