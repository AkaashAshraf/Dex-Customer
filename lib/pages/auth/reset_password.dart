import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

TextEditingController oldPass = TextEditingController();
TextEditingController pass1 = TextEditingController();
TextEditingController pass2 = TextEditingController();

class _ResetPasswordState extends State<ResetPassword> {
  ProgressDialog _pr;
  Future updatePassword() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var userId = pref.getString('userId');
      _pr.show();
      var response = await Dio().post(APIKeys.BASE_URL + 'updateUserPassword',
          data: FormData.fromMap({
            'uid': userId,
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
        Navigator.of(context).pop();
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

  @override
  void initState() {
    super.initState();
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
  }

  @override
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
        title: TextResponsive('changePassword'.tr(),
            style: TextStyle(
              fontSize: 35,
            )),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ContainerResponsive(
            padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
            margin: EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: pass1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'enterThePassword'.tr(),
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'JF-Flat')),
              // textAlign:
              //     TextAlign.right,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ContainerResponsive(
            padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
            margin: EdgeInsetsResponsive.only(right: 30, left: 30, top: 5),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: pass2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'pleaseReenterPassword'.tr(),
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'JF-Flat',
                  )),
              // textAlign:
              //     TextAlign.right,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ConnectivityWidgetWrapper(
            stacked: false,
            offlineWidget: ContainerResponsive(
              margin: EdgeInsets.only(right: 30, left: 30, top: 25),
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[500],
              ),
              child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Center(
                    child: Text(
                      'في إنتظار الإنترنت',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ),
            child: GestureDetector(
              onTap: () {
                if (pass1.text != pass2.text) {
                  Fluttertoast.showToast(
                      msg: "passwordsNotMatched".tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      //timeInSecForIos: 5,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Navigator.pop(context);
                  updatePassword();
                }
              },
              child: ContainerResponsive(
                margin: EdgeInsetsResponsive.only(right: 30, left: 30, top: 25),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    'change',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ).tr(),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
