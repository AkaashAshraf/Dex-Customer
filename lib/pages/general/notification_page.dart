import 'dart:developer';

import 'package:customers/models/notifications.dart';
import 'package:customers/models/user.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class NotificationPage extends StatefulWidget {
  final id;

  const NotificationPage({Key key, this.id}) : super(key: key);
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notifications> notifications;
  var loading;

  Widget notificationLoad() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          /////////// Header
          // SizedBox(
          //   height: 40,
          //   child: SizedBox(
          //     height: 40,
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 25),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: <Widget>[
          //           Text(
          //             'notifications'.tr(),
          //             style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          SizedBox(
            height: 40,
          ),
          Load(200.0)
        ],
      ),
    );
  }

  Future getNotifications() async {
    try {
      loading = true;
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getNotifications/${widget.id}');
      log('notificationURl: ' +
          APIKeys.BASE_URL +
          'getNotifications/${widget.id}');

      var data = response.data;
      var shops = data as List;

      notifications = shops
          .map<Notifications>((json) => Notifications.fromJson(json))
          .toList();
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      print(notifications.length);
    } on DioError catch (error) {
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
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    Widget _notificationCard(int index) {
      return Container(
          child: Stack(children: <Widget>[
        Container(
            height: 65,
            width: MediaQuery.of(context).size.width * 90,
            margin: EdgeInsets.only(left: 20, right: 20, top: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffF0F0F0), width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffF2F2F2), width: 3),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: notifications[index].image != null
                              ? NetworkImage(APIKeys.ONLINE_IMAGE_BASE_URL +
                                  notifications[index].image.toString())
                              : AssetImage('images/image404.png'))),
                ),
                SizedBoxResponsive(width: 20),
                Text(
                  _notiTitle(notifications[index]
                      .title
                      .toString()), //! add notification title logic
                  style: TextStyle(fontSize: 15),
                ),
              ],
            )),
        Positioned(
          top: 0,
          right: 14,
          child: Visibility(
            visible: index == 0 ? true : false,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ]));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: ConnectivityWidgetWrapper(
          child: loading
              ? notificationLoad()
              : Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),

                    /////////// Header
                    SizedBox(
                      height: 40,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: context.locale.toString() != 'en'
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.arrow_back,
                                  color: Colors.black, size: 25),
                            ),
                            SizedBoxResponsive(width: 10),
                            Text(
                              'notifications'.tr(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: notifications.isEmpty
                          ? Column(
                              children: <Widget>[
                                Image.asset('images/emptycart.PNG'),
                                Text(
                                  'noNotification',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ).tr(),
                              ],
                            )
                          : ListView.builder(
                              itemBuilder: (context, index) =>
                                  _notificationCard(index),
                              itemCount: notifications.length,
                            ),
                    ),
                  ],
                ),
        ));
  }

  String _notiTitle(String title) {
      return title.contains('تم قبول الطلب')
        ? title.replaceAll('تم قبول الطلب', 'orderAccepted'.tr())
        : title.contains('Order Accepted')
            ? title.replaceAll('Order Accepted', 'orderAccepted'.tr())
            : title.contains('تحديث من')
                ? title.replaceAll('تحديث من', 'updateFrom'.tr())
                : title.contains('Update From')
                    ? title.replaceAll('تحديث من', 'updateFrom'.tr())
                    : title.contains('Message')
                        ? title.replaceAll('Message', 'message'.tr())
                        : title.contains('رسالة')
                            ? title.replaceAll('رسالة', 'message'.tr())
                            : title.contains('صورة')
                                ? title.replaceAll('صورة', 'img'.tr())
                                : title.contains('Image')
                                    ? title.replaceAll('Image', 'img'.tr())
                                    : title.contains('تم قبول الطلب من')
                                        ? title.replaceAll('تم قبول الطلب من',
                                            'requestAcceptedFrom'.tr())
                                        : title.contains('تم تحديث الطلب')
                                            ? title.replaceAll('تم تحديث الطلب',
                                                'theRequestHasBeenUpdated'.tr())
                                            : title.contains('noti title')
                                                ? title.replaceAll(
                                                    'noti title', 'test'.tr())
                                                : title;
  }
}
