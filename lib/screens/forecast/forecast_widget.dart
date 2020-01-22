import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_application/model/weather.dart';

class ForecastWidget extends StatelessWidget {
  ForecastWidget(List<Weather> forecastList);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: InkWell(
          onTap: () {
          },
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Text("Data formatada",
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.body1),
                Text("Temperatura",
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.body1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
