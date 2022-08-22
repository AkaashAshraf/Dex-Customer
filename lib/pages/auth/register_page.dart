import 'dart:io';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/user.dart';
import 'package:customers/pages/account/terms_Of_Use.dart';
import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/providers/auth/otp_validation_provider.dart';
import 'package:customers/providers/services/media_pick.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File _profileImage;
  var name = TextEditingController();
  var phone = TextEditingController();
  var password = TextEditingController();

  String phoneIsoCode;

  @override
  void initState() {
    phoneIsoCode = '+968';
    super.initState();
  }

  var hidePass = true;
  var acceptRules = true;
  var loading = false;

  String _name, _password, _phone;

  Future<void> updateImage(id) async {
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      var response =
          await dioClient.post(APIKeys.BASE_URL + 'updateUserProfileImg',
              data: FormData.fromMap({
                'uid': id,
                'img': _profileImage != null
                    ? await MultipartFile.fromFile(_profileImage.path,
                        filename: 'Customer_image_${_profileImage.path}')
                    : null,
                // MultipartFile.fromFileSync( _profileImage.path,filename: '')
              }));
      print('RESPONSE ${response.data}');

      if (response.data.toString().contains("sucess")) {
        loading = false;

        Fluttertoast.showToast(
            msg: "registered".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Theme.of(context).accentColor,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: response.data["Data"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 5,
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

  Future createUser(
      String name, String password, String phone, File image) async {
    try {
      setState(() {
        loading = true;
      });
      var response = await Dio().post(APIKeys.BASE_URL + 'creatUser',
          data: FormData.fromMap({
            'login_phone': _phone,
            'password': password,
            'first_name': name,
          }));
      print(response);
      if (response.data['State'] == 0) {
        Fluttertoast.showToast(
            msg: "${response.data['Data']}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          loading = false;
        });
      }
      user = User.fromJson(response.data);
      setState(() {});
      if (response.data['State'] == 'sucess') {
        var user = User.fromJson(response.data['Data']);
        // ignore: unnecessary_statements
        _profileImage != null ? await updateImage(user.id) : null;
        if (user.isVerified == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          user = User.fromJson(response.data);
          FocusScope.of(context).unfocus();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CodeValidation(
                        phoneNumber: phone,
                      )));
        }
      }
    } on DioError catch (error) {
      loading = false;
      setState(() {});
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
      setState(() {});
      throw error;
    }
  }

  Widget test() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
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
      body: ListView(
        children: [
          SizedBox(
            child: Image.asset(
              "assets/images/login_image.png",
              fit: BoxFit.fill,
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .4,
          ),
          SizedBoxResponsive(
            height: 40,
          ),
          ContainerResponsive(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 4),
            heightResponsive: true,
            widthResponsive: true,
            height: MediaQuery.of(context).size.height * .13,
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 12.0, color: Colors.black),
                    hintText: 'userName'.tr()),
              ),
            ),
          ),
          SizedBoxResponsive(
            height: 30,
          ),
          ContainerResponsive(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 4),
              heightResponsive: true,
              widthResponsive: true,
              height: MediaQuery.of(context).size.height * .13,
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 10),
                  child: test(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: phone,
                      maxLength: phoneIsoCode == '+968' ? 8 : 9,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 8, bottom: 5, top: 8, right: 15),
                        hintStyle:
                            TextStyle(fontSize: 12.0, color: Colors.black),
                        hintText: 'phoneNumber'.tr(),
                      ),
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
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 4),
              height: MediaQuery.of(context).size.height * .13,
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: password,
                      obscureText: hidePass ? true : false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 12.0, color: Colors.black),
                        hintText: 'password'.tr(),
                      ),
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
                        hidePass ? hidePass = false : hidePass = true;
                        print(hidePass);
                      });
                    },
                    child: Image.asset(
                      hidePass ? 'images/closeeye.png' : 'images/openeye.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ])),
          SizedBoxResponsive(
            height: 15,
          ),
          loading ? Container(child: Load(150.0)) : Container(),
          SizedBoxResponsive(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              _name = name.text;
              _phone = phoneIsoCode.toString() + phone.text;
              _password = password.text;

              if (_name.trim().length == 0) {
                Fluttertoast.showToast(
                    msg: "writeName".tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              } else if (_name.length < 6) {
                Fluttertoast.showToast(
                    msg: "shortName".tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    // timeInSecForIos: 1,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (phoneIsoCode == '+968' && phone.text.length != 8) {
                Fluttertoast.showToast(
                    msg: "writePhone".tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              } else if (phoneIsoCode != '+968' && phone.text.length != 9) {
                Fluttertoast.showToast(
                    msg: "writePhone".tr(),
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
              } else if (!acceptRules) {
                Fluttertoast.showToast(
                    msg: "mustAccept".tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              } else {
                createUser(_name, _password, _phone, _profileImage);
              }
            },
            child: ContainerResponsive(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 4),
              heightResponsive: true,
              widthResponsive: true,
              height: MediaQuery.of(context).size.height * .13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: TextResponsive(
                  'createAccount',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ).tr(),
              ),
            ),
          ),
          SizedBoxResponsive(
            height: 25,
          ),
          ContainerResponsive(
            heightResponsive: true,
            widthResponsive: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextResponsive(
                  'alreadyHaveAccount',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize:
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? 15
                            : 15,
                  ),
                ).tr(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: TextResponsive(
                    'login',
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize:
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 15
                              : 15,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ).tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
