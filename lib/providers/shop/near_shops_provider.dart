import 'dart:convert';

import 'package:customers/models/shop/near_shop.dart';
import 'package:customers/repositories/map_keys.dart';
import 'package:customers/utils/calc_distance.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class NearShopProvider extends ChangeNotifier {
  List<NearShop> _gifts;
  List<NearShop> get gifts => _gifts;

  List<NearShop> _shops;
  List<NearShop> get shops => _shops;

  List<NearShop> _restaurant;
  List<NearShop> get restaurant => _restaurant;

  List<NearShop> _cafes;
  List<NearShop> get cafes => _cafes;

  List<NearShop> _bakeries;
  List<NearShop> get bakeries => _bakeries;

  List<NearShop> _pharmacies;
  List<NearShop> get pharmacies => _pharmacies;

  List<NearShop> _superMarket;
  List<NearShop> get superMarket => _superMarket;

  List<NearShop> _finalShops;
  List<NearShop> get finalShops => _finalShops;

  void fetchDataBakeries(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(MapKeys.baseURL +
        latitude.toString() +
        ',' +
        longitude.toString() +
        '&radius=20000&type=bakery&key=${MapKeys.apiKey}'));
    if (response.statusCode == 200) {
      dynamic Json = json.decode(response.body);
      final myJson = json.encode(Json["results"]);
      _bakeries = (json.decode(myJson) as List)
          .map((data) => NearShop.fromJson(data))
          .toList();
      _shops = _bakeries;

      _shops.sort((a, b) {
        return (distMath(b.geometry.location.lng, b.geometry.location.lat,
                latitude, longitude)
            .toString()
            .compareTo(distMath(b.geometry.location.lng,
                    b.geometry.location.lat, latitude, longitude)
                .toString()));
      });
      final temp = _shops;
      _finalShops = temp.toSet().toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  void fetchDataPharmacies(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(MapKeys.baseURL +
        latitude.toString() +
        ',' +
        longitude.toString() +
        '&radius=20000&type=pharmacy&key=${MapKeys.apiKey}'));
    if (response.statusCode == 200) {
      dynamic Json = json.decode(response.body);
      final myJson = json.encode(Json["results"]);
      _pharmacies = (json.decode(myJson) as List)
          .map((data) => NearShop.fromJson(data))
          .toList();
      _shops = _pharmacies;

      _shops.sort((a, b) {
        return (distMath(b.geometry.location.lng, b.geometry.location.lat,
                latitude, longitude)
            .toString()
            .compareTo(distMath(b.geometry.location.lng,
                    b.geometry.location.lat, latitude, longitude)
                .toString()));
      });
      final temp = _shops;
      _finalShops = temp.toSet().toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  void fetchDataCafes(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(MapKeys.baseURL +
        latitude.toString() +
        ',' +
        longitude.toString() +
        '&radius=20000&type=cafe&key=${MapKeys.apiKey}'));
    if (response.statusCode == 200) {
      dynamic Json = json.decode(response.body);
      final myJson = json.encode(Json["results"]);
      _cafes = (json.decode(myJson) as List)
          .map((data) => NearShop.fromJson(data))
          .toList();
      _shops = _cafes;

      _shops.sort((a, b) {
        return (distMath(b.geometry.location.lng, b.geometry.location.lat,
                latitude, longitude)
            .toString()
            .compareTo(distMath(b.geometry.location.lng,
                    b.geometry.location.lat, latitude, longitude)
                .toString()));
      });
      final temp = _shops;
      _finalShops = temp.toSet().toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  void fetchDataRestaurant(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(MapKeys.baseURL +
        latitude.toString() +
        ',' +
        longitude.toString() +
        '&radius=20000&type=restaurant&key=${MapKeys.apiKey}'));
    if (response.statusCode == 200) {
      dynamic Json = json.decode(response.body);
      final myJson = json.encode(Json["results"]);
      _restaurant = (json.decode(myJson) as List)
          .map((data) => NearShop.fromJson(data))
          .toList();
      _shops = _restaurant;

      _shops.sort((a, b) {
        return (distMath(b.geometry.location.lng, b.geometry.location.lat,
                latitude, longitude)
            .toString()
            .compareTo(distMath(b.geometry.location.lng,
                    b.geometry.location.lat, latitude, longitude)
                .toString()));
      });
      final temp = _shops;
      _finalShops = temp.toSet().toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  void fetchSupermarket(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(MapKeys.baseURL +
        latitude.toString() +
        ',' +
        longitude.toString() +
        '&radius=20000&type=supermarket&key=${MapKeys.apiKey}'));
    if (response.statusCode == 200) {
      dynamic Json = json.decode(response.body);
      final myJson = json.encode(Json["results"]);
      _superMarket = (json.decode(myJson) as List)
          .map((data) => NearShop.fromJson(data))
          .toList();
      _shops = _superMarket;

      _shops.sort((a, b) {
        return (distMath(b.geometry.location.lng, b.geometry.location.lat,
                latitude, longitude)
            .toString()
            .compareTo(distMath(b.geometry.location.lng,
                    b.geometry.location.lat, latitude, longitude)
                .toString()));
      });
      final temp = _shops;
      _finalShops = temp.toSet().toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  LocationData _myLocation;
  LocationData get myLocation => _myLocation;

  void getLocation() async {
    var locationService = Location();

    try {
      _myLocation = await locationService.getLocation();

      fetchDataRestaurant(_myLocation.latitude, _myLocation.longitude);
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
      }
    }
    notifyListeners();
  }

  void clearLists() {
    _finalShops = null;
    if (_gifts != null) _gifts.clear();
    if (_shops != null) _shops.clear();
    if (_restaurant != null) _restaurant.clear();
    if (_cafes != null) _cafes.clear();
    if (_bakeries != null) _bakeries.clear();
    if (_pharmacies != null) _pharmacies.clear();
    if (_superMarket != null) _superMarket.clear();
    notifyListeners();
  }

  List<NearShop> _shopSearched;
  List<NearShop> get shopSearched => _shopSearched;
  String _shopName;
  String _city;

  void lastShopName({String shopName}) {
    _shopName = shopName;
  }

  void lastCity({String city}) {
    _city = city;
  }

  void fetchSearchHistory() async {
    _finalShops = null;
    notifyListeners();

    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=' +
            _shopName +
            '+' +
            _city +
            '&key=${MapKeys.apiKey}'));
    if (response.statusCode == 200) {
      dynamic Json = json.decode(response.body);
      final myJson = json.encode(Json["results"]);
      _finalShops = (json.decode(myJson) as List)
          .map((data) => NearShop.fromJson(data))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  void isSearching() {
    notifyListeners();
  }
}
