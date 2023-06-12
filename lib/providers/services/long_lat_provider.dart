import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class LongLatProvider extends ChangeNotifier {
  double _lat = 0.0;
  double get lat => _lat;

  double _long = 0.0;
  double get long => _long;

  double _lat2;
  double get lat2 => _lat2;

  double _long2;
  double get long2 => _long2;

  void setLocPref() async {
    var pref = await SharedPreferences.getInstance();
    _lat = pref.getDouble('lat');
    _long = pref.getDouble('long');
    notifyListeners();
  }

  void setLoc2({double lat, double long}) {
    _lat2 = lat;
    _long2 = long;
    notifyListeners();
  }

  void setLoc({double lat, double long}) {
    _lat = lat;
    _long = long;
    notifyListeners();
  }
}
