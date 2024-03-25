import 'package:stravaclone/features/data/source/network/weather_api.dart';
import 'package:stravaclone/features/domain/entity/weather.dart';
import 'package:stravaclone/features/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherAPI api;
  WeatherRepositoryImpl({required this.api});
  @override
  Future<List<Weather>> getWeatherToday({required lat, required long}) async {
    final data = await api.getData(lat: lat, long: long);
    return data;
  }
}