import 'package:customers/models/notifications.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class NotificationProvider extends ChangeNotifier {
  List<Notifications> _notifications = [];
  List<Notifications> get notifications => _notifications;

  bool _loading = false;
  bool get loading => _loading;

  void getNotifications({var id}) async {
    try {
      _loading = true;
      notifyListeners();
      var response = await Dio().get(APIKeys.BASE_URL + 'getNotifications/$id');

      var data = response.data;
      var parsed = data as List;

      _notifications = parsed
          .map<Notifications>((json) => Notifications.fromJson(json))
          .toList();
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
    notifyListeners();
  }
}
