import 'dart:async';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/screens/weather/dao/weather_dao.dart';
import 'package:weather_application/service/weather_service.dart';
import 'package:weather_application/utils/network.dart';

class WeatherBloc {
  final _streamController = StreamController<Weather>();

  Stream<Weather> get stream => _streamController.stream;

  Future<Weather> fetch(String name) async {
    try {

      if(! await isNetworkOn()) {
        Weather weather =  await WeatherDAO().findByName(name);
        if(! _streamController.isClosed) {
          _streamController.add(weather);
        }
        return weather;
      }

      Weather weather = await WeatherService.getWeather(name);

      if(weather != null) {
        final dao = WeatherDAO();

        dao.save(weather);
      }

      _streamController.add(weather);

      return weather;
    } catch (e) {
      if(! _streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}
