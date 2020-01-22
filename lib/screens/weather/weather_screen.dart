import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_application/bloc/weather_bloc.dart';
import 'package:weather_application/bloc/weather_event.dart';
import 'package:weather_application/bloc/weather_state.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/repository/weather_repository.dart';
import 'package:weather_application/screens/forecast/forecast_screen.dart';
import 'package:weather_application/service/weather_service.dart';
import 'package:weather_application/api/keys.dart' as utils;
import 'package:weather_application/utils/navigator_shortcut.dart';
import 'package:weather_application/utils/temperatures.dart';
import 'package:weather_application/widgets/current_conditions.dart';

enum OptionsMenu { changeCity }

class WeatherScreen extends StatefulWidget {
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherService:
          WeatherService(httpClient: http.Client(), apiKey: utils.apiKey));

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  static WeatherBloc _weatherBloc;
  AnimationController _fadeController;
  Animation<double> _fadeAnimation;
  ThemeData _theme;
  Future<Weather> _tempCity1;
  Future<Weather> _tempCity2;
  Future<Weather> _tempCity3;
  Future<Weather> _tempCity4;

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    _fetchWeatherWithLocation().catchError((error) {
      _fetchWeatherWithCity();
      _tempCity1 = _weatherBloc.weatherRepository.getWeather("Silverstone");
      _tempCity2 = _weatherBloc.weatherRepository.getWeather("São Paulo");
      _tempCity3 = _weatherBloc.weatherRepository.getWeather("Melbourne");
      _tempCity4 = _weatherBloc.weatherRepository.getWeather("Monte Carlo");
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
                DateFormat('dd, MMMM, yyyy').format(DateTime.now()),
                style: TextStyle(
                    color: _theme.accentColor, fontSize: 14),
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Material(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(color: _theme.primaryColor),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: BlocBuilder(
                  bloc: _weatherBloc,
                  builder: (_, WeatherState weatherState) {
                    if (weatherState is WeatherLoaded) {
                      /*this._cityName = weatherState.weather.cityName;
                      this._tempCity = weatherState.weather.temperature;*/
                      _fadeController.reset();
                      _fadeController.forward();
                      return SingleChildScrollView(
                        child: GestureDetector(
                          onTap: (){
                            push(context, ForecastScreen(weathers: weatherState.weather.forecast,));
                          },
                          child: Column(
                            children: <Widget>[
                              CurrentConditions(cityName: "Silverstone", tempCity: _tempCity1),
                              CurrentConditions(cityName: "São Paulo", tempCity: _tempCity2),
                              CurrentConditions(cityName: "Melbourne", tempCity: _tempCity3),
                              CurrentConditions(cityName: "Monte Carlo", tempCity: _tempCity4),
                            ],
                          )
                        ),
                      );
                    } else if (weatherState is WeatherError ||
                        weatherState is WeatherEmpty) {
                      String errorText =
                          'Ocorreu um erro ao obter dados meteorológicos';
                      if (weatherState is WeatherError) {
                        if (weatherState.errorCode == 404) {
                          errorText =
                              'Temos dificuldade em obter tempo para a cidade desejada';
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
                            style: TextStyle(color: _theme.accentColor),
                          ),
                          FlatButton(
                            child: Text(
                              "Tente novamente",
                              style: TextStyle(color: _theme.accentColor),
                            ),
                            onPressed: _fetchWeatherWithCity,
                          )
                        ],
                      );
                    } else if (weatherState is WeatherLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: _theme.primaryColor,
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
          ),
        ));
  }

  _fetchWeatherWithCity() {
    _weatherBloc.dispatch(FetchWeather(cityName: "Silvertone"));
    _weatherBloc.dispatch(FetchWeather(cityName: "São Paulo"));
    _weatherBloc.dispatch(FetchWeather(cityName: "Melbourne"));
    _weatherBloc.dispatch(FetchWeather(cityName: "Monte Carlo"));



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
