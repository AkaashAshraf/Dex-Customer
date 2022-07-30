import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/message.dart';
import 'package:customers/providers/services/media_pick.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Chat extends StatefulWidget {
  final String from;
  final String status;
  final String to;
  final String orderId;
  final String targetId;
  final String targetPrise;
  final String targetName;
  final String targetImage;

  Chat(
      {this.status,
      this.orderId,
      this.targetId,
      this.targetName,
      this.targetImage,
      this.targetPrise,
      this.to,
      this.from});

  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  bool firstLoad = true;
  bool secondLoad = false;
  String id;
  ScrollController _scrollController = ScrollController();
  File imageFile;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    widget.from == 'list'
        ? id = widget.orderId
        : id = widget.to == 'driver'
            ? '${widget.orderId}' '3'
            : '${widget.orderId}' '1';

    noti();
    getMessages();
    print(widget.targetPrise);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.minScrollExtent &&
          isLoading != true) {
        getMessages();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actionsIconTheme: IconThemeData(color: Colors.white),
          title: Text(
            widget.targetName.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: null,
                fontWeight: FontWeight.bold),
          )),
      body: ConnectivityWidgetWrapper(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                firstLoad
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: LilLoad(200.0),
                              )
                            ],
                          ),
                        ),
                      )
                    : messages?.message?.isNotEmpty ?? false
                        ? Expanded(
                            child: Stack(
                              children: <Widget>[
                                ListView.builder(
                                  itemCount: messages.message.length,
                                  controller: _scrollController,
                                  itemBuilder: (context, index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: messages.message[index].senderId
                                                  .toString() !=
                                              userId
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: generateReceiverLayout(
                                                  messages.message[index]))
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: generateSenderLayout(
                                                  messages.message[index]))),
                                ),
                                secondLoad
                                    ? Center(child: LilLoad(80.0))
                                    : Container()
                              ],
                            ),
                          )
                        : Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.no_sim,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text("thereAreNoMessagesForThisConversation".tr()),
                                ],
                              ),
                            ),
                          ),
                Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
                Builder(builder: (BuildContext context) {
                  return Container(width: 0.0, height: 0.0);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> generateReceiverLayout(Message message) {
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(
                    APIKeys.ONLINE_IMAGE_BASE_URL + widget.targetImage),
              )),
        ],
      ),
      Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade200,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(widget.targetName.toString(),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: message.title == 'img'
                      ? InkWell(
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullScreenImage(
                                            APIKeys.ONLINE_IMAGE_BASE_URL +
                                                message.image)));
                              },
                              child: Hero(
                                tag: APIKeys.ONLINE_IMAGE_BASE_URL +
                                    message.image,
                                child: CachedNetworkImage(
                                  imageUrl: message.image != null
                                      ? APIKeys.ONLINE_IMAGE_BASE_URL +
                                          message.image
                                      : APIKeys.ONLINE_IMAGE_BASE_URL + '',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Center(child: ImageLoad(150.0)),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'images/image404.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ),
                            height: 500,
                            width: 250.0,
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            padding: EdgeInsets.all(5),
                          ),
                          onTap: () {},
                        )
                      : Container(
                          width: message.body != null
                              ? message.body.length > 50
                                  ? 300
                                  : null
                              : null,
                          child: message.body != null
                              ? Text(
                                  message.body.toString(),
                                  maxLines: 3,
                                )
                              : Container(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> generateSenderLayout(Message message) {
    return <Widget>[
      Material(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).secondaryHeaderColor,
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              message.title == 'img'
                  ? InkWell(
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl:
                              APIKeys.ONLINE_IMAGE_BASE_URL + message.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: ImageLoad(150.0)),
                          errorWidget: (context, url, error) => Image.asset(
                            'images/image404.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        height: 500,
                        width: 250.0,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        padding: EdgeInsets.all(5),
                      ),
                      onTap: () {},
                    )
                  : Container(
                      width: message.body?.length != null
                          ? message.body.length > 50
                              ? 300
                              : null
                          : null,
                      child: Text(
                        message.body.toString(),
                        maxLines: 4,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:
                    NetworkImage(APIKeys.ONLINE_IMAGE_BASE_URL + userImage),
              )),
        ],
      ),
    ];
  }

  Widget getDefaultSendButton() {
    return ConnectivityWidgetWrapper(
      stacked: false,
      offlineWidget: Icon(Icons.send, color: Colors.grey[500]),
      alignment: Alignment.topCenter,
      child: IconButton(
          icon: Icon(Icons.send,
              color: !isLoading ? Theme.of(context).primaryColor : Colors.grey),
          onPressed: !isLoading ? () => sendText(' text') : null,
          color: !isLoading ? Theme.of(context).primaryColor : Colors.grey),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(
          color: !isLoading ? Theme.of(context).primaryColor : Colors.grey,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Material(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  child: IconButton(
                      icon: Icon(
                        Icons.image,
                      ),
                      onPressed: () {
                        isLoading ? null : getImage();
                      },
                      color: !isLoading
                          ? Theme.of(context).primaryColor
                          : Colors.grey),
                ),
                color: Colors.white,
              ),
              Flexible(
                child: TextField(
                  textAlign: TextAlign.right,
                  controller: _textController,
                  onChanged: (String messageText) {},
                  decoration:
                      InputDecoration.collapsed(hintText: 'sendMessage'.tr()),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  void getImage() async {
    var pickedFile = await showDialog(
        context: context, builder: (context) => MediaPickDialog());
    if (pickedFile != null) {
      if (this.mounted) {
        setState(() {
          imageFile = pickedFile;
          if (imageFile != null) {
            sendText('img');
          }
        });
      }
    }
  }

  void sendText(type) async {
    var messageText = _textController.text;
    _textController.clear();
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      if (type == 'img') {
        FormData data = FormData.fromMap({
          'thread_id': '$id',
          'sender_id': userId.toString(),
          'target': widget.targetId,
          'title': type,
          'image': await MultipartFile.fromFile(imageFile.path,
              filename: DateTime.now().millisecondsSinceEpoch.toString()),
        });
        var response =
            await dioClient.post(APIKeys.BASE_URL + "addChatMessage", data: data);
        print(response.data);
        messages = Messages.fromJson(response.data);
        messages.message = messages.message.toSet().toList();
        nesxtPage = messages.nextPageUrl;
        messages.message = messages.message.reversed.toList();
        animateListview();
        sendNoti('msg', userName, '  صورة', userName);
      } else {
        if (messageText != '') {
          FormData data = FormData.fromMap({
            'thread_id': '$id',
            'sender_id': userId.toString(),
            'target': widget.targetId,
            'title': type,
            'body': messageText,
          });
          var response =
              await dioClient.post(APIKeys.BASE_URL + "addChatMessage", data: data);
          print(response.data);
          messages = Messages.fromJson(response.data);
          messages.message = messages.message.toSet().toList();
          nesxtPage = messages.nextPageUrl;
          messages.message = messages.message.reversed.toList();
          animateListview();
          _textController.clear();
          sendNoti('msg', userName, 'صورة', userName);
        } else {
          Fluttertoast.showToast(
            msg: 'writeMessageFirst'.tr(),
          );
        }
      }

      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (_) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void sendNoti(dataBody, dataTit, notiBody, notiTit) async {
    try {
      print(
          '${APIKeys.Noti_URL}userId&${widget.targetId}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
      var response = await dioClient.get(
          '${APIKeys.Noti_URL}userId&${widget.targetId}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');

      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  Future getMessages() async {
    try {
      if (firstLoad) {
        var response =
            await dioClient.get(APIKeys.BASE_URL + "getchatmessages&threadId=$id");
        print(response.data);
        messages = Messages.fromJson(response.data);
        messages.message = messages.message.toSet().toList();
        nesxtPage = messages.nextPageUrl;
        messages.message = messages.message.reversed.toList();
        animateListview();

        if (this.mounted) {
          setState(() {
            isLoading = false;
            firstLoad = false;
          });
        }
      } else if (nesxtPage != null) {
        secondLoad = true;
        isLoading = true;
        setState(() {});
        var response = await dioClient.get(nesxtPage);
        print(response.data);
        Messages newMessages = Messages.fromJson(response.data);
        nesxtPage = newMessages.nextPageUrl;
        newMessages.message = newMessages.message.reversed.toList();
        messages.message = newMessages.message + messages.message;
        messages.message = messages.message.toSet().toList();
        if (this.mounted) {
          setState(() {
            isLoading = false;
            secondLoad = false;
            firstLoad = false;
          });
        }
      }
      return messages;
    } catch (_) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
          secondLoad = false;
          firstLoad = false;
        });
      }
      print(_);
    }
  }

  animateListview() async {
    try {
      Future.delayed(Duration(milliseconds: 200), () async {
        await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut);
      });
    } catch (e) {
      print(e);
    }
  }

  void noti() {
    FirebaseMessaging.onMessage.listen((message) async {
      print('on message $message ');
      dynamic data = message.data;
      var msg = data['text'];

      if (msg == 'msg') {
        await getMessages();
      }
    });
  }
}

class FullScreenImage extends StatelessWidget {
  var image;

  FullScreenImage(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Hero(
          tag: image,
          child: Image.network(
            image,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
