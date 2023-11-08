import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UploadState with ChangeNotifier {
  bool _isUploaded = false;

  bool get isUploaded => _isUploaded;

  void setUploadStatus(bool status) {
    _isUploaded = status;
    notifyListeners();
  }
}

class MarkerState extends ChangeNotifier {
  List<Marker> _markers = [];

  List<Marker> get markers => _markers;

  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }
}