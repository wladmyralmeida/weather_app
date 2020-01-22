import 'package:flutter/material.dart';
import 'package:weather_application/db/entity.dart';
import 'package:weather_application/utils/temperatures.dart';
import 'package:weather_application/utils/icons.dart';
import 'dart:convert' as convert;

class Weather extends Entity {
  int id;
  int time;
  int sunrise;
  int sunset;
  int humidity;

  String description;
  String iconCode;
  String main;
  String cityName;

  double windSpeed;

  Temperature temperature;
  Temperature maxTemperature;
  Temperature minTemperature;

  List<Weather> forecast;

  Weather(
      {this.id,
      this.time,
      this.sunrise,
      this.sunset,
      this.humidity,
      this.description,
      this.iconCode,
      this.main,
      this.cityName,
      this.windSpeed,
      this.temperature,
      this.maxTemperature,
      this.minTemperature,
      this.forecast});

  static Weather fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    return Weather(
      id: weather['id'],
      time: json['dt'],
      description: weather['description'],
      iconCode: weather['icon'],
      main: weather['main'],
      cityName: json['name'],
      temperature: Temperature(intToDouble(json['main']['temp'])),
      maxTemperature: Temperature(intToDouble(json['main']['temp_max'])),
      minTemperature: Temperature(intToDouble(json['main']['temp_min'])),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      humidity: json['main']['humidity'],
      windSpeed: intToDouble(json['wind']['speed']),
    );
  }

  Weather.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    main = map['main'];
    cityName = map['cityName'];
    description = map['description'];
    humidity = map['humidity'];
    iconCode = map['iconCode'];
    maxTemperature = map['maxTemperature'];
    minTemperature = map['minTemperature'];
    sunrise = map['sunrise'];
    sunset = map['sunset'];
    temperature = map['temperature'];
    time = map['time'];
    windSpeed = map['windSpeed'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main'] = this.main;
    data['cityName'] = this.cityName;
    data['description'] = this.description;
    data['humidity'] = this.humidity;
    data['iconCode'] = this.iconCode;
    data['maxTemperature'] = this.maxTemperature;
    data['minTemperature'] = this.minTemperature;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['temperature'] = this.temperature;
    data['time'] = this.time;
    data['windSpeed'] = this.windSpeed;
    return data;
  }

  static List<Weather> fromForecastJson(Map<String, dynamic> json) {
    final weathers = List<Weather>();
    for (final item in json['list']) {
      weathers.add(Weather(
          time: item['dt'],
          temperature: Temperature(intToDouble(
            item['main']['temp'],
          )),
          iconCode: item['weather'][0]['icon']));
    }
    return weathers;
  }
  
  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }
  
  IconData getIconData() {
    switch (this.iconCode) {
      case '01d':
        return WIcons.clear_day;
      case '01n':
        return WIcons.clear_night;
      case '02d':
        return WIcons.few_clouds_day;
      case '02n':
        return WIcons.few_clouds_day;
      case '03d':
      case '04d':
        return WIcons.clouds_day;
      case '03n':
      case '04n':
        return WIcons.clear_night;
      case '09d':
        return WIcons.shower_rain_day;
      case '09n':
        return WIcons.shower_rain_night;
      case '10d':
        return WIcons.rain_day;
      case '10n':
        return WIcons.rain_night;
      case '11d':
        return WIcons.thunder_storm_day;
      case '11n':
        return WIcons.thunder_storm_night;
      case '13d':
        return WIcons.snow_day;
      case '13n':
        return WIcons.snow_night;
      case '50d':
        return WIcons.mist_day;
      case '50n':
        return WIcons.mist_night;
      default:
        return WIcons.clear_day;
    }
  }
}
