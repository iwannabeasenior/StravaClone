import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xml/xml.dart';
import 'dart:io';

File createGPXFile(List<LatLng> points, List<String> timeISO) {
  final gpx = XmlDocument([
    XmlProcessing('xml', 'version="1.0" encoding="UTF-8"'),
    XmlElement(
      XmlName('gpx'),
      [
        XmlAttribute(XmlName('version'), '1.1'),
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
              XmlName('time'),
              [],
              [XmlCDATA(timeISO[0])]
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
                XmlCDATA('Lunch SnowBoard'),
              ]
            ),
            XmlElement(
              XmlName('type'),
              [],
              [XmlCDATA('Snowboard')]
            ),
            XmlElement(
              XmlName('trkseg'),
              [],
              [
                for (int i = 0; i < points.length; i++)
                  XmlElement(
                    XmlName('trkpt'),
                    [
                      XmlAttribute(XmlName('lat'), points[i].latitude.toString()),
                      XmlAttribute(XmlName('lon'), points[i].longitude.toString()),
                    ],
                    [
                      XmlElement(
                        XmlName('ele'),
                        [],
                        [XmlCDATA('10')],
                      ),
                      XmlElement(
                        XmlName('time'),
                        [],
                        [
                          XmlCDATA(timeISO[i])
                        ],
                      )
                    ]
                  ),
              ]
            )

          ]
        )
      ],
    )
  ]);
  final gpxString = gpx.toXmlString(pretty: true);
  final file = File('path of file wanna save');
  file.writeAsStringSync(gpxString);
  return file;
}