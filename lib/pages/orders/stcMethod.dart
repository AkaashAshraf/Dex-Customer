/*
 *    *****   ******
 *    *   *       *
 *    *   *      *
 *    *   *     *  
 *    *****    *****
 *
 * Created on Sun Jul 05 2020   
 *
 * Copyright (c) 2020 Osman Solomon
 */

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:customers/models/notifications.dart';
import 'package:customers/models/payment.dart';
import 'package:customers/models/stcInfo.dart';
import 'package:customers/models/user.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/pages/orders/account_charge.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stc extends StatefulWidget {
  final String amount;
  Stc(this.amount);
  @override
  _StcState createState() => _StcState();
}

class _StcState extends State<Stc> {
  List<Notifications> notifications;
  var loading = false;
  String _pin;

  charge(amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (amount != '') {
      try {
        // pr.show();
        setState(() {
          loading = true;
        });
        FormData data = FormData.fromMap({
          'billImage': await MultipartFile.fromFile(_recipt.path,
              filename: "profile img"),
          'customerId': user.id,
          'amount': amount,
          "currency": 'SAR',
          'cartItemName': 'شحن رصيد',
          'customerPhone': prefs.getString('userPhone'),
          'customerGivenName': prefs.getString('userName'),
          'paymentCause': 'شحن رصيد',
          'withdrawtype': 'sctPay',
          'withdrawId': stcContorller.text
        });

        var response = await Dio()
            .post(APIKeys.BASE_URL + 'chargecredit_Manual', data: data);
        print('RESPONSE ${response.data}');
        if (response.data != null) {
          // await pr.hide();
          loading = false;
          setState(() {
            //8968879
          });
          paymentInformation =
              PaymentInformation.fromJson(response.data['Data']);
          if (paymentInformation.state != null) {
            // bottomSelectedIndex=3;
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Charge(stcInfo)));
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
        setState(() {
          loading = false;
        });
        rethrow;
      }
    }
  }

  int stip = 1;
  @override
  void initState() {
    super.initState();
    _recipt = null;
    stip = 1;
    loading = false;
    // if (user.stcpay != null) {
    //   phoneIsoCode2 = user.stcpay[3] == '6' ? '966' : '966';
    // } else {
    //   phoneIsoCode2 = '966';

    //   Fluttertoast.showToast(
    //       msg: "pleaseInsertStcPayPhoneNumber".tr(),
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.redAccent,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
    // if (user.stcpay.toString() == 'Stcpay number') {
    //   stcContorller.text = '';
    // } else if (user.stcpay == null) {
    //   stcContorller.text = '';
    // } else {
    //   stcContorller.text = user.stcpay.toString().replaceRange(0, 3, '');
    // }
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
            children: <Widget>[
              SizedBox(
                height: 40,
              ),

              /////////// Header
              SizedBox(
                height: 40,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        right: context.locale.toString() != 'ar' ? 55 : null,
                        left: context.locale.toString() != 'ar' ? null : 55,
                        top: 9,
                        child: Text(
                          'chargeCredit'.tr(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w300),
                        )),
                    Positioned(
                        right: context.locale.toString() != 'ar' ? 0 : null,
                        left: context.locale.toString() != 'ar' ? null : 0,
                        top: 3,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Color(0xff575757),
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
              ),
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
                        user != null ? user.credit?.toString() ?? '0' : '0',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        " " + 'OMR'.tr(),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900),
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
              stip == 1 ? stip1(context) : stip2(context),
            ],
          ),
        ),
      ),
    );
  }

  Column stip1(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        loading
            ? Load(200.0)
            : Column(
                children: [
                  stcWidget(),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConnectivityWidgetWrapper(
                      stacked: false,
                      offlineWidget: FlatButton(
                        onPressed: () {},
                        color: Colors.grey,
                        child: Center(
                            child: Text(
                          'waitingForNetwork'.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                      ),
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if (stcContorller.text.trim().length != 8 ||
                              stcContorller.text.trim().isEmpty) {
                            await Fluttertoast.showToast(
                                msg: "pleaseInsertStcPayPhoneNumber".tr(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,

                                //timeInSecForIos: 1,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            return;
                          } else {
                            chargecreditManual();
                          }
                        },
                        child: Center(
                            child: Text(
                          'confirm'.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  // Center(
                  //   child: Text(
                  //     'أرسل المبلغ إلى حساب الشركة ثم إضغط تأكيد لإرفاق الإيصال',
                  //     style: TextStyle(color: Color(0xff111111), fontSize: 16),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   '558567146' + ': STCpay' + 'حساب أهلا وسهلا على',
                      //   style: TextStyle(
                      //       color: Theme.of(context).primaryColor,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // Text(
                      //   ' أو ',
                      //   style: TextStyle(
                      //       color: Color(0xff111111), fontSize: 16),
                      // ),
                      // Text(
                      //   ' Mastercard ',
                      //   style: TextStyle(
                      //       color: primaryColor,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  )),
                ],
              ),
      ],
    );
  }

  File _recipt;
  Column stip2(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        loading
            ? Load(200.0)
            : Column(
                children: [
                  Container(
                    child: Text(
                      'pleaseInsertCode'.tr(),
                      style: TextStyle(color: Color(0xff111111), fontSize: 15),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: ContainerResponsive(
                              width: 450,
                              height: 100,
                              child: Center(
                                  child: PinInputTextField(
                                pinLength: 5,
                                decoration: BoxLooseDecoration(
                                    strokeColorBuilder: PinListenColorBuilder(
                                        Theme.of(context).primaryColor,
                                        Colors.black),
                                    textStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(40),
                                      color: Colors.black,
                                    )),
                                onChanged: (pin) {
                                  setState(() {
                                    _pin = pin;
                                  });
                                },
                                onSubmit: (pin) {
                                  setState(() {
                                    _pin = pin;
                                  });
                                },
                              )),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(height: 40),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConnectivityWidgetWrapper(
                      stacked: false,
                      offlineWidget: FlatButton(
                        onPressed: () {},
                        color: Colors.grey,
                        child: Center(
                            child: Text(
                          'waiting_for_network'.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                      ),
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if (_pin != null) {
                            stc_DirectPaymentConfirm(_pin);
                          } else {
                            await Fluttertoast.showToast(
                                msg: 'pleaseInsertCode'.tr(),
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
                          'completeProcess'.tr(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Center(
                  //   child: Text(
                  //     'ستم اكمال المعاملة خلال ساعات',
                  //     style: TextStyle(color: Color(0xff111111), fontSize: 16),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      '1SRAnd20HallalaPer100SRForStc'.tr(),
                      style: TextStyle(color: Color(0xff111111), fontSize: 14),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   '558567146 ' + ': STCpay' + ' حساب أهلا وسهلا على  ',
                      //   style: TextStyle(
                      //       color: Theme.of(context).primaryColor,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      // Text(
                      //   ' أو ',
                      //   style: TextStyle(
                      //       color: Color(0xff111111), fontSize: 16),
                      // ),
                      // Text(
                      //   ' Mastercard ',
                      //   style: TextStyle(
                      //       color: primaryColor,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  )),
                ],
              ),
      ],
    );
  }

  String phoneIsoCode2;
  var stcContorller = TextEditingController();

  Column stcWidget() {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 3),
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 20),
          child: Text(
            'phoneNumberOnStcPay'.tr(),
            style: TextStyle(color: Color(0xff111111), fontSize: 16),
            textAlign: TextAlign.right,
          ),
        ),
        AnimatedContainer(
          duration: Duration(seconds: 1),
          margin: EdgeInsets.only(right: 17, left: 20, top: 5),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xffF8F8F8),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DropdownButton<String>(
                  items: <String>[
                    '968',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Tajawal-Bold",
                            fontSize: (13)),
                      ),
                    );
                  }).toList(),
                  underline: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                    ),
                  ),
                  hint: Text(
                    phoneIsoCode2 == null ? '968' : phoneIsoCode2,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Tajawal-Bold",
                        fontSize: (13)),
                  ),
                  onChanged: (v) {
                    phoneIsoCode2 = v;
                    // dateTypeBorder = Color(0xffFE9E9E9);
                    setState(() {});
                  },
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 6),
                  width: 200,
                  child: TextField(
                    maxLength: 8,
                    controller: stcContorller,
                    enabled: true,
                    decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 13),
                        alignLabelWithHint: true),
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff111111),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  chargecreditManual() async {
    if (widget.amount != '') {
      try {
        var pref = await SharedPreferences.getInstance();
        var id = pref.getString('userId');
        var name = pref.getString('userName');
        setState(() {
          loading = true;
        });
        phoneIsoCode2 = phoneIsoCode2 == null ? '968': phoneIsoCode2;
        FormData data = FormData.fromMap({
          'customerId': id,
          'customerGivenName': name,
          'customerPhone': phoneIsoCode2 + stcContorller.text,
          'amount': widget.amount,
          'note': 'رصيد مندوب',
          'paymentCause': 'شحن رصيد '
        });
        log(data.fields.toString());
        var response = await Dio()
            .post(APIKeys.BASE_URL + 'chargecredit_Manual', data: data);
        print('RESPONSE ${response.data}');
        if (response.data != null) {
          loading = false;
          setState(() {});
          stcInfo = StcInfo.fromJson(response.data);
          if (response.data['errors'] == "") {
            setState(() {
              stip = 2;
            });
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
        rethrow;
      }
    }
  }

  stc_DirectPaymentConfirm(otpValue) async {
    if (widget.amount != '') {
      try {
        // pr.show();
        setState(() {
          loading = true;
        });
        FormData data = FormData.fromMap({
          'OtpValue': otpValue,
          'TransactionId': stcInfo.id,
        });

        var response = await Dio()
            .post(APIKeys.BASE_URL + 'stc_DirectPaymentConfirm', data: data);
        print('RESPONSE ${response.data}');
        if (response.data != null) {
          // await pr.hide();
          if (this.mounted) {
            setState(() {
              //8968879
            });
          }
          stcInfo = StcInfo.fromJson(response.data);
          if (stcInfo.state == "true") {
            await getUserData();
          } else {
            await Fluttertoast.showToast(
                msg: stcInfo.message ?? 'tryAgain'.tr(),
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
        // await Fluttertoast.showToast(
        // msg: 'tryAgain'.tr(),
        // toastLength: Toast.LENGTH_SHORT,
        // gravity: ToastGravity.BOTTOM,
        // //timeInSecForIos: 1,
        // backgroundColor: Colors.red,
        // textColor: Colors.white,
        // fontSize: 16.0);

        if (this.mounted) {
          setState(() {
            loading = false;
          });
        }
        rethrow;
      }
    }
  }

  Future getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getUserinfo/${user.loginPhone}');
      var data = response.data;
      user = User.fromJson(data);
      await prefs.setString('user', json.encode(user));

      await Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => Charge(stcInfo),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 1),
        ),
      );
      await Fluttertoast.showToast(
          msg: 'تم الشحن بنجاح',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } on DioError catch (error) {
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
}
