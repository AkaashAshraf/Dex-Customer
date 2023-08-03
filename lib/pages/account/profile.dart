import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/user.dart';
import 'package:customers/providers/account/user_info_provider.dart';
import 'package:customers/providers/services/media_pick.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final User user;

  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState(user);
}

class _ProfileState extends State<Profile> {
  ProgressDialog _pr;

  User user;
  // User user;
  _ProfileState(this.user);

  // @override
  // void initState() {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  TextEditingController oldPass = TextEditingController();

  Future updateUser() async {
    try {
      _pr.show();

      // FormData data =  FormData();
      // data.add('uid', user.id);
      // data.add('first_name', name.text);
      // data.add('last_name', "");
      // data.add('email', email.text);
      // data.add('address', address.text);

      var response = await dioClient.post(APIKeys.BASE_URL + 'updateUserInfo',
          data: FormData.fromMap({
            'uid': user.id,
            'first_name': name.text,
            'last_name': '',
            'email': email.text,
            'address': address.text,
          }));
      print('RESPONSE ${response.data}');
      Provider.of<UserInfoProvider>(context, listen: false)
          .updateUser(User.fromJson(response.data['Data']));
      _pr.hide();
      if (response.data.toString().contains("sucess")) {
        Fluttertoast.showToast(
            msg: "done".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
            msg: response.toString(),
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

  Future updatePassword() async {
    try {
      _pr.show();

      // FormData data =  FormData();
      // data.add('uid', user.id);
      // data.add('old_password', oldPass.text);
      // data.add('password', pass2.text);

      var response =
          await dioClient.post(APIKeys.BASE_URL + 'updateUserPassword',
              data: FormData.fromMap({
                'uid': user.id,
                'old_password': oldPass.text,
                'password': pass2.text,
              }));
      print('RESPONSE ${response.data}');

      _pr.hide();
      if (response.data["Response"] == "1") {
        Fluttertoast.showToast(
            msg: "done".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
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

  File _profileImage;

  Future updateImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      _pr.show();
      // FormData data =  FormData();
      // data.add('uid', user.id);
      // data.add('img', UploadFileInfo(_profileImage, 'basha'));

      var response =
          await dioClient.post(APIKeys.BASE_URL + 'updateUserProfileImg',
              data: FormData.fromMap({
                'uid': user.id,
                'img': await MultipartFile.fromFile(_profileImage.path,
                    filename: 'Customer_image_${_profileImage.path}'),
                // MultipartFile.fromFileSync( _profileImage.path,filename: '')
              }));
      print('RESPONSE ${response.data}');
      Provider.of<UserInfoProvider>(context, listen: false)
          .updateUser(User.fromJson(response.data['Data']));
      user = User.fromJson(response.data['Data']);
      _pr.hide();
      setState(() {});
      if (response.data.toString().contains("sucess")) {
        pref.setString('userImage', user.image);
        userImage = pref.getString('userImage');
        Fluttertoast.showToast(
            msg: "done".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 5,
            backgroundColor: Colors.green,
            textColor: Colors.white,
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
      _pr.hide();

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
      _pr.hide();

      throw error;
    }
  }

  // _ProfileState(this.user);

  var width;

  String phoneIsoCode;

  @override
  void initState() {
    phoneIsoCode = '+968';
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    _pr.style(
        message: 'editingProfile'.tr(),
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    name = TextEditingController(text: user.firstName);
    phone = TextEditingController(text: user.loginPhone);
    email = TextEditingController(text: user.email);
    address = TextEditingController(text: user.address);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;

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
        child: Consumer<UserInfoProvider>(builder: (context, value, _) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.black,
                title: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                centerTitle: true,
              ),
              body: ListView(
                children: [
                  Stack(
                    children: [
                      ContainerResponsive(
                        width: 720,
                        height: 350,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/path383.png'),
                          fit: BoxFit.fill,
                        )),
                      ),
                      ContainerResponsive(
                        width: 720,
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                ContainerResponsive(
                                  width: 200,
                                  height: 210,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: user == null
                                          ? AssetImage('images/loading.gif')
                                          : CachedNetworkImageProvider(
                                              APIKeys.ONLINE_IMAGE_BASE_URL +
                                                  user.image,
                                            ),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                        width: 1.5, color: Color(0xffED8437)),
                                    borderRadius: BorderRadius.circular(360),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 5,
                                  child: GestureDetector(
                                    onTap: () async {
                                      var pickedFile = await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              MediaPickDialog());
                                      if (pickedFile != null) {
                                        setState(() {
                                          _profileImage = pickedFile;
                                        });
                                        updateImage();
                                      }
                                    },
                                    child: ContainerResponsive(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          border: Border.all(
                                              width: 1.5,
                                              color: Color(0xffED8437)),
                                          borderRadius:
                                              BorderRadius.circular(360),
                                        ),
                                        child: Center(
                                            child: Icon(Icons.edit,
                                                size: 15,
                                                color: Colors.green))),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBoxResponsive(
                    height: 80,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextResponsive('credit'.tr(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black)),
                            TextResponsive(user.credit.toStringAsFixed(1),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    color: Colors.black)),
                            SizedBoxResponsive(width: 10),
                            TextResponsive('sr'.tr(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black))
                          ],
                        ),
                        SizedBoxResponsive(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextResponsive("${'points'.tr()} : ",
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black)),
                            TextResponsive(user.points.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    color: Colors.black)),
                            SizedBoxResponsive(width: 10),
                            TextResponsive('sr'.tr(),
                                style: TextStyle(
                                    fontSize: 30, color: Colors.black))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBoxResponsive(
                    height: 150,
                  ),
                  Container(
                    margin: EdgeInsetsResponsive.only(left: 20, right: 20),
                    child: Text(
                      'phone',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                    ).tr(),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    margin: EdgeInsetsResponsive.only(right: 20, left: 20),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: Padding(
                      padding: EdgeInsetsResponsive.only(right: 20.0, left: 20),
                      child: TextField(
                        controller: phone,
                        enabled: true,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Container(
                    margin: EdgeInsetsResponsive.only(left: 20, right: 20),
                    child: Text(
                      'email',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                    ).tr(),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    margin: EdgeInsetsResponsive.only(right: 20, left: 20),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: Padding(
                      padding: EdgeInsetsResponsive.only(right: 20.0, left: 20),
                      child: TextField(
                        controller: email,
                        enabled: true,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        updateUser();
                      },
                      child: Container(
                        height: 45,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text('confirm'.tr(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        }));
  }
}
