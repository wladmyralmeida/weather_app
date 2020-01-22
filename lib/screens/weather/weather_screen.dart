import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_application/bloc/weather_bloc.dart';
import 'package:weather_application/bloc/weather_event.dart';
import 'package:weather_application/bloc/weather_state.dart';
import 'package:weather_application/repository/weather_repository.dart';
import 'package:weather_application/screens/forecast/forecast.dart';
import 'package:weather_application/service/weather_service.dart';
import 'package:weather_application/api/keys.dart' as utils;
import 'package:weather_application/utils/navigator_shortcut.dart';
import 'package:weather_application/widgets/weather_widget.dart';

enum OptionsMenu { changeCity, forecast }

class WeatherScreen extends StatefulWidget {
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherService:
          WeatherService(httpClient: http.Client(), apiKey: utils.apiKey));

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  WeatherBloc _weatherBloc;
  String _cityName = 'silverstone';
  AnimationController _fadeController;
  Animation<double> _fadeAnimation;
  ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    _fetchWeatherWithLocation().catchError((error) {
      _fetchWeatherWithCity();
    });
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: _theme.primaryColor,
          elevation: 0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                style: TextStyle(
                    color: _theme.accentColor.withAlpha(80), fontSize: 14),
              )
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<OptionsMenu>(
                child: Icon(
                  Icons.more_vert,
                  color: _theme.accentColor,
                ),
                onSelected: this._onOptionMenuItemSelected,
                itemBuilder: (context) => <PopupMenuEntry<OptionsMenu>>[
                      PopupMenuItem<OptionsMenu>(
                        value: OptionsMenu.changeCity,
                        child: Text("Mudar Cidade"),
                      ),
                      PopupMenuItem<OptionsMenu>(
                        value: OptionsMenu.forecast,
                        child: Text("Outras Cidades"),
                      ),
                    ])
          ],
        ),
        backgroundColor: Colors.white,
        body: Material(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                color: _theme.primaryColor),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: BlocBuilder(
                  bloc: _weatherBloc,
                  builder: (_, WeatherState weatherState) {
                    if (weatherState is WeatherLoaded) {
                      this._cityName = weatherState.weather.cityName;
                      _fadeController.reset();
                      _fadeController.forward();
                      return WeatherWidget(
                        weather: weatherState.weather,
                      );
                    } else if (weatherState is WeatherError ||
                        weatherState is WeatherEmpty) {
                      String errorText =
                          'Ocorreu um erro ao obter dados meteorológicos';
                      if (weatherState is WeatherError) {
                        if (weatherState.errorCode == 404) {
                          errorText =
                              'Temos dificuldade em obter tempo para $_cityName';
                        }
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 24,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            errorText,
                            style: TextStyle(
                                color: _theme
                                    .accentColor),
                          ),
                          FlatButton(
                            child: Text(
                              "Tente novamente",
                              style: TextStyle(
                                  color: _theme
                                      .accentColor),
                            ),
                            onPressed: _fetchWeatherWithCity,
                          )
                        ],
                      );
                    } else if (weatherState is WeatherLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor:
                          _theme.primaryColor,
                        ),
                      );
                    }
                  }),
            ),
          ),
        ));
  }

  void _showCityChangeDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Mudar Cidade', style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                onPressed: () {
                  _fetchWeatherWithCity();
                  pop(context);
                },
              ),
            ],
            content: TextField(
              autofocus: true,
              onChanged: (text) {
                _cityName = text;
              },
              decoration: InputDecoration(
                  hintText: 'Nome da sua cidade',
                  hintStyle: TextStyle(color: Colors.black),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _fetchWeatherWithLocation().catchError((error) {
                        _fetchWeatherWithCity();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.my_location,
                      color: Colors.black,
                      size: 16,
                    ),
                  )),
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.black,
            ),
          );
        });
  }

  _onOptionMenuItemSelected(OptionsMenu item) {
    switch (item) {
      case OptionsMenu.changeCity:
        this._showCityChangeDialog();
        break;
      case OptionsMenu.forecast:
        push(context, ForecastScreen());
        break;
    }
  }

  _fetchWeatherWithCity() {
    _weatherBloc.dispatch(FetchWeather(cityName: _cityName));
  }

  _fetchWeatherWithLocation() async {
    var permissionHandler = PermissionHandler();
    var permissionResult = await permissionHandler
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    switch (permissionResult[PermissionGroup.locationWhenInUse]) {
      case PermissionStatus.denied:
      case PermissionStatus.unknown:
        print('location permission denied');
        _showLocationDeniedDialog(permissionHandler);
        throw Error();
    }

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    _weatherBloc.dispatch(FetchWeather(
        longitude: position.longitude, latitude: position.latitude));
  }

  void _showLocationDeniedDialog(PermissionHandler permissionHandler) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('A localização está desabilitada, reative-a',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Enable!',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                onPressed: () {
                  permissionHandler.openAppSettings();
                  pop(context);
                },
              ),
            ],
          );
        });
  }
}
