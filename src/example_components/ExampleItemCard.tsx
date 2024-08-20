import * as React from 'react';
import { StyleSheet, View, Text, type ViewStyle, type TextStyle } from 'react-native';

import * as Colors from '../misc/Colors';


export type ExampleItemCardProps = {
  colorPalette?: typeof Colors.BLUE;
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

  const colors = props.colorPalette ?? Colors.BLUE;

  const bodyContainerStyle: ViewStyle = {
    backgroundColor: colors[100],
  };

  const bodyDescriptionLabelTextStyle: TextStyle = {
    color: colors[1100]
  };

  const headerContainerStyle: ViewStyle = {
    backgroundColor: colors.A700,
  };

  return (
    <View style={[styles.rootContainer, props.style]}>
      <View style={[styles.headerContainer, headerContainerStyle]}>
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
      <View style={[styles.bodyContainer, bodyContainerStyle]}>
        {descriptionMain && (
          <Text style={styles.bodyDescriptionText}>
            <Text style={[styles.bodyDescriptionLabelText, bodyDescriptionLabelTextStyle]}>
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
  },
  headerTitleContainer: {
    marginLeft: 5,
  },
  headerTitleText: {
    flex: 1,
    fontSize: 12,
    fontWeight: '700',
    color: 'white',
  },
  headerTitleIndexText: {
    fontSize: 14,
    fontWeight: '800',
    color: 'rgba(255,255,255,0.75)',
  },
  headerSubtitleText: {
    fontSize: 12,
    color: 'rgba(255,255,255,0.75)',
    fontWeight: '600',
  },
  bodyContainer: {
    paddingHorizontal: 12,
    paddingTop: 7,
    paddingBottom: 10,
  },
  bodyDescriptionText: {
    fontWeight: '300',
    color: 'rgba(0,0,0,0.75)'
  },
  bodyDescriptionLabelText: {
    fontWeight: 'bold',
  },
  bodyDescriptionSubText: {
    marginTop: 10,
  },
});
