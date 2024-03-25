

import 'package:stravaclone/features/domain/entity/weather.dart';

import '../repositories/weather_repository.dart';

class GetWeatherToday {
  final WeatherRepository repository;
  GetWeatherToday({required this.repository});
  Future<List<Weather>> call({required lat, required long}) async {
    final data = await repository.getWeatherToday(lat: lat, long: long);
    return data;
  }
}