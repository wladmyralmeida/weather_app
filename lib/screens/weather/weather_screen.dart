import 'package:flutter/material.dart';
import 'package:weather_application/screens/drawer/drawer_screen.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
        drawer: Drawer(
          child: DrawerScreen(),
        ),
        appBar: AppBar(
          title: Text("Weather App"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: (){})
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                "assets/images/home_background.jpg",
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(right: 16.0, top: 16.0),
              child: Image.asset("assets/images/clouds.png"),
            ),
            Container(
              alignment: Alignment.center,
              child: updateTempWidget("London"),
            ),
          ],
        ));
  }

  TextStyle styleClimate(ThemeData _theme) => TextStyle(
      color: _theme.accentColor, fontWeight: FontWeight.bold, fontSize: 40.0);

  TextStyle styleCurrentCity(ThemeData _theme) {
    return TextStyle(
        fontSize: 24.0,
        color: _theme.accentColor,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold);
  }

  Widget updateTempWidget(String city) {
    return Container();/*FutureBuilder(
        future: WeatherService.getWeather(city),
        builder: (context, AsyncSnapshot<Map> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 40,
              width: 40,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          Map content = snapshot.data;
          return GestureDetector(
            onTap: (){
              push(context, ForecastScreen());
            },
            child: Container(
              margin: EdgeInsets.only(left: 8.0, top: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      content['name'],
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: _theme.accentColor,
                      ),
                    ),
                    subtitle: Text(
                      content['main']['temp'].toString() + " °F",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: _theme.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });*/
  }
}
