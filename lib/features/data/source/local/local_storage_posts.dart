import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stravaclone/features/data/models/post_model.dart';

abstract class LocalStorage {
  Future<void> savePostPage({required PostModel post});
  Future<List<PostModel>> loadPostPage();
}

class LocalStorageImpl implements LocalStorage {
  final db = FirebaseFirestore.instance;
  @override
  Future<List<PostModel>> loadPostPage() async {
    List<PostModel> list = [];
    // runs -> run1 -> paths, pace, distance, time -> path1, path2, path3
    // db.collection('runs').doc('a')
    await db.collection('runs').get().then((event) async {
      for (var doc in event.docs) {
        if (doc.id == 'current') continue;
        var reference = doc.reference;
        var data = doc.data();
        await reference.collection('paths').get().then((value) {
          List<List<double>> elevation = [];
          List<List<GeoPoint>> path = [];
          List<List<String>> timeISO = [];
          for (var p in value.docs) {
            var data = p.data();
            var pathInPaths = <GeoPoint>[
              for (var i in data['path']) GeoPoint(i.latitude, i.longitude)
            ]; // dynamic to GeoPoint

            var timeISOInPath = <String>[
              for (var i in data['timeISO']) i.toString()
            ];
            var elevationInPath = <double>[
              for (var i in data['elevation']) i as double
            ];
            timeISO.add(timeISOInPath);
            path.add(pathInPaths);
            elevation.add(elevationInPath);
          }
          list.add(PostModel(
              distance: data['distance'],
              path: path,
              speed: data['speed'],
              time: data['time'],
              elevation: elevation,
              timeISO: timeISO,
              image: data['image']));
        });
         // dynamic to String
      }
    });
    return list;
  }

  @override
  Future<void> savePostPage({required PostModel post}) async {
    CollectionReference runsReference = db.collection('runs');
    DocumentReference doc = runsReference.doc(); // new doc in collection with random id, then we add new collection
    CollectionReference pathsReference = doc.collection('paths'); // new collection in doc with id paths
    int len = post.elevation!.length;
    // add data for collection
    for (int i = 0; i < len; i++) {
      pathsReference.add(
        {
          'elevation': post.elevation?[i],
          'path': post.path?[i],
          'timeISO': post.timeISO?[i]
        }
      );
    }
    // add data for doc with random id
    doc.set({
      'speed': post.speed,
      'distance': post.distance,
      'time': post.time,
      'image': post.image,
    });
    // all done
  }
}
