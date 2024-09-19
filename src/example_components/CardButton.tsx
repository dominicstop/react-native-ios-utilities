import * as React from 'react';
import { type StyleProp, StyleSheet, Text, TouchableOpacity, type ViewStyle, type GestureResponderEvent } from 'react-native';

import { Colors } from '../misc/Colors';


/**
 * ```
 * ┌─────────────────────────────┐
 * │ Title                       │
 * │ Subtitle                    │
 * └─────────────────────────────┘
 * ```
 */ 
export function CardButton(props: {
  style?: StyleProp<ViewStyle>; 
  title: string;
  subtitle: string;
  onPress?: (event: GestureResponderEvent) => void;
  buttonColor?: string;
}){

  const buttonColor = props.buttonColor ?? Colors.PURPLE.A200;

  return(
    <TouchableOpacity 
      style={[
        props.style,
        styles.cardButtonContainer, 
        { backgroundColor: buttonColor },
      ]}
      onPress={props.onPress}
    >
      <React.Fragment>
        <Text style={styles.cardButtonTitleText}>
          {props.title}
        </Text>
        <Text style={styles.cardButtonSubtitleText}>
          {props.subtitle}
        </Text>
      </React.Fragment>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  cardButtonContainer: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 10,
    marginTop: 12,
  },
  cardButtonTitleText: {
    color: 'white',
    fontSize: 14,
    fontWeight: '700'
  },
  cardButtonSubtitleText: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.8)',
    fontWeight: '400'
  },
});