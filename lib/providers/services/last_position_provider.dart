import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LastPositionProvider extends ChangeNotifier {
  LatLng _lastMapPosition;
  LatLng get lastMapPosition => _lastMapPosition;

  // ignore: missing_return
  Future<void> updatePosition({LatLng updated}) {
    _lastMapPosition = updated;
    notifyListeners();
  }
}
