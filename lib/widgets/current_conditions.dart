import 'package:flutter/material.dart';
import 'package:weather_application/main.dart';
import 'package:weather_application/model/weather.dart';

class CurrentConditions extends StatelessWidget {
  final Weather weather;
  const CurrentConditions({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.weather.cityName.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
              color: _theme.accentColor,
              fontSize: 22),
        ),
        Text(
          '${this.weather.temperature.as(AppStateContainer.of(context).temperatureUnit).round()}°',
          style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w100,
              color: _theme.accentColor),
        ),
        Padding(
          child: Divider(
            color:
            _theme.accentColor,
          ),
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}
