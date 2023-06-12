import 'package:customers/models/delivery_history.dart';
import 'package:customers/providers/orders/order_providors.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/pages/orders/rate_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class RateProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  bool _rated = false;
  bool get rated => _rated;

  int _deliveryId;
  int get deliveryId => _deliveryId;

  DeliveryHistory _orderDetails;
  DeliveryHistory get orderDetails => _orderDetails;

  showRate(BuildContext context, int orderId, DeliveryHistory order) async {
    _deliveryId = orderId;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RatePage(
        orderID: orderId,
      ),
    );
  }

  void falseRate() {
    _rated = false;
    notifyListeners();
  }

  Future<void> rate({
    BuildContext context,
    int delivery,
    String comment,
    double product,
    double shop,
    double driver,
  }) async {
    try {
      _loading = true;
      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      final userId = pref.getString('userId');
      var response = await Dio().post(APIKeys.BASE_URL + 'rateOrderAndDelivery',
          data: FormData.fromMap({
            'comment': comment,
            'deliveryId': delivery,
            'prodcutRatingvalue': product,
            'shopRatingValue': shop,
            'driverRatingValue': driver,
            'customerID': userId,
          }));
      var data = response.data['Data'];
      _orderDetails = DeliveryHistory.fromJson(data);
      await Provider.of<OrdersProvider>(context, listen: false).getOrders();
      Fluttertoast.showToast(
        msg: 'rated'.tr(),
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.green,
      );
      _loading = false;
      _rated = true;
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
    } catch (e) {
      _loading = false;
      notifyListeners();
      throw e;
    }
  }
}
