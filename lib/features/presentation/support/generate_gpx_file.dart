import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart' ;
import 'package:xml/xml.dart';
import 'dart:io';

Future<void> createGPXFile(List<List<LatLng>> points, List<List<double>> elevation, List<List<String>> timeISO) async {
  XmlElement trkseg = XmlElement(
    XmlName('trkseg'),
    [],
    [],
  );
  for (int i = 0; i < points.length; i++) {
    // Loop through each point in the segment
    for (int j = 0; j < points[i].length; j++) {
      // Create trkpt element for each point
      XmlElement trkpt = XmlElement(
        XmlName('trkpt'),
        [
          XmlAttribute(XmlName('lat'), points[i][j].latitude.toStringAsFixed(6)),
          XmlAttribute(XmlName('lon'), points[i][j].longitude.toStringAsFixed(6)),
        ],
        [
          XmlElement(
            XmlName('ele'),
            [],
            [XmlText(elevation[i][j].toString())],
          ),
          XmlElement(
            XmlName('time'),
            [],
            [XmlText(timeISO[i][j])],
          )
        ],
      );

      // Add the trkpt element to the main trkseg element
      trkseg.children.add(trkpt);
    }

    // Add wpt element after each segment
    if (i != points.length -1) trkseg.children.add(XmlElement(XmlName('wpt')));
  }
  final gpx = XmlDocument([
    XmlProcessing('xml', 'version="1.0" encoding="UTF-8"'),
    XmlElement(
      XmlName('gpx'),
      [
        XmlAttribute(XmlName('creator'), 'StravaGPX iPhone'),
        XmlAttribute(XmlName('xmlns:xsi'), 'http://www.w3.org/2001/XMLSchema-instance'),
        XmlAttribute(XmlName('xsi:schemaLocation'), 'http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd'),
        XmlAttribute(XmlName('version'), '1.1'),
        XmlAttribute(XmlName('xmlns'), 'http://www.topografix.com/GPX/1/1'),
      ],
      [
        XmlElement(
          XmlName('metadata'),
          [

          ],
          [
            XmlElement(
              XmlName('name'),
              [],
              [XmlText('trackGPS')]
            ),
            XmlElement(
              XmlName('author'),
              [],
              [
                XmlElement(
                  XmlName('name'),
                  [],
                  [XmlText('gpx.studio')]
                ),
                XmlElement(
                  XmlName('link'),
                  [XmlAttribute(XmlName('href'), 'https://gpx.studio')]
                )
              ]
            )
          ]
        ),

        XmlElement(
          XmlName('trk'),
          [],
          [
            XmlElement(
              XmlName('name'),
              [],
              [
                XmlText('Lunch SnowBoard'),
              ]
            ),
            XmlElement(
              XmlName('type'),
              [],
              [XmlText('Running')]
            ),
            trkseg

          ]
        )
      ],
    )
  ]);


  final gpxString = gpx.toXmlString(pretty: true);
  final file = File('/storage/emulated/0/Download/gpxFake.gpx');
  file.writeAsStringSync(gpxString);
}