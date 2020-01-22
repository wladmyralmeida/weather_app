

// Data Access Object
import 'package:weather_application/db/base_dao.dart';
import 'package:weather_application/model/weather.dart';

class WeatherDAO extends BaseDAO<Weather> {

  @override
  String get tableName => "weather";

  @override
  Weather fromMap(Map<String, dynamic> map) {
    return Weather.fromMap(map);
  }

  Future<List<Weather>> findAllByCityName(String name) async {
    List<Weather> weather = await query('select * from weather where name =? ',[name]);
    return weather;
  }
}
