import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart' ;
void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: VietMap(),
      ),
    )
  );
}
class VietMap extends StatefulWidget {
  const VietMap({super.key});

  @override
  State<VietMap> createState() => _VietMapState();
}

class _VietMapState extends State<VietMap> {
  late Completer<VietmapController> completer;
  late VietmapController controller;
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VietmapGL(
            initialCameraPosition: const CameraPosition(target: LatLng(90, 100), zoom: 30),
            styleString: 'https://maps.vietmap.vn/api/maps/dark/styles.json?apikey=c3d0f188ff669f89042771a20656579073cffec5a8a69747',
            // onMapCreated: (VietmapController controller) {
            //   completer.complete(controller);
            // },
            // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
            // zoomGesturesEnabled: true,
            // onUserLocationUpdated: (UserLocation location) {
            //   // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location.position)));
            // },
            // onMapRenderedCallback: ()  {
            //   Future<VietmapController> p = completer.future;
            //   p.then((value) {
            //     controller = value;
            //   });
            // },
            // compassEnabled: true,
            // trackCameraPosition: true,
            // myLocationEnabled: true,
        ),
        // MarkerLayer(
        //     ignorePointer: true,
        //     markers: [
        //       Marker(
        //           child: Icon(Icons.location_on),
        //           latLng:
        //       ),
        //     ],
        //     mapController: controller),
      ],
    );
  }
}
