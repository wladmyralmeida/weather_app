import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/widgets/forecast_horizontal_widget.dart';
import 'package:weather_application/widgets/value_tile.dart';
import 'package:weather_application/widgets/weather_swipe_pager.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  WeatherWidget({this.weather}) : assert(weather != null);

  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.weather.cityName.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                color: _theme.accentColor,
                fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            this.weather.description.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w100,
                letterSpacing: 5,
                fontSize: 15,
                color: _theme.accentColor),
          ),
          WeatherSwipePager(weather: weather),
          Padding(
            child: Divider(
              color:
              _theme.accentColor.withAlpha(50),
            ),
            padding: EdgeInsets.all(10),
          ),
          ForecastHorizontal(weathers: weather.forecast),
          Padding(
            child: Divider(
              color:
              _theme.accentColor.withAlpha(50),
            ),
            padding: EdgeInsets.all(10),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ValueTile("Vel. Vento", '${this.weather.windSpeed} m/s'),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                  child: Container(
                    width: 1,
                    height: 30,
                    color: _theme
                        .accentColor
                        .withAlpha(50),
                  )),
            ),
            ValueTile(
                "Nasc. Sol",
                DateFormat('h:m a').format(DateTime.fromMillisecondsSinceEpoch(
                    this.weather.sunrise * 1000))),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                  child: Container(
                    width: 1,
                    height: 30,
                    color: _theme
                        .accentColor
                        .withAlpha(50),
                  )),
            ),
            ValueTile(
                "Pôr-do-Sol",
                DateFormat('h:m a').format(DateTime.fromMillisecondsSinceEpoch(
                    this.weather.sunset * 1000))),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                  child: Container(
                    width: 1,
                    height: 30,
                    color: _theme
                        .accentColor
                        .withAlpha(50),
                  )),
            ),
            ValueTile("Humidade", '${this.weather.humidity}%'),
          ]),
        ],
      ),
    );
  }
}
