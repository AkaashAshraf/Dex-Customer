import 'package:customers/models/categories/categories.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class CategoriesProvider extends ChangeNotifier {
  List<Category> _categories;
  List<Category> get categories => _categories;

  List<Category> _searchCategories;
  List<Category> get searchCategories => _searchCategories;

  bool _searching = false;
  bool get searching => _searching;

  List<Category> sections = [
    Category(
        image: 'images/restaurants.jpg', name: 'Restaurants', slug: "المطاعم"),
    Category(image: 'images/stores.jpg', name: 'Stores', slug: "أسواق"),
    Category(image: 'images/logistics.jpg', name: 'Logistics', slug: "لوجستيات")
  ];

  Future fetchCategory() async {
    try {
      var response = await Dio().get(APIKeys.BASE_URL + 'getCategories');

      var data = response.data;
      var categories = data as List;

      _categories =
          categories.map<Category>((json) => Category.fromJson(json)).toList();
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

  void searchingCat(String value) {
    _searching = true;
    _searchCategories = _categories;
    List<Category> list = _searchCategories
        .where((i) => i.name.toString().contains(value))
        .toList();
    _searchCategories = list;
    notifyListeners();
  }

  void notSearchingCat() {
    _searching = true;
    notifyListeners();
  }
}
