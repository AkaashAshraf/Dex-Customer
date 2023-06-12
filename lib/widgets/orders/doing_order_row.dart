import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/pages/orders/order_details_page.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class DoingOrderRow extends StatelessWidget {
  final DeliveryHistory order;

  DoingOrderRow({this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetails(order: order)));
      },
      child: ContainerResponsive(
        height: 150,
        margin:
            EdgeInsetsResponsive.only(right: 20, left: 20, top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffF2F2F2)),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ContainerResponsive(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  SizedBoxResponsive(width: 5),
                  ContainerResponsive(
                    width: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: TextResponsive(
                            'orderNumber',
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                        SizedBoxResponsive(height: 10),
                        Center(
                            child: TextResponsive(
                          order.orderInfo?.id?.toString() ?? 'undefined',
                          style: TextStyle(fontSize: 23),
                        ))
                      ],
                    ),
                  ),
                  SizedBoxResponsive(width: 5),
                  ContainerResponsive(
                    margin: EdgeInsetsResponsive.symmetric(vertical: 10),
                    width: 2,
                    color: Colors.grey[300],
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsetsResponsive.only(right: 15,left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(child: shopName()),
                      SizedBoxResponsive(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextResponsive(
                              order.orderInfo?.createdAt ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  dynamic shopImage() {
    try {
      return CachedNetworkImage(
        imageUrl: order.nearbyorder != null
            ? order.nearByShopImg
            : order.orderInfo.shopInfo != null
                ? APIKeys.ONLINE_IMAGE_BASE_URL +
                        order.orderInfo?.shopInfo?.image ??
                    ''
                : '',
        fit: BoxFit.fill,
        placeholder: (context, url) => ImageLoad(100.0),
        errorWidget: (context, url, error) => Image.asset(
          'images/image404.png',
          width: 90,
          height: 90,
        ),
      );
    } catch (e) {
      return Image.asset(
        'images/image404.png',
        width: 90,
        height: 90,
      );
    }
  }

  String shopname() {
    final text = order.logsticTripId != null
        ? "logsticOrder".tr()
        : order.orderInfo.shopInfo.name;
    return text;
  }

  TextResponsive shopName() {
    try {
      return TextResponsive(
        shopname(),
        style: TextStyle(
          fontSize: shopname().length > 30 ? 25 : 30,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        textAlign: TextAlign.right,
      );
    } catch (e) {
      return TextResponsive(
        'unkown',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        textAlign: TextAlign.right,
      );
    }
  }
}
