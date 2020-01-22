import 'package:flutter/material.dart';
import 'package:weather_application/screens/weather/weather_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        key: Key('materialapp'),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.blue
        ),
        home: WeatherScreen()
    );
  }
}
