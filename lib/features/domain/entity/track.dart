import 'package:equatable/equatable.dart';

class Track with EquatableMixin {
  final String? image;
  final String? name;
  final String? uri;
  final List<String>? artist;
  Track({this.image, this.name, this.uri, this.artist});

  @override
  // TODO: implement props
  List<Object?> get props => [
        image,
        name,
        uri,
        artist,
      ];
}
