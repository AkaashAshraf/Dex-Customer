import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers/app.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class Recipt extends StatefulWidget {
  final int price;
  final int orderId;
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String chatID;
  Recipt(
    this.price,
    this.orderId,
    this.peerId,
    this.peerAvatar,
    this.peerName,
    this.chatID,
  );
  @override
  _ReciptState createState() =>
      _ReciptState(price, peerId, peerAvatar, peerName, chatID);
}

class _ReciptState extends State<Recipt> {
  var _price = TextEditingController();
  int price;
  final String peerId;
  final String chatID;
  final String peerAvatar;
  final String peerName;
  _ReciptState(
      this.price, this.peerId, this.peerAvatar, this.peerName, this.chatID);
  String groupChatId;
  SharedPreferences prefs;
  String id;
  File reciprtimg;
  bool isLoading;
  final db = FirebaseFirestore.instance;
  var userId;
  var userImage;
  var userName;

  @override
  void initState() {
    super.initState();
    reciprtimg = null;
    isLoading = false;
    groupChatId = '';
    _price.clear();
    readLocal();
    chatReference =
        db.collection("chats").doc(widget.chatID).collection('messages');
  }

  String imageUrl;

  readLocal() async {
    prefs = await SharedPreferences.getInstance();

    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString('userId');
    userImage = pref.getString('userImage');
    userName = pref.getString('userName');

    id = userId.toString() ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set({'chattingWith': peerId});

    setState(() {});
  }

  CollectionReference chatReference;

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff34C961))),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  void onSendMessage(type) {
    // type: 0 = text, 1 = image, 2 = sticker

    var content;
    if (type == 0) {
      content = " تكلفة البضاعة " + ":" + "${_price.text} ر.س ";
      content =
          content + " " + " تكلفة التوصيل " + ":" + "${price.toString()} ر.س ";
      content = content +
          "      " +
          " الاجمالي  " +
          ":" +
          "${(price + int.parse(_price.text)).toString()} ر.س ";
      chatReference.add({
        'text': content,
        'sender_id': userId.toString(),
        'sender_name': userName,
        'receiver_id': peerId,
        'receiver_name': peerName,
        'profile_photo': userImage,
        'receiver_profile': peerAvatar,
        'image_url': '',
        'time': FieldValue.serverTimestamp(),
      }).then((documentReference) {
        setState(() {
          // _isWritting = false;
        });
      }).catchError((e) {});
    } else {
      content = imageUrl;
      chatReference.add({
        'text': '',
        'sender_id': userId.toString(),
        'sender_name': userName,
        'receiver_id': peerId,
        'receiver_name': peerName,
        'profile_photo': userImage,
        'receiver_profile': peerAvatar,
        'image_url': content,
        'time': FieldValue.serverTimestamp(),
      }).then((documentReference) {
        setState(() {
          // _isWritting = false;
        });
      }).catchError((e) {});
    }

    if (type == 1) {
      sendOffer();

      // Navigator.pop(context);
    } else {
      // uploadFile();
    }
  }

  sendOffer() async {
    try {
      // loadinsg = true;
//http://80.211.24.15/api/addOrderBill/orderId&1406billValue&2
      var response = await Dio().get(APIKeys.BASE_URL +
          'addOrderBill/orderId&${widget.orderId}billValue&$price');

      var data = response.data;
      isLoading = false;

      if (data['State'] == 'sucess') {
        sendNoti(userName, userName);

        // Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "successed".tr(),
            //toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            //timeInSecForIos: 1,
            backgroundColor: Colors.white,
            textColor: Color(0xff34C961),
            fontSize: 15.0);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
      setState(() {});
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

  Future<void> sendNoti(dataTit, notiTit) async {
    try {
      // loadinsg = true;

      print(
          'http://80.211.24.15/api/fire/userId&$peerId/title&$notiTit/body&فاتورةdatatitle&$dataTit/databody&فاتورة');
      var response = await Dio().get(
          '${APIKeys.Noti_URL}userId&$peerId/title&$notiTit/body&فاتورةdatatitle&$dataTit/databody&فاتورة');

      print(response.data);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: new AppBar(
            backgroundColor: Color(0xff34C961),
            title: new Text(
              'Recipt'.tr(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (_price.text == "") {
                      Fluttertoast.showToast(msg: 'insertAmount'.tr());
                    } else if (reciprtimg == null) {
                      Fluttertoast.showToast(msg: 'enterReciprImage'.tr());
                    } else {
                      isLoading = true;
                      setState(() {});
                      onSendMessage(0);
                    }
                  },
                  child: Text(
                    'send'.tr(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
            ]),
        body: Center(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        height: 50,
                        child: TextField(
                            decoration: new InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 0.0),
                              ),
                              border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              hintText: 'insertAmount'.tr(),
                              alignLabelWithHint: true,
                            ),
                            textAlign: TextAlign.right,
                            focusNode: null,
                            textInputAction: TextInputAction.done,
                            controller: _price,
                            keyboardType: TextInputType.number),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                              color: Colors.grey.withOpacity(.25), width: 2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              'deliveryAmount'.tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: null,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Text(
                                  "sr".tr(),
                                  style: TextStyle(
                                      color: Color(0xff34C961),
                                      fontSize: 12,
                                      fontFamily: null,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: Text(
                                  price.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: null,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                              color: Colors.grey.withOpacity(.25), width: 2)),
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 25.0),
                            child: Text(
                              _price.text != ""
                                  ? (price + int.parse(_price.text.toString()))
                                      .toString()
                                  : price.toString(),
                              style: TextStyle(
                                  color: Color(0xff34C961),
                                  fontSize: 13,
                                  fontFamily: null,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Text(
                              "total".tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: null,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (reciprtimg == null) {
                          reciprtimg = await ImagePicker.pickImage(
                              source: ImageSource.camera, imageQuality: 50);
                          setState(() {});
                        }
                      },
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 3),
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                                child: Container(

                                    // margin: EdgeInsets.only(left: 0, top: 8),
                                    width: 300,
                                    height: 100,
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: Colors.grey),
                                      // shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: reciprtimg == null
                                        ? Icon(Icons.camera)
                                        : Image.file(
                                            reciprtimg,
                                            fit: BoxFit.fill,
                                          )),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 70,
                            // right: ,
                            child: reciprtimg != null
                                ? GestureDetector(
                                    onTap: () async {
                                      reciprtimg = await ImagePicker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 50);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 5, color: Colors.white),
                                          color: Color(0xff34C961),
                                          shape: BoxShape.circle),
                                      child: Center(
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
