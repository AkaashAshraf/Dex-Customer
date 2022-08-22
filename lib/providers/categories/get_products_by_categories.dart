import 'dart:developer';

import 'package:customers/models/categories/categories.dart';
import 'package:customers/models/product.dart';
import 'package:customers/providers/services/fav_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show BuildContext, ChangeNotifier;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoyProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _children = [];
  List<Product> get children => _children;

  List<Product> _productList = [];
  List<Product> get productsList => _productList;

  String _nextPage;
  String get nextPage => _nextPage;

  String _nextProducts;
  String get nextProducts => _nextProducts;

  bool _isLoadingNextPage = false;
  bool get isLoadingNextPage => _isLoadingNextPage;

  bool _loading = false;
  bool get loading => _loading;

  List<List<Product>> _filteredProducts = [];
  List<List<Product>> get filteredProducts => _filteredProducts;

  Future getProducts(var category, int regionId) async {
    try {
      _loading = true;

      notifyListeners();
      log(APIKeys.BASE_URL +
          'getProducts/shopId=all&catId&$category&OrderBy_vield=id&regionId=$regionId');
      var response = await Dio().get(APIKeys.BASE_URL +
          'getProducts/shopId=all&catId&$category&OrderBy_vield=id&regionId=$regionId');

      var data = response.data['data'];
      var products = data as List;
      var productList =
          products.map<Product>((json) => Product.fromJson(json)).toList();
      _productList.clear();
      productList.forEach((v) => v.parent == 0 ? _productList.add(v) : null);
      _nextProducts = response.data['next_page_url'];
      _loading = false;
      notifyListeners();
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
  }

  void getProductsByCategories(
      {String productName, int orderBy, BuildContext context}) async {
    try {
      _loading = true;
      notifyListeners();
      var prefs = await SharedPreferences.getInstance();
      final regionId = prefs.getInt('regionId');
      var myfield = orderBy == 1
          ? 'created_at'
          : orderBy == 2
              ? 'rate'
              : orderBy == 3
                  ? 'price'
                  : '';
      var ascOrdesc = orderBy == 3 ? 'asc' : 'desc';
      Response response = await Dio().get(APIKeys.BASE_URL +
          'getProducts/keywords=$productName/orderBy=$myfield&ascOrdesc=$ascOrdesc&regionId=$regionId');
      var data = response.data['data'];
      _nextPage = response.data['next_page_url'];
      var products = data as List;
      _products =
          products.map<Product>((json) => Product.fromJson(json)).toList();
      await Provider.of<Favorite>(context, listen: false).getFav();
      var fav = Provider.of<Favorite>(context, listen: false).favorite;
      for (int i = 0; i < _products.length; i++) {
        for (var product in fav) {
          if (product.productinfo.length != 0) {
            if (_products[i].id == product.productinfo[0].id) {
              _products[i].fav = true;
            }
          }
        }
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
    _loading = false;
    notifyListeners();
  }

  Future<void> getProduct({var id, List sections}) async {
    try {
      _loading = true;
      notifyListeners();
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getProduct/ProdcutId&$id');
      var data = response.data;
      var list = data as List;
      _children = list.map<Product>((json) => Product.fromJson(json)).toList();
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
      _loading = false;
      notifyListeners();
      throw error;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> getProductChildren({var id, List<dynamic> section}) async {
    try {
      _loading = true;
      notifyListeners();
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getProduct/ProdcutId&$id');
          // log('product detail URL: ' + APIKeys.BASE_URL + 'getProduct/ProdcutId&$id');
      var data = response.data['Data'][0]['childProducts'];
      if (data == null) {
        data = [];
      }

      // log('product_detail error: '+data.toString());
      // log('product_detail error: '+APIKeys.BASE_URL + 'getProduct/ProdcutId&$id');
      var list = data as List;
      _children = list.map<Product>((json) => Product.fromJson(json)).toList();
      filterSections(list: _children, sections: section);
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
    } 
    catch (error) {
      _loading = false;
      notifyListeners();
      throw error;
    }
    _loading = false;
    notifyListeners();
  }

  void filterSections({List<Product> list, List<dynamic> sections}) {
    if (sections == null) {
      sections = [];
    }
    List<Product> _list = [];
    _filteredProducts = [];
    for (int i = 0; i < sections.length; i++) {
      _list = [];
      for (Product p in list) {
        if (p.section == sections[i]) {
          _list.add(p);
        }
      }
      _filteredProducts.add(_list);
    }
    notifyListeners();
  }

  void getMoreProducts() async {
    if (_nextPage != null) {
      _isLoadingNextPage = true;
      notifyListeners();
      var response = await Dio().get(_nextPage);
      var data = response.data['data'];
      _nextPage = response.data['next_page_url'];
      var newestProducts = data as List;
      var _productsList = newestProducts
          .map<Product>((json) => Product.fromJson(json))
          .toList();
      _products = _products + _productsList;
      _isLoadingNextPage = false;
      notifyListeners();
    }
  }
}
