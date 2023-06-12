import 'package:customers/models/favModel.dart';
import 'package:customers/models/product.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class Favorite extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  bool _loading2 = false;
  bool get loading2 => _loading2;

  List<FavoriteModel> _favorite = [];
  List<FavoriteModel> get favorite => _favorite;

  getFav() async {
    try {
      _loading2 = true;
      notifyListeners();
      var pref = await SharedPreferences.getInstance();
      var userId = pref.getString('userId');
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getFavProducts/userId&$userId');
      var data = response.data['Data'];
      var fav = data as List;
      // print(fav);
      _favorite =
          fav.map<FavoriteModel>((fav) => FavoriteModel.fromJson(fav)).toList();
      notifyListeners();
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
      _loading2 = false;
      notifyListeners();
      throw error;
    }
    _loading2 = false;
    notifyListeners();
  }

  addFav({Product product}) async {
    try {
      _loading = true;
      bool isInFav = false;
      for (int i = 0; i < _favorite.length; i++) {
        if (product.id == _favorite[i].proudctID) {
          isInFav = true;
          break;
        }
      }
      if (isInFav == false) {
        var pref = await SharedPreferences.getInstance();
        var userId = pref.getString('userId');
        product.fav = true;
        notifyListeners();
        var response = await Dio().get(APIKeys.BASE_URL +
            'addFavProducts/userId&${userId}productId&${product.id}');
        var data = response.data;
        await getFav();
        Fluttertoast.showToast(
            msg: "successed".tr(),
            gravity: ToastGravity.BOTTOM,
            fontSize: 15,
            // backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white);
        notifyListeners();
      } else {
        Fluttertoast.showToast(
            msg: "errorRetry".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0);
        product.fav = true;
      }
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

  deleteFav({Product product}) async {
    try {
      _loading = true;
      notifyListeners();
      var pref = await SharedPreferences.getInstance();
      var userId = pref.getString('userId');
      product.fav = false;
      notifyListeners();
      var response = await Dio().get(APIKeys.BASE_URL +
          'deleteFavProducts/userId&${userId}productId&${product.id}');
      // ignore: unused_local_variable
      var data = response.data;
      await getFav();
      Fluttertoast.showToast(
          msg: "successed".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          // backgroundColor: Theme.of(context).accentColor,
          textColor: Colors.white,
          fontSize: 15.0);
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
}
