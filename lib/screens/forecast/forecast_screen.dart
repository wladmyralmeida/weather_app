import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/main.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/widgets/content_header.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({
    Key key,
    @required this.weathers,
  }) : super(key: key);

  final List<Weather> weathers;

  @override
  Widget build(BuildContext context) {

    ThemeData _theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _theme.primaryColor,
      appBar: AppBar(title: Text("Forecast Screen"),),
      body: Container(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: this.weathers.length,
          separatorBuilder: (context, index) => Divider(
            height: 15,
            color: Colors.white,
          ),
          padding: EdgeInsets.only(top: 15.0, left: 10, right: 10),
          itemBuilder: (context, index) {
            final item = this.weathers[index];
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                  child: ContentHeader(
                    DateFormat('E, ha').format(
                        DateTime.fromMillisecondsSinceEpoch(item.time * 1000)),
                    '${item.temperature.as(AppStateContainer.of(context).temperatureUnit).round()}°',
                    iconData: item.getIconData(),
                  )),
            );
          },
        ),
      ),
    );
  }
}
