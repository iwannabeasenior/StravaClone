import 'package:flutter/material.dart';
import 'package:vietmap_flutter_navigation/embedded/controller.dart';
import 'package:vietmap_flutter_navigation/models/options.dart';
import 'package:vietmap_flutter_navigation/navigation_plugin.dart';
void main() {
  runApp(
    const MaterialApp(
    )
  );
}
class NavigationVietMap extends StatefulWidget {
  const NavigationVietMap({super.key});

  @override
  State<NavigationVietMap> createState() => _NavigationVietMapState();
}

class _NavigationVietMapState extends State<NavigationVietMap> {
  late MapOptions options;
  final vietmapNavigationPlugin = VietmapNavigationPlugin();
  MapNavigationViewController? _controller;


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
