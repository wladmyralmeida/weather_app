import 'package:meta/meta.dart';
import 'package:weather_application/model/weather.dart';
import 'package:weather_application/service/weather_service.dart';

class WeatherRepository {
  final WeatherService weatherService;
  WeatherRepository({@required this.weatherService})
      : assert(weatherService != null);

  Future<Weather> getWeather(String cityName,
      {double latitude, double longitude}) async {
    if (cityName == null) {
      cityName = await weatherService.getCityNameFromLocation(
          latitude: latitude, longitude: longitude);
    }
    var weather = await weatherService.getWeatherData(cityName);
    var weathers = await weatherService.getForecast(cityName);
    weather.forecast = weathers;
    return weather;
  }
}
