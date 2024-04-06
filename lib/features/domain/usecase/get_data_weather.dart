

import 'package:stravaclone/features/domain/entity/weather.dart';

import '../repositories/weather_repository.dart';

class GetDataWeather {
  final WeatherRepository repository;
  GetDataWeather({required this.repository});
  Future<List<Weather>> getWeatherToday({required lat, required long}) async {
    final data = await repository.getWeatherToday(lat: lat, long: long);
    return data;
  }
}