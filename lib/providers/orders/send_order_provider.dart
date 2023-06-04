import 'dart:developer';

import 'package:customers/models/delivery_history.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier, BuildContext;
import 'package:shared_preferences/shared_preferences.dart';

class OrderCRUDProvider extends ChangeNotifier {
  bool _isSuccessful;
  bool get isSuccessful => _isSuccessful;
  List<DeliveryHistory> _orderList;
  List<DeliveryHistory> get orderList => _orderList;
  bool _loading = false;
  bool get loading => _loading;
  double _deliveryPrice = 0;
  double get price => _deliveryPrice;
  bool _isUpdateStatusSuccess;
  bool get isUpdateStatusSuccess => _isUpdateStatusSuccess;

  Future<dynamic> sendOrder(
      {var lat,
      var long,
      var customerId,
      var note,
      var shopId,
      var quantity,
      var notes,
      var orderProductList,
      var address,
      var ref,
      var number,
      var name,
      var isGuest,
      var amount,
      var userId,
      String time,
      String payMethod,
      BuildContext context}) async {
    try {
      log('amount : $amount, userId: $userId');
      _loading = true;

      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      final body = FormData.fromMap({
        'time': time,
        'end_latitude': lat,
        'end_longitude': long,
        'customer': pref.getString('userId'),
        'note': note,
        'customerName': name,
        'customerNumber': number,
        'isGuest': isGuest,
        'shop': shopId,
        'Qun': quantity.toString(),
        'OrderProductIdslist': orderProductList.toString(),
        'address': address,
        'city': 3,
        'paymentMethod': payMethod,
        'referral_id': ref.toString(),
        'productNote': notes.toString(),
        'amount': amount.toString(),
        'user_id': userId,
      });
      var response =
          await Dio().post(APIKeys.BASE_URL + 'sendOrder', data: body);
      log('sned order:' + body.fields.toString());

      if (response.data['State'] == "sucess") {
        var data = response.data["Data"];
        log('-----------   ' + data.toString());
        var shops = data as List;
        _orderList = shops
            .map<DeliveryHistory>((json) => DeliveryHistory.fromJson(json))
            .toList();
        _isSuccessful = true;
        _loading = false;
        notifyListeners();
      } else {
        _loading = false;
        _isSuccessful = false;
      }
      notifyListeners();
    } on DioError catch (error) {
      _loading = false;
      _isSuccessful = false;
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
      _isSuccessful = false;
      notifyListeners();
      throw error;
    }
  }

  Future<void> setPaymentStatus(String orderId, String paymentStatus) async {
    try {
      _loading = true;
      final response =
          await Dio().post(APIKeys.BASE_URL + 'update-payment-status',
              data: FormData.fromMap({
                'orderid': orderId,
                'payment_status': paymentStatus,
              }));
      if (response.data['State'] == "sucess") {
        _loading = false;
        _isUpdateStatusSuccess = true;
        notifyListeners();
      } else {
        _loading = false;
        _isUpdateStatusSuccess = false;
      }
      notifyListeners();
    } on DioError catch (error) {
      _loading = false;
      _isUpdateStatusSuccess = false;
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
      _isUpdateStatusSuccess = false;
      notifyListeners();
      throw error;
    }
  }

  Future<void> deliveryPrice(
      {var lat,
      var long,
      var customerId,
      var note,
      var shopId,
      var quantity,
      var orderProductList,
      var address,
      String time,
      String payMethod,
      String payment,
      BuildContext context}) async {
    //
    try {
      _loading = true;
      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      var _regionId = pref.getInt('regionId');
      _regionId = _regionId + 3;
      var response = await Dio().post(APIKeys.BASE_URL + 'calculateOrderPrice',
          data: FormData.fromMap({
            'time': time,
            'end_latitude': lat,
            'end_longitude': long,
            'customer': pref.getString('user_id'),
            'note': note,
            'shop': shopId,
            'Qun': quantity.toString(),
            'OrderProductIdslist': orderProductList.toString(),
            'address': address,
            'city': _regionId,
            'payment': payment,
            'paymentMethod': payMethod,
          }));
      if (response.data['State'] == "sucess") {
        var data = response.data;
        var price = data['Data']['price'];
        _deliveryPrice = price.toDouble();
        print(data);
        _loading = false;
        notifyListeners();
      }
    } on DioError catch (error) {
      _loading = false;
      _isSuccessful = false;
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
      _isSuccessful = false;
      notifyListeners();
      throw error;
    }
  }
}
