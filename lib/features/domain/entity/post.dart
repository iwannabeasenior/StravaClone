import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Post with EquatableMixin {
  final double? distance;
  final double? speed;
  final String? time;
  final List<List<GeoPoint>>? path;
  final List<List<String>>? timeISO;
  final List<List<double>>? elevation;
  final String? image;

  Post(
      {this.distance,
      this.speed,
      this.time,
      this.path,
      this.timeISO,
      this.elevation,
      this.image});
  @override
  // TODO: implement props
  List<Object?> get props => [
        distance,
        speed,
        time,
        path,
        elevation,
        timeISO,
      ];
}
