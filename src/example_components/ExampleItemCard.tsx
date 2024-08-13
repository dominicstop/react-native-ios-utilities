import * as React from 'react';
import { StyleSheet, View, Text, ViewStyle } from 'react-native';

import * as Colors from '../constants/Colors';


export type ExampleItemCardProps = {
  index?: number;
  title?: string;
  subtitle?: string;
  description?: string[];

  style?: ViewStyle;
  extraContentContainerStyle?: ViewStyle;
  children?: JSX.Element | JSX.Element[];
};


export function ExampleItemCard(props: ExampleItemCardProps) {

  const descriptionMain = props.description?.[0];
  const descriptionSub  = props.description?.slice(1);

  return (
    <View style={[styles.rootContainer, props.style]}>
      <View style={styles.headerContainer}>
        <Text style={styles.headerTitleIndexText}>
            {`${props.index ?? 0}. `}
          </Text>
        <View style={styles.headerTitleContainer}>
          <Text style={styles.headerTitleText}>
            {props.title ?? 'N/A'}
          </Text>
          {props.subtitle && (
            <Text style={styles.headerSubtitleText}>
              {props.subtitle}
            </Text>
          )}
        </View>
      </View>
      <View style={styles.bodyContainer}>
        {descriptionMain && (
          <Text style={styles.bodyDescriptionText}>
            <Text style={styles.bodyDescriptionLabelText}>
              {'Description: '}
            </Text>
            {descriptionMain}
          </Text>
        )}
        {descriptionSub?.map((description, index) => (
          <Text 
            key={`desc-${index}`}
            style={[styles.bodyDescriptionText, styles.bodyDescriptionSubText]}
          >
            {description}
          </Text>
        ))}
        {(React.Children.count(props.children) > 0) && (
          <View style={props.extraContentContainerStyle}>
            {props.children}
          </View>
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    borderRadius: 10,
    overflow: 'hidden',
  },
  headerContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 15,
    paddingVertical: 8,
    backgroundColor: Colors.BLUE.A700,
  },
  headerTitleContainer: {
    marginLeft: 5,
  },
  headerTitleText: {
    flex: 1,
    fontSize: 16,
    fontWeight: '700',
    color: 'white',
  },
  headerTitleIndexText: {
    fontSize: 16,
    fontWeight: '800',
    color: 'rgba(255,255,255,0.75)',
  },
  headerSubtitleText: {
    fontSize: 14,
    color: 'rgba(255,255,255,0.75)',
    fontWeight: '600',
  },
  bodyContainer: {
    paddingHorizontal: 12,
    paddingTop: 7,
    paddingBottom: 10,
    backgroundColor: Colors.BLUE[100],
  },
  bodyDescriptionText: {
    fontWeight: '300',
    color: 'rgba(0,0,0,0.75)'
  },
  bodyDescriptionLabelText: {
    fontWeight: 'bold',
    color: Colors.BLUE[1100],
  },
  bodyDescriptionSubText: {
    marginTop: 10,
  },
});
