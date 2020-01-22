import 'package:flutter/material.dart';
import 'package:weather_application/main.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/utils/temperatures.dart';

class CurrentConditions extends StatelessWidget {
  final String cityName;
  final Future<Weather> tempCity;

  const CurrentConditions({Key key, @required this.cityName, @required this.tempCity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          cityName.toUpperCase() ?? "",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
              color: _theme.accentColor,
              fontSize: 22),
        ),
        Text(
          tempCity.toString() ?? "",
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
