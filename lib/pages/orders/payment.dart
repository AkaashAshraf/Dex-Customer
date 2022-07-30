/*
 *    ozozoz   ozozoz
 *    oz  oz      oz
 *    oz  oz     oz
 *    oz  oz    oz  
 *    ozozoz   ozozoz
 *
 * Created on Mon Jun 29 2020   
 *
 * Copyright (c) 2020 Osman Solomon
 */

import 'package:customers/app.dart';
import 'package:customers/models/notifications.dart';
import 'package:customers/models/payment.dart';
import 'package:customers/models/tranz.dart';
import 'package:customers/models/user.dart';
import 'package:customers/pages/orders/stcMethod.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class PaymentMethod extends StatefulWidget {
  final int from;
  PaymentMethod(this.from);
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  List<Notifications> notifications;
  var loading = false;
  var amount = TextEditingController();
  bool waitting = false;

  Future getList() async {
    try {
      setState(() {
        loading = true;
      });
      var pref = await SharedPreferences.getInstance();
      var id = pref.getString('userId');
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getTransactions/CustomerId&$id');
      print('RESPONSE ${response.data}');
      if (response.data != null) {
        tranzList = response.data
            .map<TranzList>((json) => TranzList.fromJson(json))
            .toList();
        if (tranzList.isNotEmpty) {
          tranzList.forEach((element) {
            if (element.state == 'waiting') {
              waitting = true;
            }
          });
          setState(() {
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      }
    } on DioError catch (error) {
      await Fluttertoast.showToast(
          msg: 'tryAgain'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loading = false;
      });
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          rethrow;
          break;
        default:
          rethrow;
      }
    } catch (error) {
      await Fluttertoast.showToast(
          msg: 'tryAgain'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  charge(amount) async {
    if (amount != '') {
      try {
        // pr.show();
        setState(() {
          loading = true;
        });
        FormData data = FormData.fromMap({
          'customerId': user.id,
          'amount': amount,
          'note': 'رصيد مندوب',
          'cartItemName': 'شحن رصيد',
          'merchantTransactionId': '123',
          'customerPhone': user.loginPhone,
          'merchantPhone': user.loginPhone,
          'customerGivenName': user.firstName
        });

        var response =
            await Dio().post(APIKeys.BASE_URL + 'startPayment', data: data);
        print('RESPONSE ${response.data['Data']}');
        if (response.data != null) {
          // pr.hide();
          loading = false;
          setState(() {
            //8968879
          });
          paymentInformation =
              PaymentInformation.fromJson(response.data['Data']);
          if (response.data['State'] == "sucess") {
            // await Navigator.push(
            // context,
            // MaterialPageRoute(
            //     builder: (context) => PaymentView(
            //           amount: amount,
            //         )));
            // Navigator.pushReplacement(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (c, a1, a2) => PaymentView(amount: amount,),
            //     transitionsBuilder: (c, anim, a2, child) =>
            //         FadeTransition(opacity: anim, child: child),
            //     transitionDuration: Duration(milliseconds: 1),
            //   ),
            // );
          } else {
            await Fluttertoast.showToast(
                msg: 'tryAgain'.tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                //timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          await pr.hide();

          await Fluttertoast.showToast(
              msg: 'tryAgain'.tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              //timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }

        setState(() {
          loading = false;
        });
      } on DioError catch (error) {
        await pr.hide();

        await Fluttertoast.showToast(
            msg: 'tryAgain'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        setState(() {
          loading = false;
        });
        switch (error.type) {
          case DioErrorType.connectTimeout:
          case DioErrorType.sendTimeout:
          case DioErrorType.cancel:
            rethrow;
            break;
          default:
            rethrow;
        }
      } catch (error) {
        rethrow;
      }
    }
    {
      await Fluttertoast.showToast(
          msg: 'addAmount'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    super.initState();
    loading = false;
    getList();
  }

  ProgressDialog pr;

  String visa = "VISA";
  String mastercard = 'Mastercard';
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);
    pr.style(
        message: 'loading...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      backgroundColor: Colors.white,
      body: ConnectivityWidgetWrapper(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),

              /////////// Header
              SizedBox(
                height: 40,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: context.locale.toString() != 'en'
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back,
                            color: Colors.black, size: 25),
                      ),
                      SizedBoxResponsive(width: 10),
                      Text(
                        'chargeCredit'.tr(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 40,
              ),
              loading
                  ? Center(child: Load(200.0))
                  : Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'credit'.tr(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  user != null
                                      ? user.credit?.toString() ?? ' 0 '
                                      : ' 0 ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  'OMR'.tr(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                            child: Icon(
                          Icons.monetization_on,
                          color: Theme.of(context).primaryColor,
                          size: 46,
                        )),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                            child: Text(
                          'amount2'.tr(),
                          style:
                              TextStyle(color: Color(0xff111111), fontSize: 16),
                        )),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                            margin:
                                EdgeInsets.only(right: 17, left: 20, top: 5),
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xffF8F8F8),
                            ),
                            child: TextField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'pleaseInsertAmountInOMR'.tr(),
                                hintStyle: TextStyle(fontSize: 12),
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff111111),
                              ),
                            )),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // ConnectivityWidgetWrapper(
                              //   stacked: false,
                              //   offlineWidget: FlatButton(
                              //       onPressed: () {},
                              //       color: Colors.grey,
                              //       child: Text('في إنتظار الإنترنت',
                              //           style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 16))),
                              //   child: FlatButton(
                              //     color: ColorConstants.primaryColor,
                              //     onPressed: () {
                              //       if (amount.text != null &&
                              //           amount.text != '0') {
                              //         charge(amount.text);
                              //       } else {
                              //         Fluttertoast.showToast(
                              //             msg: 'أدخل مبلغ',
                              //             toastLength: Toast.LENGTH_SHORT,
                              //             gravity: ToastGravity.BOTTOM,
                              //             //timeInSecForIos: 1,
                              //             backgroundColor: Colors.red,
                              //             textColor: Colors.white,
                              //             fontSize: 16.0);
                              //       }
                              //     },
                              //     child: Center(
                              //         child: Text(
                              //       ' بطاقة مدى',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(
                              //           color: Colors.white, fontSize: 16),
                              //     )),
                              //   ),
                              // ),
                              // SizedBox(width: 20),
                              ConnectivityWidgetWrapper(
                                stacked: false,
                                offlineWidget: FlatButton(
                                    onPressed: () {},
                                    color: Colors.grey,
                                    child: Text('waiting_for_network'.tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16))),
                                child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    if (amount.text != null &&
                                        amount.text != '0' &&
                                        amount.text != '') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Stc(
                                                    amount.text,
                                                  )));
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'addAmount'.tr(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          //timeInSecForIos: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Center(
                                      child: Text(
                                    'online'.tr(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            waitting ? 'uncomplete_process'.tr() : '',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Center(
                        //   child: Text(
                        //     "and".tr()+"Madda".tr() +
                        //         " Mastercard  "+"and".tr()+ "Visa" +
                        //         'soonWillAddChargeWith'.tr(),
                        //     style:
                        //         TextStyle(color: Colors.black, fontSize: 13),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        // SizedBox(height: 20),
                        // Center(
                        //     child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       ' Visa ',
                        //       style: TextStyle(
                        //           color: primaryColor,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //     Text(
                        //       ' أو ',
                        //       style: TextStyle(
                        //           color: Color(0xff111111), fontSize: 16),
                        //     ),
                        //     Text(
                        //       ' Mastercard ',
                        //       style: TextStyle(
                        //           color: primaryColor,
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ],
                        // )
                        // ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
