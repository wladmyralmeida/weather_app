import 'package:flutter/material.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/widgets/current_conditions.dart';
class WeatherWidget extends StatefulWidget {
  final Weather weather;

  WeatherWidget({this.weather}) : assert(weather != null);

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CurrentConditions(weather: widget.weather,),
          CurrentConditions(weather: widget.weather,),
          CurrentConditions(weather: widget.weather,),
          CurrentConditions(weather: widget.weather,),
        ],
      ),
    );
  }
}
