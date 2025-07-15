import * as React from 'react';
import { StyleSheet, View, Text, type ViewStyle, type TextStyle, type StyleProp } from 'react-native';

import { Colors } from '../misc/Colors';


export type ExampleItemCardProps = {
  colorPalette?: typeof Colors.BLUE;
  index?: number;
  title?: string;
  subtitle?: string;
  description?: Array<string | undefined>;

  style?: StyleProp<ViewStyle>;
  extraContentContainerStyle?: ViewStyle;
  children?: JSX.Element | JSX.Element[];
};


export function ExampleItemCard(props: ExampleItemCardProps) {

  const descriptionFiltered = props.description?.filter(item => item != null);

  const descriptionMain = descriptionFiltered?.[0];
  const descriptionSub  = descriptionFiltered?.slice(1);

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

  const shouldShowHeaderTitleIndex = props.index != null;
  const isTitleOnly = props.subtitle == null;

  const headerTitleTextStyle: TextStyle = {
    ...(isTitleOnly && {
      fontSize: 16,
    }),
  };

  const titleAndSubtitleElement = (
    <React.Fragment>
      <Text style={[styles.headerTitleText, headerTitleTextStyle]}>
        {props.title ?? 'N/A'}
      </Text>
      {props.subtitle && (
        <Text style={styles.headerSubtitleText}>
          {props.subtitle}
        </Text>
      )}
    </React.Fragment>
  );

  return (
    <View style={[styles.rootContainer, props.style]}>
      <View style={[styles.headerContainer, headerContainerStyle]}>
        {shouldShowHeaderTitleIndex ? (
          <React.Fragment>
            <Text style={styles.headerTitleIndexText}>
              {`${props.index!}. `}
            </Text>
            <View style={styles.headerTitleContainer}>
              {titleAndSubtitleElement}
            </View>
          </React.Fragment>
        ) : (
          titleAndSubtitleElement
        )}
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
    fontSize: 14,
    fontWeight: '600',
    color: 'rgba(255,255,255,0.9)',
  },
  headerTitleIndexText: {
    fontSize: 16,
    fontWeight: '800',
    color: 'rgba(255,255,255,0.6)',
  },
  headerSubtitleText: {
    fontSize: 12,
    color: 'rgba(255,255,255,0.8)',
    fontWeight: '400',
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
