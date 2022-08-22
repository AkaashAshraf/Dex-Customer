import 'package:customers/models/cities.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class CityProvider extends ChangeNotifier {
  List<City> _cities = [];
  List<City> get cities => _cities;

  List<PopupMenuEntry<int>> _citiesPopMenuList;
  List<PopupMenuEntry<int>> get citiesPopMenuList => _citiesPopMenuList;

  int _selectedCity;
  int get selectedCity => _selectedCity;

  int _city1 = 0;
  int get city1 => _city1;

  int _city2 = 0;
  int get city2 => _city2;

  String _city1name = '';
  String get city1name => _city1name;

  String _city2name = '';
  String get city2name => _city2name;

  String _selectedDate = '';
  String get selectedDate => _selectedDate;

  bool _datePicked = false;
  bool get datePicked => _datePicked;

  void updateSelectedCity({int newCity}) async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt('regionId', newCity);
    _selectedCity = newCity;
    notifyListeners();
  }

  void pickDate({BuildContext context}) async {
    var _date = await showDatePicker(
      context: context,
      initialDate: DateTime(1999),
      firstDate: DateTime(1999),
      lastDate: DateTime(2050),
    );
    _selectedDate = "${_date.year}/${_date.month}/${_date.day}";
    _datePicked = true;
    notifyListeners();
  }

  void selectCity1(int value) {
    for (int i = 0; i < cities.length; i++) {
      if (value == cities[i].id) {
        _city1 = cities[i].id;
        _city1name = cities[i].name;
        break;
      }
    }
    notifyListeners();
  }

  void selectCity2(int value) {
    for (int i = 0; i < cities.length; i++) {
      if (value == cities[i].id) {
        _city2 = cities[i].id;
        _city2name = cities[i].name;
        break;
      }
    }
    notifyListeners();
  }

  Future fetchCities(BuildContext context) async {
    try {
      var response = await Dio().get(APIKeys.BASE_URL + 'getCities');

      var data = response.data;
      var city = data as List;

      _cities = city.map<City>((json) => City.fromJson(json)).toList();

      _citiesPopMenuList = List<PopupMenuEntry<int>>();

      for (int i = 0; i < cities.length; i++) {
        _citiesPopMenuList.add(
          PopupMenuItem(
            height: 50,
            value: i,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(1)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  context.locale == Locale('ar')
                      ? cities[i].nameAr.toString()
                      : cities[i].name.toString(),
                  style: TextStyle(color: Colors.black),
                )),
              ),
            ),
          ),
        );
      }
    } on DioError catch (error) {
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
    notifyListeners();
  }
}
