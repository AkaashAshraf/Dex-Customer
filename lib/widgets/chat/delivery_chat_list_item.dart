import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/chat/delivery_chat_list_item.dart';
import 'package:customers/pages/orders/chat.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class DeliveryChat extends StatelessWidget {
  final DeliveryChatListItem deliveryChatListItem;

  DeliveryChat({
    this.deliveryChatListItem,
  });
  @override
  Widget build(BuildContext context) {
    return ContainerResponsive(
      height: 120,
      padding: EdgeInsetsResponsive.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                blurRadius: 5,
                offset: Offset.fromDirection(1.5, 5))
          ]),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () {
          var to = deliveryChatListItem.threadId.toString();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        from: 'list',
                        targetImage: deliveryChatListItem.image.toString(),
                        to: to,
                        targetName: deliveryChatListItem.name.toString(),
                        orderId: deliveryChatListItem.threadId.toString(),
                        targetId: deliveryChatListItem.target,
                      )));
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                        deliveryChatListItem.image.toString() ??
                    '',
                placeholder: (context, url) => ImageLoad(20.0),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/Dex.png'),
                width: 70,
                height: 70,
              ),
              SizedBoxResponsive(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(deliveryChatListItem.name.toString()),
                  SizedBoxResponsive(height: 20),
                  Text(
                    deliveryChatListItem.body.toString() == 'new messge body' ? 'newMessgeBody'.tr() : deliveryChatListItem.body.toString(),
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fixTime(
                      DateTime.parse(deliveryChatListItem.createdAt), context),
                  textAlign: TextAlign.center,
                ),
                SizedBoxResponsive(height: 20),
                Text(fixDate(DateTime.parse(deliveryChatListItem.createdAt)))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  String fixDate(DateTime time) {
    var month = time.month;
    var year = time.year;
    var day = time.day;
    return "$year/$month/$day";
  }

  String fixTime(DateTime time, BuildContext context) {
    var hour;
    var minute = time.minute;
    var amPm;
    var loginPhone = '+968';
    if (loginPhone != null) {
      if (loginPhone.substring(0, 4) == '+249') {
        hour = time.hour + 2;
        hour >= 12 ? amPm = 'PM' : amPm = 'AM';
      } else if (loginPhone.substring(0, 4) == '+966') {
        hour = time.hour + 3;
        hour >= 12 ? amPm = 'PM' : amPm = 'AM';
      } else if (loginPhone.substring(0, 4) == '+968') {
        hour = time.hour + 4;
        hour >= 12 ? amPm = 'PM' : amPm = 'AM';
        hour == 24 ? hour = 0 : hour = hour;
      }
      if (context.locale == Locale('en')) {
        return '$hour:$minute $amPm';
      } else {
        return '$amPm $hour:$minute';
      }
    } else {
      return '${time.hour}:${time.minute}';
    }
  }
}
