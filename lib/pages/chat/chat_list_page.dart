import 'dart:convert';
import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:customers/providers/chat/chat_provider.dart';
import 'package:customers/widgets/chat/delivery_chat_list_item.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String currentUserId;
  FirebaseMessaging firebaseMessaging;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).fetchDeliveryChats();
    });
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          !Provider.of<ChatProvider>(context, listen: false).loading1) {
        Provider.of<ChatProvider>(context, listen: false).fecthMoreThredas();
      }
    });
  }

  void registerNotification() {
    FirebaseMessaging.onMessage.listen((message) {
      print('onMessage: $message');
      showNotification(message.notification);
      return;
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chat, _) => SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: Icon(
                CommunityMaterialIcons.chat_outline,
                color: Colors.black,
              ),
              centerTitle: true,
              leading: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            body: chat.loading
                ? Center(child: Load(200.0))
                : Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Consumer<ChatProvider>(
                          builder: (context, provider, child) {
                            if (provider.deliveryChatListItem != null) {
                              if (provider.deliveryChatListItem.isNotEmpty) {
                                return ListView.builder(
                                  controller: controller,
                                  itemBuilder: (context, index) {
                                    return DeliveryChat(
                                      deliveryChatListItem:
                                          provider.deliveryChatListItem[index],
                                    );
                                  },
                                  itemCount:
                                      provider.deliveryChatListItem.length,
                                );
                              }
                              return Center(
                                child: Text('noChats'.tr()),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                      chat.loading1
                          ? Positioned(
                              bottom: 10,
                              child: Center(
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: CupertinoActivityIndicator()),
                              ))
                          : Container()
                    ],
                  )),
      ),
    );
  }
}
