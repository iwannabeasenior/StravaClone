import 'package:stravaclone/features/domain/entity/weather.dart';

abstract class WeatherRepository {
  Future<List<Weather>> getWeatherToday({required lat, required long});
}