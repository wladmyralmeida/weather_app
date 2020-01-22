import 'package:flutter/material.dart';
import 'package:weather_application/bloc/weather_bloc.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/service/weather_service.dart';
import 'package:weather_application/widgets/forecast_horizontal_widget.dart';

class ForecastScreen extends StatefulWidget {
  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final bloc = WeatherBloc();

  void showWeather() async {
    var data = WeatherService.getWeather("London");
    print(data.toString());
  }

  Future<void> _onRefresh() {
    return bloc.fetch("London");
  }

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Climates"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: bloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Não foi possível buscar os carros");
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Weather> weather = snapshot.data;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ForecastHorizontal(
                weathers: weather,
              ),
            );
          },
        ),
      ),
    );
  }
}
