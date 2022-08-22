import 'package:customers/models/delivery_history.dart';
import 'package:customers/models/nearShops.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:shared_preferences/shared_preferences.dart';

class OrdersProvider extends ChangeNotifier {
  List<DeliveryHistory> _doingorderList = [];
  List<DeliveryHistory> get doingorderList => _doingorderList;

  List<DeliveryHistory> _completeOrderList = [];
  List<DeliveryHistory> get completeOrderList => _completeOrderList;

  List<DeliveryHistory> _ordersList = [];
  List<DeliveryHistory> get ordersList => _ordersList;

  DeliveryHistory _orderDetails;
  DeliveryHistory get orderDetails => _orderDetails;

  int _oStateId;
  int get oStateId => _oStateId;

  bool _loading = false;
  bool get loading => _loading;

  bool _loading1 = false;
  bool get loading1 => _loading1;

  String nextDoing;
  String nextComplete;

  Future getOrders() async {
    try {
      _loading1 = true;
      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      final userId = pref.getString('userId');
      var response = await Dio().get(
          APIKeys.BASE_URL + 'DeliveryHistorey/$userId&state=1 , 2 , 3 , 4');

      var data = response.data['data'];
      nextDoing = response.data['next_page_url'];
      var response1 = await Dio()
          .get(APIKeys.BASE_URL + 'DeliveryHistorey/$userId&state=0 , 5 , 6');

      var data1 = response1.data['data'];
      nextComplete = response1.data['next_page_url'];
      var shops = data + data1 as List;

      _ordersList = shops
          .map<DeliveryHistory>((json) => DeliveryHistory.fromJson(json))
          .toList();
      if (_doingorderList != null) _doingorderList.clear();
      if (_completeOrderList != null) _completeOrderList.clear();
      _ordersList.forEach((element) {
        if (element.state != '5' &&
            element.state != '0' &&
            element.state != '6') {
          doingorderList.add(element);
        } else if (element.state == '5' || element.state == '6') {
          completeOrderList.add(element);
        }
      });
      _loading1 = false;
      notifyListeners();
    } on DioError catch (error) {
      _loading1 = false;
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
      throw error;
    }
    _loading1 = false;
    notifyListeners();
  }

  Future loadMoreDonig() async {
    try {
      if (nextDoing != null) {
        _loading = true;
        notifyListeners();
        var response = await Dio().get(nextDoing);
        var data = response.data['data'];
        nextDoing = response.data['next_page_url'];
        var orders = data as List;
        var ordersList = orders
            .map<DeliveryHistory>((json) => DeliveryHistory.fromJson(json))
            .toList();
        _doingorderList += ordersList;
        _loading = false;
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
    } catch (e) {
      throw e;
    }
  }

  Future loadMoreComplete() async {
    try {
      if (nextComplete != null) {
        _loading = true;
        notifyListeners();
        var response = await Dio().get(nextDoing);
        var data = response.data['data'];
        nextComplete = response.data['next_page_url'];
        var orders = data as List;
        var ordersList = orders
            .map<DeliveryHistory>((json) => DeliveryHistory.fromJson(json))
            .toList();
        _completeOrderList += ordersList;
        _loading = false;
        notifyListeners();
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
    } catch (e) {
      _loading = false;
      notifyListeners();
      throw e;
    }
  }

  void acceptOrder(offerId) async {
    try {
      var response = await Dio().get(
          APIKeys.BASE_URL + 'acceptDilveryDriversOffers/offerId&$offerId');

      var data = response.data;
      var shops = data['data'];

      final offers =
          Offers.fromJson((shops)); //Offers.fromJson(shops).toList();
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

  void _getOrderDetails({String deliveryId}) async {
    try {
      var response = await Dio()
          .get(APIKeys.BASE_URL + 'DeliveryInfo/deliveryId&$deliveryId');
      var data = response.data;
      _orderDetails = DeliveryHistory.fromJson(data);
      _oStateId = int.parse(_orderDetails.state);
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
