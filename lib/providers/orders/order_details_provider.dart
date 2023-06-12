import 'package:customers/models/delivery_history.dart';
import 'package:customers/models/nearShops.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsProvider extends ChangeNotifier {
  DeliveryHistory _orderDetails;
  DeliveryHistory get orderDetails => _orderDetails;

  List<Offers> _deliveryDriverOffers;
  List<Offers> get deliveryDriverOffers => _deliveryDriverOffers;

  int _oStateId;
  int get oStateId => _oStateId;

  int _stateId;
  int get stateId => _stateId;

  bool _acceptOfferCompleted;
  bool get acceptOfferCompleted => _acceptOfferCompleted;

  Future<void> getOrderDetails({String deliveryId}) async {
    try {
      var response = await Dio()
          .get(APIKeys.BASE_URL + 'DeliveryInfo/deliveryId&$deliveryId');
      var data = response.data;
      _orderDetails = DeliveryHistory.fromJson(data);
      _oStateId = int.parse(_orderDetails.state);
      _stateId = int.parse(_orderDetails.orderInfo.state);
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

  Future<void> getDilveryDriversOffers({String orderId}) async {
    try {
      var response = await Dio().get(
          APIKeys.BASE_URL + 'getDilveryDriversOffers/deliveryId&$orderId');

      var data = response.data;
      if (data['State'] == 'sucess') {
        var ordersList = response.data['Data'];

        _deliveryDriverOffers = ((ordersList) as List)
            .map((ordersList) => Offers.fromJson(ordersList))
            .toList();
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

  void acceptOrder({
    String offerId,
    String index,
  }) async {
    try {
      var response = await Dio().get(
          APIKeys.BASE_URL + 'acceptDilveryDriversOffers/offerId&$offerId');

      var data = response.data;
      if (data['State'] == 'sucess') {
        SharedPreferences pref = await SharedPreferences.getInstance();
        final userName = pref.getString('userName');
        _acceptOfferCompleted = true;
        var notiTit = "orderAccepted".tr();
        var notiBody = 'orderAcceptedFrom'.tr() + '$userName';
        var dataTit = 'changeState';
        sendNoti(offerId, dataTit, notiBody, notiTit, index);
      }
      _acceptOfferCompleted = false;
    } on DioError catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> sendNoti(dataBody, dataTit, notiBody, notiTit, index) async {
    try {
      print(
          'http://80.211.24.15/api/fire/userId&${offers[index].id}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
      var response = await Dio().get(
          '${APIKeys.Noti_URL}userId&${offers[index].driverInfo.id}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
    } catch (e) {}
  }

  void clearAcceptedOffer() {
    _acceptOfferCompleted = null;
  }
}
