import 'package:equatable/equatable.dart';

class Weather with EquatableMixin{
  String? time;
  String? image;
  String? temp_c;
  String? chance_of_rain;
  String? condition;
  String? precip_mm;
  String? wind_mph;
  String? humidity;
  String? cloud;
  String? uv;
  String? wind_degree;
  Weather({this.time, this.image, this.temp_c, this.chance_of_rain, this.condition, this.precip_mm, this.wind_mph, this.humidity, this.cloud, this.uv, this.wind_degree});

  @override
  // TODO: implement props
  List<Object?> get props => [
    time,
    image,
    temp_c,
    chance_of_rain,
    condition,
    precip_mm,
    wind_mph,
    humidity,
    cloud,
    uv,
    wind_degree,
  ];
}