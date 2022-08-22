import 'package:customers/models/product.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class SearchProductProvider extends ChangeNotifier {
  final String keywords;
  SearchProductProvider({this.keywords});

  List<Product> _searchProduct;
  List<Product> get searchProduct => _searchProduct;

  Future searchProductByKeyword(String keywords) async {
    if (keywords == null || keywords.isEmpty) return;

    try {
      print('GET PRODUCTS START');
      Response response =
          await Dio().get(APIKeys.BASE_URL + 'getProducts/keywords&$keywords');

      final parasedList = response.data as List;
      _searchProduct =
          parasedList.map<Product>((json) => Product.fromJson(json)).toList();
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
}
