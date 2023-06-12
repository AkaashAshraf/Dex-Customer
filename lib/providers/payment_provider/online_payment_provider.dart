import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class OnlinePaymentProvider extends ChangeNotifier {
  bool _webViewLoaded = false;
  bool get finished => _webViewLoaded;

  void webViewSucceed() {
    _webViewLoaded = true;
    notifyListeners();
  }

  void webStarted() {
    _webViewLoaded = false;
    notifyListeners();
  }
  // Future<String> closePayment ()async{

  // final res = await  dioClient
  //      .post(
  //      'http://mishwar.thiqatech.com/api/v1/payment/verify_payment')

  // }

}
