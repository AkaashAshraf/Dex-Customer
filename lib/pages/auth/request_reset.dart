import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class RequestReset extends StatefulWidget {
  @override
  _RequestResetState createState() => _RequestResetState();
}

class _RequestResetState extends State<RequestReset> {
  @override
  var loading = false;
  var phone = TextEditingController();
  @override
  void initState() {
    super.initState();
    phoneIsoCode = '+968';
  }

  String phoneIsoCode;
  Widget test() {
    return DropdownButton<String>(
      items: <String>[
        '+968',
        '+249',
        '‎+966',
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: TextResponsive(
            value,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "CoconNextArabic",
                fontSize: (24)),
          ),
        );
      }).toList(),
      underline: ContainerResponsive(
        decoration: BoxDecoration(
          border: null,
        ),
      ),
      hint: TextResponsive(
        phoneIsoCode == null ? '+249' : phoneIsoCode,
        style: TextStyle(
            color: Colors.black, fontFamily: "CoconNextArabic", fontSize: (24)),
      ),
      onChanged: (v) {
        phoneIsoCode = v;
        // dateTypeBorder = Color(0xffFE9E9E9);
        setState(() {});
      },
    );
  }

  requestReset(String phone) async {
    try {
      setState(() {
        loading = true;
      });
      FormData data = FormData.fromMap({
        'login_phone': '$phone',
        // 'password': '$password',
      });

      var response =
          await dioClient.post(APIKeys.BASE_URL + 'resetPassword', data: data);
      // print('RESPONSE ${response.data['Data']}');

      setState(() {
        loading = false;
      });
      if (response.data == '1') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Fluttertoast.showToast(
            msg: "resetDone".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // getUserData(phone);
      } else {
        Fluttertoast.showToast(
            msg: "noAccount".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: TextResponsive(
            "restorePassword".tr(),
            style: TextStyle(fontSize: 40),
          ),
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: ConnectivityWidgetWrapper(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: ContainerResponsive(
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 15),
                    width: 650,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ContainerResponsive(
                          width: 300,
                          child: TextField(
                            maxLength: phoneIsoCode == '+968' ? 8 : 9,
                            controller: phone,
                            enabled: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 15),
                              border: InputBorder.none,
                              counterText: '',
                              hintText: 'phoneNumber'.tr(),
                              hintStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Colors.grey[600],
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        test(),
                      ],
                    ),
                  ),
                ),
                SizedBoxResponsive(
                  height: 50,
                ),
                Center(
                  child: ConnectivityWidgetWrapper(
                    stacked: false,
                    offlineWidget: ContainerResponsive(
                      width: 650,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[500],
                      ),
                      child: Center(
                        child: Text(
                          'في إنتظار الإنترنت',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ).tr(),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (phoneIsoCode == '+968' && phone.text.trim().length != 8) {
                          Fluttertoast.showToast(
                              msg: "writePhoneNumber".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              //timeInSecForIos: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        } else if (phoneIsoCode != '+968' && phone.text.trim().length != 9) {
                          Fluttertoast.showToast(
                              msg: "writePhoneNumber".tr(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              //timeInSecForIos: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }
                        var _phone = phoneIsoCode.toString() + phone.text;

                        requestReset(_phone);
                      },
                      child: ContainerResponsive(
                        height: 80,
                        width: 650,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Text(
                            'continue'.tr(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Image.asset('images/bottom_town.png')
              ]),
        ));
  }
}
