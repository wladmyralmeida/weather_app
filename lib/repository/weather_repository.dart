import 'package:meta/meta.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/service/weather_service.dart';

class WeatherRepository {
  final WeatherService ws;
  WeatherRepository({@required this.ws})
      : assert(ws != null);

  Future<Weather> getWeather(String cityName,
      {double latitude, double longitude}) async {
    if (cityName == null) {
      cityName = await ws.getCityNameFromLocation(
          latitude: latitude, longitude: longitude);
    }
    var weather = await ws.getWeatherData(cityName);
    var weathers = await ws.getForecast(cityName);
    weather.forecast = weathers;
    return weather;
  }
}
