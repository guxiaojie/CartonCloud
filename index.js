import React from 'react';
import {AppRegistry, StyleSheet, Text, Image, View, FlatList, SectionList, ActivityIndicator} from 'react-native';

class RNWeather extends React.Component {
  
  render() {
    var contents = this.props['weather'].map((weather) => (
      <Text key={weather.name}>
        {weather.date}:  {weather.weather_state_name}   {weather.min_temp} - {weather.max_temp}
        {'\n'}
      </Text>
    
    ));
    return (
      <View style={styles.container}>
        <Text style={styles.weatherTitle}>Weather of yeaterday!</Text>
        <Text style={styles.items}>{contents}</Text>

        <Image
          style={{width: 50, height: 50}}
          source={{uri: 'https://facebook.github.io/react-native/docs/assets/favicon.png'}}
        />

      

      </View>
    );
  }

}

const styles = StyleSheet.create({

  container: {
    flex: 1,
    padding: 12,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  text: {
    marginLeft: 12,
    fontSize: 16,
  },

  
  weatherTitle: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  items: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

// Module name
AppRegistry.registerComponent('RNWeather', () => RNWeather);


