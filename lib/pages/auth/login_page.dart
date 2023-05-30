import 'dart:async';
import 'dart:developer';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/app.dart';
import 'package:customers/models/user.dart';
import 'package:customers/pages/auth/register_page.dart';
import 'package:customers/pages/auth/request_reset.dart';
import 'package:customers/pages/auth/reset_password.dart';
import 'package:customers/providers/account/user_info_provider.dart';
import 'package:customers/providers/auth/otp_validation_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var vistorPhone = TextEditingController();
  var vistorName = TextEditingController();

  var hidePass = true;
  var acceptRules = false;

  var loading = false;
  SharedPreferences prefs;

  String _name, _password, _email, _phone;

  Future login(String password, String phone) async {
    prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        loading = true;
      });
      var response = await dioClient.post(APIKeys.BASE_URL + 'login',
          data: FormData.fromMap({
            'login_phone': phone.toString(),
            'password': password,
          }));
      print(response.data['Data']);
      user = User.fromJson(response.data);

      if (response.data['Data'] == "true") {
        visitor = false;
        // Navigator.pushReplacementNamed(context, 'home');

        // prefs.setString('user_phone', _phone.toString());
        // prefs.setString('IS_LOGIN', 'true');
        getUserData(_phone.toString());
      } else {
        setState(() {
          loading = false;
        });

        if (response.data['Data'] == 'رقم الجوال وكلمة المرور غير متطابقين') {
          Fluttertoast.showToast(
              msg: "mobileNumberAndPasswordDoNotMatch".tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: response.data['Data'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    } on DioError catch (error) {
      loading = false;

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
      loading = false;

      throw error;
    }
  }

  Future getUserData(var userPhone) async {
    try {
      var response =
          await dioClient.get(APIKeys.BASE_URL + 'getUserinfo/$userPhone');
      log('user token ${response.data}');

      var data = response.data;
      user = User.fromJson(response.data);
      prefs.setString('userId', '${data['id']}');
      prefs.setString('userImage', '${data['image']}');
      prefs.setString('userName', '${data['first_name']}');
      prefs.setString('user_phone', user.loginPhone.toString());
      prefs.setString('user_image', user.image.toString());
      prefs.setString('user_id', user.id.toString());
      prefs.setString('user_name', user.firstName.toString());
      prefs.setString('user_email', user.email.toString());
      prefs.setString('password', user.password.toString());
      prefs.setString('IS_LOGIN', 'true');

      sendToken('${data['id']}', userPhone);

//      print(user);
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

  Future sendToken(var userId, var userPhone) async {
    try {
      var token = await FirebaseMessaging.instance.getToken();
      prefs.setString('userToken', user.password.toString());

      var response = await dioClient.get(
          APIKeys.BASE_URL + 'sendToken/Userid=$userId&token=$token&appId=1');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CodeValidation(
                    phoneNumber: userPhone,
                  )));
      print('TOKEN RESPONSE $response');

      Fluttertoast.showToast(
          msg: "loggedin".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).accentColor,
          fontSize: 15.0);
      user = User.fromJson(response.data);

      setState(() {
        loading = false;
      });
      print("AFTER");
    } on DioError catch (error) {
      setState(() {
        loading = false;
      });
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
      setState(() {
        loading = false;
      });
      throw error;
    }
  }

  StreamSubscription iosSubscription;

  @override
  void initState() {
    phoneIsoCode = '+968';
    super.initState();
  }

  String phoneIsoCode;

  Widget test() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: DropdownButton<String>(
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
              color: Colors.black,
              fontFamily: "CoconNextArabic",
              fontSize: (24)),
        ),
        onChanged: (v) {
          phoneIsoCode = v;
          // dateTypeBorder = Color(0xffFE9E9E9);
          setState(() {});
        },
      ),
    );
  }

  var mediaQuery;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: ConnectivityWidgetWrapper(
        message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: <Widget>[
              SizedBox(
                child: Image.asset(
                  "assets/images/login_image.png",
                  fit: BoxFit.fill,
                ),
                height: MediaQuery.of(context).size.height * .4,
                width: double.infinity,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(children: <Widget>[
                        SizedBoxResponsive(
                          height: 0,
                        ),
                        ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            height: MediaQuery.of(context).size.height * .13,
                            decoration: BoxDecoration(
                                color: Theme.of(context).hintColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10.0, left: 10),
                                child: test(),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    maxLength: phoneIsoCode == '+968' ? 8 : 9,
                                    keyboardType: TextInputType.phone,
                                    controller: phone,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 8,
                                            bottom: 5,
                                            top: 8,
                                            right: 15),
                                        hintStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black),
                                        hintText: 'phoneNumber'.tr()),
                                  ),
                                ),
                              ),
                            ])),
                        SizedBoxResponsive(
                          height: 30,
                        ),
                        ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            height: MediaQuery.of(context).size.height * .13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).hintColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ContainerResponsive(
                                  padding: EdgeInsetsResponsive.only(
                                      right: 15, left: 15),
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  width: 550,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: password,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black),
                                          hintText: 'password'.tr()),
                                      // textAlign: TextAlign.right,
                                      obscureText: hidePass ? true : false,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: ScreenUtil().setSp(30)),
                                    ),
                                  ),
                                ),
                                ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  width: 90,
                                  child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePass
                                            ? hidePass = false
                                            : hidePass = true;
                                        print(hidePass);
                                      });
                                    },
                                    child: Image.asset(
                                      hidePass
                                          ? 'images/closeeye.png'
                                          : 'images/openeye.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                          visible: loading ? true : false,
                          child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            padding: EdgeInsetsResponsive.only(top: 20),
                            height: MediaQuery.of(context).size.height * .13,
                            child: Center(
                              child: ImageLoad(120.0),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            _phone = phoneIsoCode.toString() + phone.text;
                            _password = password.text;

                            if (phoneIsoCode == '+968' &&
                                phone.text.length != 8) {
                              Fluttertoast.showToast(
                                  msg: "writePhoneNumber".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (phoneIsoCode != '+968' &&
                                phone.text.length != 9) {
                              Fluttertoast.showToast(
                                  msg: "writePhoneNumber".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            } else if (_password.trim().length == 0) {
                              Fluttertoast.showToast(
                                  msg: "writePassword".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              return;
                            }

                            login(
                              _password,
                              _phone,
                            );
                          },
                          child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            height: MediaQuery.of(context).size.height * .13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: TextResponsive(
                                'login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ).tr(),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = null;
                              loading = true;
                              visitor = true;
                              userName = '';
                              userPhone = '';
                              userImage = 'logo.png';
                            });
                            log('text log for navigation');
                            Navigator.pushReplacementNamed(context, 'home');
                            Timer(Duration(seconds: 2), () {
                              if (mounted) {
                                setState(() {
                                  loading = false;
                                });
                              }
                            });
                          },
                          child: ContainerResponsive(
                            heightResponsive: true,
                            widthResponsive: true,
                            height: MediaQuery.of(context).size.height * .13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey,
                            ),
                            child: Center(
                              child: TextResponsive(
                                'visitor',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ).tr(),
                            ),
                          ),
                        ),
                        SizedBoxResponsive(
                          height: 10,
                        ),
                        ContainerResponsive(
                          heightResponsive: true,
                          widthResponsive: true,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ContainerResponsive(
                                  heightResponsive: true,
                                  widthResponsive: true,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextResponsive(
                                        'dontHaveAccount',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      'ar'
                                                  ? 15
                                                  : 15,
                                        ),
                                      ).tr(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterScreen()));
                                        },
                                        child: TextResponsive(
                                          'pressHere',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontSize:
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        'ar'
                                                    ? 15
                                                    : 15,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          textAlign: TextAlign.center,
                                        ).tr(),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        SizedBoxResponsive(height: 15),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RequestReset()));
                            },
                            child: TextResponsive(
                              'forgetPassword',
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontSize: Localizations.localeOf(context)
                                            .languageCode ==
                                        'ar'
                                    ? 15
                                    : 15,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ).tr(),
                          ),
                        ),
                      ])))
            ],
          ),
        ),
      ),
    );
  }
}
