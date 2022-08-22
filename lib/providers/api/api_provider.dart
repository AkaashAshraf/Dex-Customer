import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
enum HTTP_METHOD{post,get}
class ApiProvider extends ChangeNotifier {
  bool _loading = false;
  bool _success = false;
  bool _failed = false;

  dynamic _result ;

  get response => _result;
 bool get loading => _loading;

  Dio _dio = Dio();

  void request({String url,HTTP_METHOD method}) async {
    requestLoading();
    try {
      var res;
      switch(method){
        case HTTP_METHOD.get:
            res = await _dio.get(url);
          break;
        case HTTP_METHOD.post:
           res = await _dio.post(url);
          break;
      }
      requestSucceed(res);
    } catch (e) {
      requestFailed();
      print('api caaaaaaaaaaaaaaaaall err:\n$e');
    }
  }

  void requestLoading() {
    _loading = true;
    _result = null;
    notifyListeners();
  }

  void requestSucceed(dynamic result) {
    _loading = false;
    _success = true;
    _result = result;
    notifyListeners();
  }

  void requestFailed() {
    _loading = false;
    _failed = true;
    notifyListeners();
  }
}
