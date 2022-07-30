import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/user.dart';
import 'package:customers/providers/services/location.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class CodeValidation extends StatefulWidget {
  final String phoneNumber;

  const CodeValidation({Key key, this.phoneNumber}) : super(key: key);
  @override
  _CodeValidationState createState() => _CodeValidationState();
}

class _CodeValidationState extends State<CodeValidation> {
  String _pin;
  bool _isLoading;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
  }

  Future resendCode(String number) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var _phoneNumber = number;
      print(_phoneNumber.substring(1));
      var response = await dioClient
          .get(APIKeys.BASE_URL + 'sendVerificationCode/login&$_phoneNumber');
      print('RESPONSE IS $response');
      if (response.data != null) {
        await Fluttertoast.showToast(
            msg: "successed".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _isLoading = false;
        });
      }
    } on DioError catch (error) {
      setState(() {
        _isLoading = false;
      });
      await Fluttertoast.showToast(
          msg: "tryAgain".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
        _isLoading = false;
      });
      await Fluttertoast.showToast(
          msg: "tryAgain".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      rethrow;
    }
  }

  Future _verifyUser(String smsCode) async {
    try {
      //inializing SharedPrefrences
      prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoading = true;
      });
      //making HTTP Post request to BASE-URL/VerifyCode
      //The Response Should Be
      /* 
      {
        "State": 0 OR 1,
        "Data" : { USER DATA }
      }
    */
      var response = await dioClient.post(APIKeys.BASE_URL + "verfiyCode",
          data: FormData.fromMap(
              {"login_phone": widget.phoneNumber, "smsCode": _pin}));

      /* 
      MAKE a decision From Http response
      if state == 1 means the operation is done 
      if isVerified == 1 means the user has been verified correctly

    */
      if (response.data.toString() != null) {
        if (response.data['State'] == 1) {
          var isVerified = response.data['Data']['isVerified'];
          if (isVerified == 1) {
            user = User.fromJson(response.data['Data']);
            prefs.setString('user_phone', user.loginPhone.toString());
            prefs.setString('user_image', user.image.toString());
            prefs.setString('user_id', user.id.toString());
            prefs.setString('user_name', user.firstName.toString());
            prefs.setString('user_email', user.email.toString());
            prefs.setString('password', user.password.toString());
            prefs.setString('IS_LOGIN', 'true');
            prefs.setString('userId', user.id.toString());
            prefs.setString('userImage', user.image.toString());
            prefs.setString('userName', user.firstName.toString());
            await _getUserData(user.loginPhone.toString());
            var loc = Location();
            if (await loc.hasPermission() == PermissionStatus.granted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductLocation(from: 'main')));
            } else {
              await loc.requestPermission();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductLocation(from: 'main')));
            }
          } else {
            Fluttertoast.showToast(
                msg: "retry".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 15.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "errorRetry".tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
        }
      } else {}
      setState(() {
        _isLoading = false;
      });
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

  Future _getUserData(String phoneNumber) async {
    try {
      var response =
          await dioClient.get(APIKeys.BASE_URL + 'getUserinfo/$phoneNumber');

      var data = response.data;

      userId = prefs.getString('user_id');
      userImage = prefs.getString('user_image');
      userPhone = prefs.getString('user_phone');
      userName = prefs.getString('user_name');
      userEmail = prefs.getString('user_email');
      isLogin = prefs.getString('IS_LOGIN');
      regionId =
          prefs.getInt('regionId') != null ? prefs.getInt('regionId') : 0;
      regionId += 3;

      sendToken('${data['id']}');
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

  Future sendToken(var usrId) async {
    try {
      var token = await FirebaseMessaging.instance.getToken();

      print('TOKEN $token');

      var response = await dioClient
          .get(APIKeys.BASE_URL + 'sendToken/Userid=$usrId&token=$token&appId=1');

      print('TOKEN RESPONSE $response');

      Fluttertoast.showToast(
          msg: "loggedin".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).accentColor,
          fontSize: 15.0);
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

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: ConnectivityWidgetWrapper(
        message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
        child: Scaffold(
            backgroundColor: Color(0xffED8437),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: ListView(children: [
                Stack(
                  children: [
                    ContainerResponsive(
                      height: 1500,
                      width: 720,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/otpbackgroung.jpg'),
                            fit: BoxFit.cover),
                      ),
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: .7,
                            child: ContainerResponsive(
                                height: 1500,
                                width: 720,
                                color: Color(0xffED8437)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _isLoading == true
                                  ? Center(
                                      child: ContainerResponsive(
                                        height: 100,
                                        child: Center(
                                          child: ImageLoad(100.0),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: ContainerResponsive(
                                              width: 450,
                                              height: 100,
                                              child: Center(
                                                  child: PinInputTextField(
                                                pinLength: 4,
                                                decoration: BoxLooseDecoration(
                                                    bgColorBuilder:
                                                        PinListenColorBuilder(
                                                      Colors.white,
                                                      Colors.white,
                                                    ),
                                                    strokeColorBuilder:
                                                        PinListenColorBuilder(
                                                            Colors.white,
                                                            Colors.white),
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 25,
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
                                          SizedBoxResponsive(
                                            height: 20,
                                          ),
                                          // Center(
                                          //   child: GestureDetector(
                                          //     onTap: () =>
                                          //         resendCode(widget.phoneNumber),
                                          //     child: ContainerResponsive(
                                          //       margin: EdgeInsetsResponsive.only(
                                          //           right: 10, top: 5),
                                          //       child: TextResponsive(
                                          //         'resendCode',
                                          //         style: TextStyle(
                                          //             color:
                                          //                 Theme.of(context).accentColor,
                                          //             fontSize: 18),
                                          //         textAlign: TextAlign.right,
                                          //       ).tr(),
                                          //     ),
                                          //   ),
                                          // ),
                                          SizedBoxResponsive(
                                            height: 30,
                                          ),
                                          ConnectivityWidgetWrapper(
                                            stacked: false,
                                            offlineWidget: ContainerResponsive(
                                              margin: EdgeInsetsResponsive.only(
                                                  left: 30,
                                                  right: 30,
                                                  top: 5,
                                                  bottom: 5),
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                              child: Center(
                                                child: TextResponsive(
                                                  'في إنتظار الإنترنت',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ).tr(),
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () => _verifyUser(_pin),
                                              child: ContainerResponsive(
                                                margin:
                                                    EdgeInsetsResponsive.only(
                                                        left: 120,
                                                        right: 120,
                                                        top: 5,
                                                        bottom: 5),
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: TextResponsive(
                                                    'confirm'.tr(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ContainerResponsive(
                        padding: EdgeInsetsResponsive.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back,
                                color: Colors.white,
                                size: ScreenUtil().setSp(50)),
                          ],
                        )),
                  ],
                ),
                // Image.asset(
                //   'images/bottom_town.png',
                //   height: 150,
                //   fit: BoxFit.fitWidth,
                // )
              ]),
            )),
      ),
    );
  }
}
