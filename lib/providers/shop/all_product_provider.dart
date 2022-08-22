import 'dart:developer';

import 'package:customers/models/product.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class AllProductProvider extends ChangeNotifier {
  dynamic _nextPage;
  dynamic get nextPage => _nextPage;

  bool _searching = false;
  bool get searching => _searching;

  List<Product> _allProducts = [];
  List<Product> get allProducts => _allProducts;

  List<Product> _searchList = [];
  List<Product> get searchList => _searchList;

  void fetchAllProdcucts() async {
    try {
      log('All Product: ' + APIKeys.BASE_URL + 'getProductsTemplets/all/id');
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getProductsTemplets/all/id');

      var data = response.data['data'];
      _nextPage = response.data['next_page_url'];
      var products = data as List;
      _allProducts =
          products.map<Product>((json) => Product.fromJson(json)).toList();
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

  void getMoreProducts() async {
    if (_nextPage != null) {
      var _response = await Dio().get(nextPage);
      var _data = _response.data['data'];
      var _products = _data as List;
      final moreProduts =
          _products.map<Product>((json) => Product.fromJson(json)).toList();
      _allProducts += moreProduts;
      _nextPage = _response.data['next_page_url'];
    } else {
      // do nothin for now
    }
    notifyListeners();
  }

  void maniplualteAllProducts({List<Product> allProducts}) {
    _allProducts = allProducts;
    notifyListeners();
  }

  void searchProduct({String value}) {
    _searching = true;
    _searchList = _allProducts;
    List<Product> list =
        _searchList.where((i) => i.name.toString().contains(value)).toList();
    _searchList = list;
    notifyListeners();
  }

  void notSearching() {
    _searching = false;
    notifyListeners();
  }
}
