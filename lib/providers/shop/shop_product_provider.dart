import 'package:customers/models/product.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class ShopProductProvider extends ChangeNotifier {
  List<Product> _products;
  List<Product> get products => _products;

  // void getProducts() async {
  //   _products = List<Product>();
  //   try {
  //     var response =
  //         await Dio().get(APIKeys.BASE_URL + 'getProducts/4/newest/id');

  //     var data = response.data;
  //     var products = data as List;
  //     _products =
  //         products.map<Product>((json) => Product.fromJson(json)).toList();
  //   } on DioError catch (error) {
  //     switch (error.type) {
  //       case DioErrorType.CONNECT_TIMEOUT:
  //       case DioErrorType.SEND_TIMEOUT:
  //       case DioErrorType.CANCEL:
  //         throw error;
  //         break;
  //       default:
  //         throw error;
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  //   notifyListeners();
  // }

  // getMoreProducts() async {
  //   if (nextProducts != null) {
  //     var response = await Dio().get(nextProducts);
  //     var data = response.data['data'];
  //     nextProducts = response.data['next_page_url'];
  //     var newestProducts = data as List;
  //     var _productsList = newestProducts
  //         .map<Product>((json) => Product.fromJson(json))
  //         .toList();
  //     productsList = productsList + _productsList;
  //   }
  // }

  // void getAllProducts() async {
  //   try {
  //     var response =
  //         await dioClient.get(baseURL + 'getProductsTemplets/all/id');

  //     var data = response.data['data'];
  //     nextPage = response.data['next_page_url'];
  //     var products = data as List;
  //     newestProduct =
  //         products.map<Product>((json) => Product.fromJson(json)).toList();
  //     var newData = response.data;
  //     pagnation = newData;
  //     print(pagnation);
  //   } on DioError catch (error) {
  //     getProducts();
  //     switch (error.type) {
  //       case DioErrorType.CONNECT_TIMEOUT:
  //       case DioErrorType.SEND_TIMEOUT:
  //       case DioErrorType.CANCEL:
  //         throw error;
  //         break;
  //       default:
  //         throw error;
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
