import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_application/screens/weather/weather_screen.dart';
import 'package:weather_application/utils/constants.dart';
import 'package:weather_application/utils/temperatures.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(AppStateContainer(child: WeatherApp()));
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: WeatherScreen(),
    );
  }
}

class AppStateContainer extends StatefulWidget {
  final Widget child;

  AppStateContainer({@required this.child});

  @override
  _AppStateContainerState createState() => _AppStateContainerState();

  static _AppStateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }
}

class _AppStateContainerState extends State<AppStateContainer> {
  TemperatureUnit temperatureUnit = TemperatureUnit.celsius;

  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }

  updateTemperatureUnit(TemperatureUnit unit) {
    setState(() {
      this.temperatureUnit = unit;
    });
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setInt(CONSTANTS.SHARED_PREF_KEY_TEMPERATURE_UNIT, unit.index);
    });
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _AppStateContainerState data;

  const _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) => true;
}
