import 'dart:developer';

import 'package:customers/models/shops.dart';
import 'package:customers/models/tag.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class ShopsProvider extends ChangeNotifier {
  List<Shop> _shops = [];
  List<Shop> get shops => _shops;

  List<Shop> _shopsByRegion = [];
  List<Shop> get shopsByRegion => _shopsByRegion;

  List<Shop> _resByRegion = [];
  List<Shop> get resByRegion => _resByRegion;

  List<Shop> _homeList = [];
  List<Shop> get homeList => _homeList;

  List<Tag> _tags = [];
  List<Tag> get tags => _tags;

  String _nextShopsByRegion;
  String get nextShopsByRegion => _nextShopsByRegion;

  String _nextResByRegion;
  String get nextResByRegion => _nextResByRegion;

  bool _loading = false;
  bool get loading => _loading;

  bool _loading2 = false;
  bool get loading2 => _loading2;

  int _load = 0;
  int get load => _load;

  int _region;
  int get region => _region;

  String id;

  //http://www.dexoman.com/api/getStores/Lat1=0&Lon1=0&OrderBy=id&regionId=1
  //http://www.dexoman.com/api/getSRestaurants/Lat1=0&Lon1=0&OrderBy=id&regionId=1&customerID=1&filterBy=all

  void getAllShops({int regionId}) async {
    try {
      _loading = true;
      notifyListeners();
      var response = await Dio().get(APIKeys.BASE_URL +
          'getShops/Lat1=0&Lon1=0&OrderBy=id&regionId=$regionId');
      var data = response.data['data'];
      _nextShopsByRegion = response.data['next_page_url'];

      var response1 = await Dio().get(_nextShopsByRegion);
      var data1 = response1.data['data'];
      _nextShopsByRegion = response1.data['next_page_url'];

      var parsedList = (data + data1) as List;
      _shops = parsedList.map<Shop>((json) => Shop.fromJson(json)).toList();
      _loading = false;
      notifyListeners();
    } on DioError catch (error) {
      _loading = false;
      notifyListeners();
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  Future getResByRegion({int regionId, bool alone}) async {
    try {
      log('GET SHOP START');
      if (alone != true) {
        _loading = true;
      }
      var pref = await SharedPreferences.getInstance();
      var lat = pref.getDouble('lat');
      var long = pref.getDouble('long');
      await initRegion();
      notifyListeners();
      _region += 3;
      log(APIKeys.BASE_URL +
          'getSRestaurants/Lat1=$lat&Lon1=$long&OrderBy=id&regionId=$_region&customerID=$id&filterBy=all');
      var response = await Dio().get(APIKeys.BASE_URL +
          'getSRestaurants/Lat1=$lat&Lon1=$long&OrderBy=id&regionId=$_region&customerID=$id&filterBy=all');
      var data = response.data['data'];
      var shops = data as List;
      _nextResByRegion = response.data['next_page_url'];
      _resByRegion = shops.map<Shop>((json) => Shop.fromJson(json)).toList();
      _loading = false;
      _load++;
      if (alone != null) {
        _load++;
      }
      notifyListeners();
    } on DioError catch (error) {
      _loading = false;
      _load++;
      if (alone != null) {
        _load++;
      }
      notifyListeners();
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      _loading = false;
      _load++;
      if (alone != null) {
        _load++;
      }
      notifyListeners();
      throw error;
    }
    notifyListeners();
  }

  Future getShopsByRegion({int regionId, bool alone}) async {
    try {
      print('GET SHOP START');
      if (alone != true) {
        _loading = true;
      }
      var pref = await SharedPreferences.getInstance();
      var lat = pref.getDouble('lat');
      var long = pref.getDouble('long');
      await initRegion();
      notifyListeners();
      _region += 3;
      var response = await Dio().get(APIKeys.BASE_URL +
          'getStores/Lat1=$lat&Lon1=$long&OrderBy=id&regionId=$region');
      var data = response.data['data'];
      var shops = data as List;
      _nextShopsByRegion = response.data['next_page_url'];
      _shopsByRegion = shops.map<Shop>((json) => Shop.fromJson(json)).toList();
      _loading = false;
      _load++;
      if (alone != null) {
        _load++;
      }
      notifyListeners();
    } on DioError catch (error) {
      _loading = false;
      _load++;
      if (alone != null) {
        _load++;
      }
      notifyListeners();
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      _loading = false;
      _load++;
      if (alone != null) {
        _load++;
      }
      notifyListeners();
      throw error;
    }
    notifyListeners();
  }

  Future<void> getTags({String type}) async {
    try {
      var response = await Dio().get(APIKeys.BASE_URL + 'getTags&type=$type');
      var data = response.data;
      var tags = data as List;
      _tags = tags.map((json) => Tag.fromJson(json)).toList();
      _tags.insert(0, Tag(name: 'all', nameAR: 'الكل'));
      _load++;
      notifyListeners();
    } on DioError catch (error) {
      notifyListeners();
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  void startLoad() {
    _load = 0;
    notifyListeners();
  }

  Future<void> getMoreResByRegion({bool allshops}) async {
    try {
      if (_nextResByRegion != null) {
        _loading2 = true;
        notifyListeners();
        var response = await Dio().get(_nextResByRegion);
        var data = response.data['data'];
        var shops = data as List;
        var newestShops =
            shops.map<Shop>((json) => Shop.fromJson(json)).toList();
        if (allshops == false) {
          _resByRegion += newestShops;
        } else {
          _shops += newestShops;
        }
        _nextShopsByRegion = response.data['next_page_url'];
        _loading2 = false;
        notifyListeners();
      } else {}
    } on DioError catch (error) {
      _loading2 = false;
      notifyListeners();
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getMoreShopsByRegion({bool allshops}) async {
    try {
      if (_nextShopsByRegion != null) {
        _loading2 = true;
        notifyListeners();
        var response = await Dio().get(_nextShopsByRegion);
        var data = response.data['data'];
        var shops = data as List;
        var newestShops =
            shops.map<Shop>((json) => Shop.fromJson(json)).toList();
        if (allshops == false) {
          _shopsByRegion += newestShops;
        } else {
          _shops += newestShops;
        }
        _nextShopsByRegion = response.data['next_page_url'];
        _loading2 = false;
        notifyListeners();
      } else {}
    } on DioError catch (error) {
      _loading2 = false;
      notifyListeners();
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<Shop> getShopDetails({String shopId}) async {
    try {
      _loading = true;
      notifyListeners();
      var response = await Dio().post(APIKeys.BASE_URL + 'getShopInfoByShopId',
          data: FormData.fromMap({
            'shopId': shopId,
          }));
      var data = response.data['Data'];
      _loading = false;
      notifyListeners();
      return Shop.fromJson(data);
    } on DioError catch (error) {
      _loading = false;
      notifyListeners();
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      _loading = false;
      notifyListeners();
      throw error;
    }
  }

  initRegion() async {
    var pref = await SharedPreferences.getInstance();
    _region = pref.getInt('regionId') != null ? pref.getInt('regionId') : 0;
    id = pref.getString('user_id') ?? '1';
    notifyListeners();
    return _region;
  }

  void reducdeRegion() {
    _region = _region - 3;
  }
}
