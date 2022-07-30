import 'package:customers/models/chat/delivery_chat_list_item.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends ChangeNotifier {
  List<DeliveryChatListItem> _deliveryChatListItem;
  List<DeliveryChatListItem> get deliveryChatListItem => _deliveryChatListItem;

  String _nextPageUrl = '';
  String get nextPageUrl => _nextPageUrl;

  bool _loading = false;
  bool get loading => _loading;

  bool _loading1 = false;
  bool get loading1 => _loading1;

  void fecthMoreThredas() async {
    try {
      if (_nextPageUrl != null) {
        _loading1 = true;
        notifyListeners();
        var response = await Dio().get(_nextPageUrl);
        var data = response.data['data'] as List;
        var chats = data
            .map<DeliveryChatListItem>(
                (json) => DeliveryChatListItem.fromJson(json))
            .toList();
        _deliveryChatListItem += chats;
        _loading1 = false;
        notifyListeners();
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

  void fetchDeliveryChats() async {
    try {
      _loading = true;
      notifyListeners();
      var pref = await SharedPreferences.getInstance();
      var userId = pref.getString('user_id');
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getchatmessages&target=$userId');

      var data = response.data['data'];
      _nextPageUrl = response.data['next_page_url'];
      var categories = data as List;

      _deliveryChatListItem = categories
          .map<DeliveryChatListItem>(
              (json) => DeliveryChatListItem.fromJson(json))
          .toList();
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
    notifyListeners();
  }
}
