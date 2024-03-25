import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stravaclone/features/data/models/weather_model.dart';

abstract class WeatherAPI {
  Future<List<WeatherModel>> getData({required lat, required long});
}
class WeatherAPIImpl implements WeatherAPI {
  @override
  Future<List<WeatherModel>> getData({required lat, required long}) async {
    List<WeatherModel> weatherData = [];
    final uri = Uri.https('api.weatherapi.com', '/v1/forecast.json',
        {
          'key' : 'a82d9ff2750d4e339a8100251231911',
          'q' : '${lat},${long}',
          'days' : '1',
        });
    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    DateTime now = DateTime.now();
    int hourNow = now.hour;
    var hourData = data['forecast']['forecastday'][0]['hour'];
    List<Map<String, dynamic>> weatherRemainToday = [];
    for (var hour in hourData) {
      if (int.parse(hour['time'].substring(11, 13)) >= hourNow) {
        weatherRemainToday.add(hour);
      }
    }
    for (var hour in weatherRemainToday) {
      weatherData.add(
        WeatherModel(
          time: '${hour['time'].substring(11, 16)}',
          image: 'https:${hour['condition']['icon']}',
          chance_of_rain: '${hour['chance_of_rain']}',
          cloud: '${hour['cloud']}',
          condition: '${hour['condition']['text']}',
          humidity: '${hour['humidity']}',
          precip_mm: '${hour['precip_mm']}',
          temp_c:  '${hour['temp_c']} C',
          uv: '${hour['uv']}',
          wind_degree: '${hour['wind_degree']}',
          wind_mph: '${hour['wind_mph']}',
        )
      );

    }
    return weatherData;
  }

}