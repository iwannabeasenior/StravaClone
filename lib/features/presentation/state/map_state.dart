import 'package:flutter/material.dart';

class MapState with ChangeNotifier {

  bool exchange = false;
  bool start = false;
  double dis = 0.00;
  void changeStart() {
    start = true;
    notifyListeners();
  }
  void changeExchange() {
    exchange = !exchange;
    notifyListeners();
  }
  void calculateDistance(double newDistance) {
    dis += newDistance;
    notifyListeners();
  }
}