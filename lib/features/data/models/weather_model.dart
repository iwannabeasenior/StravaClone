import 'package:stravaclone/features/domain/entity/weather.dart';

class WeatherModel extends Weather{
  WeatherModel({
    super.chance_of_rain,
    super.cloud,
    super.condition,
    super.humidity,
    super.image,
    super.precip_mm,
    super.temp_c,
    super.time,
    super.uv,
    super.wind_degree,
    super.wind_mph});
}