import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stravaclone/features/domain/entity/post.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class PostModel extends Post {
  PostModel(
      {super.distance,
      super.path,
      super.speed,
      super.time,
      super.timeISO,
      super.elevation,
      super.image});
  PostModel.from(
      {super.distance,
        super.path,
        super.speed,
        super.time,
        super.timeISO,
        super.elevation,
        super.image});
  factory PostModel.map({double? distance, List<List<LatLng>>? paths, double? speed, String? time, List<List<String>>? timeISO, List<List<double>>? elevation, String? image}) {
    List<List<GeoPoint>> path = [];

    for (List<LatLng> p in paths!) {
      List<GeoPoint> list = [];
      for (LatLng latlng in p) {
        list.add(GeoPoint(latlng.latitude, latlng.longitude));
      }
      path.add(list);
    }

    return PostModel(
      distance: distance,
      time: time,
      image: image,
      timeISO: timeISO,
      speed: speed,
      path: path,
      elevation: elevation
    );
  }
  Map<String, dynamic> toMap() => {
        'image': image,
        'distance': distance,
        'path': path,
        'speed': speed,
        'time': time,
        'timeISO': timeISO,
        'elevation': elevation,
      };
}
