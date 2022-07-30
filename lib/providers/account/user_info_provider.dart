import 'package:customers/models/user.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider extends ChangeNotifier {
  User _user;
  User get user => _user;

  String _isLoggedIn;
  String get isLoggedIn => _isLoggedIn;

  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  bool _loading = false;
  bool get loading => _loading;

  Future getUserInfo() async {
    _loading = true;
    notifyListeners();
    await checkIsLoggedIn();
    try {
      if (_isLoggedIn != null) {
        _prefs = await SharedPreferences.getInstance();
        var userPhone = prefs.get('user_phone');

        var response =
            await Dio().get(APIKeys.BASE_URL + 'getUserinfo/$userPhone');

        var data = response.data;
        _user = User.fromJson(data);
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

  void updateUser(var data) {
    _user = data;
    notifyListeners();
  }

  Future<void> checkIsLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _isLoggedIn = pref.getString('IS_LOGIN');
  }
}
