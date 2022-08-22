import 'dart:io';

import 'package:customers/models/user.dart';
import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/providers/services/media_pick.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  final User user;

  const ContactPage({Key key, this.user}) : super(key: key);
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _isLoading;

  TextEditingController customerName = TextEditingController();
  TextEditingController customerEmail = TextEditingController();
  int customerId;

  TextEditingController feedBackTitle = TextEditingController();
  TextEditingController feedBackBody = TextEditingController();
  File _feedBackImage;

  String _name, _feedBackTitle, _feedBackBody;

  Future contactUs(String name, String email, String id, String feedBackBody,
      String feedBackTitle, File feedBackImage) async {
    setState(() {
      _isLoading = true;
    });
    FormData data = feedBackImage != null
        ? FormData.fromMap({
            "customerName": name,
            "feedbackTitle": feedBackTitle ?? 'No title',
            "feedbackBody": _feedBackBody ?? 'No body',
            "customerEmail": email ?? 'No email',
            "customerId": customerId ?? 'No Id',
            "feedBackImg": await MultipartFile.fromFile(feedBackImage.path),
          })
        : FormData.fromMap({
            "customerName": name,
            "feedbackTitle": feedBackTitle ?? 'No title',
            "feedbackBody": _feedBackBody ?? 'No body',
            "customerEmail": email ?? 'No email',
            "customerId": customerId ?? 'No Id',
          });
    var response = await dioClient.post(APIKeys.BASE_URL + 'sendFeedback', data: data);

    setState(() {
      _isLoading = false;
    });
    if (response.data != null) {
      Fluttertoast.showToast(
          msg: "sent".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Theme.of(context).accentColor,
          fontSize: 16.0);
    }
  }

  void _onLink(String ur) async {
    final url = '$ur';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsApp(String ur) async {
    String phoneNumber = ur;
    String message = 'hello'.tr();
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  void initState() {
    User user = widget.user;
    customerName.text = user.firstName;
    customerEmail.text = user.email;
    customerId = user.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 0,
                  ),

                  /////////// Header

                  SizedBox(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            left: 25,
                            top: 5,
                            child: Container(
                                width: 55,
                                height: 35,
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationPage()));
                                    },
                                    child: Image.asset(
                                      'images/ring.PNG',
                                      fit: BoxFit.contain,
                                    )))),
                        Positioned(
                            right: 55,
                            top: 5,
                            child: Text(
                              'contactUs',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            ).tr()),
                        Positioned(
                            right: 5,
                            top: 3,
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: Image.asset(
                    'images/logo.png',
                    width: 100,
                    height: 90,
                    fit: BoxFit.contain,
                  )),

                  SizedBox(
                    height: 6,
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      'userName',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                      textAlign: TextAlign.right,
                    ).tr(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).hintColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        enabled: true,
                        controller: customerName,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Color(0xffFBB746),
                              size: 15,
                            ),
                            hintText: 'enterUsername'.tr(),
                            hintStyle: TextStyle(fontSize: 13)),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                    child: Text(
                      'email',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                      textAlign: TextAlign.right,
                    ).tr(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).hintColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: customerEmail,
                        enabled: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Color(0xffFBB746),
                              size: 15,
                            ),
                            border: InputBorder.none,
                            hintText: 'enterEmail'.tr(),
                            hintStyle: TextStyle(fontSize: 13)),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                    child: Text(
                      'messageTitle',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                      textAlign: TextAlign.right,
                    ).tr(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).hintColor),
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).hintColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        controller: feedBackTitle,
                        enabled: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.edit,
                              color: Color(0xffFBB746),
                              size: 15,
                            ),
                            border: InputBorder.none,
                            hintText: 'enterTitle'.tr(),
                            hintStyle: TextStyle(fontSize: 13)),
                        textAlign: TextAlign.right,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                    child: Text(
                      'writeMessage',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                      textAlign: TextAlign.right,
                    ).tr(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 80,
                    child: Container(
                      margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).hintColor),
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).hintColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          controller: feedBackBody,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'writeMessage'.tr(),
                              hintStyle: TextStyle(fontSize: 13)),
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                    child: Text(
                      'attachImage',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 15),
                      textAlign: TextAlign.right,
                    ).tr(),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Visibility(
                    visible: true,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 1, color: Colors.black26),
                                borderRadius: BorderRadius.circular(10)
//                      shape: BoxShape.circle,
                                ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () async {
                              var pickedFile = await showDialog(
                                  context: context,
                                  builder: (context) => MediaPickDialog());
                              if (pickedFile != null)
                                setState(() {
                                  _feedBackImage = pickedFile;
                                });
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: 5),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
//                          shape: BoxShape.circle,
                                    color: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: _feedBackImage == null
                                    ? Center(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 55,
                                          color: Colors.white,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _feedBackImage,
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Positioned(
                            left: 0,
                            top: 65,
                            right: 100,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Theme.of(context).accentColor,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: FlatButton.icon(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.photo_camera,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text('')),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  _isLoading == true
                      ? Center(
                          child: Container(
                            height: 50,
                            child: Center(
                              child: ImageLoad(50.0),
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                    onTap: () {
                      _name = customerName.text;
                      _feedBackTitle = feedBackTitle.text;
                      _feedBackBody = feedBackBody.text;
                      contactUs(_name, _name, customerId.toString(),
                          _feedBackBody, _feedBackTitle, _feedBackImage);
                    },
                    child: Container(
                        //width: MediaQuery.of(context).size.width / 100 * 91,
                        margin: EdgeInsets.only(left: 40, right: 40, top: 5),
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            'send',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ).tr(),
                        )),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    'throughSocial',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ).tr()),

                  Stack(
                    children: <Widget>[
                      Image.asset('images/bottom_town.png'),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  _launchWhatsApp(appInfo.whatsApp);
//                                whatsAppOpen();
                                },
                                child: Image.asset(
                                  'images/whats.PNG',
                                  width: 50,
                                  height: 50,
                                )),
                            GestureDetector(
                                onTap: () {
                                  _onLink(appInfo.insta);
//                                    AppAvailability.launchApp('www.instegram.com');
                                },
                                child: Image.asset(
                                  'images/insta.PNG',
                                  width: 50,
                                  height: 50,
                                )),
                            GestureDetector(
                                onTap: () {
                                  print('twitter');
                                  _onLink(appInfo.twitter);
//                                    AppAvailability.launchApp('www.twitter.com');
                                },
                                child: Image.asset(
                                  'images/twitter.PNG',
                                  width: 50,
                                  height: 50,
                                )),
                            GestureDetector(
                                onTap: () {
                                  print('facebook');
                                  _onLink(appInfo.facebook);
//                                    AppAvailability.launchApp('www.facebook.com');
                                },
                                child: Image.asset(
                                  'images/facebook.PNG',
                                  width: 50,
                                  height: 50,
                                )),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
