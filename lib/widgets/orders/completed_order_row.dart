import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/pages/orders/order_details_page.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class CompletedOrderRow extends StatefulWidget {
  final DeliveryHistory deliveryHistory;

  CompletedOrderRow({this.deliveryHistory});

  @override
  _CompletedOrderRowState createState() => _CompletedOrderRowState();
}

class _CompletedOrderRowState extends State<CompletedOrderRow> {
  String price({double total, double tax, double delivery}) {
    return ((total  * vat) + (total + tax + delivery )).toStringAsFixed(2);
  }

  double tax(double taxOne, double taxTwo, double total) {
    return ((taxOne + taxTwo) * total);
  }

  double total(DeliveryHistory deliveryHistory) {
    var _total = 0.0;
    for (var i = 0; i < deliveryHistory.orderInfo.cartProdcuts.length; i++) {
      _total += deliveryHistory.orderInfo.cartProdcuts[i].price *
          deliveryHistory.orderInfo.cartProdcuts[i].quantity *
          1.0;
    }
    return _total;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderDetails(order: widget.deliveryHistory)));
        },
        child: ContainerResponsive(
          height: 250,
          margin: EdgeInsetsResponsive.symmetric(horizontal: 30, vertical: 20),
          padding: EdgeInsetsResponsive.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContainerResponsive(
                padding: EdgeInsetsResponsive.symmetric(horizontal: 20),
                width: 150,
                height: 150,
                child: CachedNetworkImage(
                  width: 100,
                  height: 100,
                  imageUrl: widget.deliveryHistory.nearbyorder == 'yes'
                      ? APIKeys.ONLINE_IMAGE_BASE_URL +
                          widget.deliveryHistory.nearByShopImg.toString()
                      : APIKeys.ONLINE_IMAGE_BASE_URL +
                          widget.deliveryHistory.orderInfo?.shopInfo?.image
                              .toString(),
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(
                      child: Image.asset(
                    'images/loading.gif',
                    width: 55,
                    height: 55,
                  )),
                  errorWidget: (context, url, error) => Image.asset(
                    'images/image404.png',
                    width: 55,
                    height: 55,
                  ),
                ),
              ),
              ContainerResponsive(
                padding: EdgeInsetsResponsive.symmetric(
                    vertical: 20, horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextResponsive(
                        widget.deliveryHistory.nearbyorder == 'yes'
                            ? widget.deliveryHistory.nearByShopName.toString()
                            : context.locale == Locale('ar')
                                ? widget
                                    .deliveryHistory.orderInfo.shopInfo?.nameAr
                                    .toString()
                                : widget
                                    .deliveryHistory.orderInfo.shopInfo?.name
                                    .toString(),
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                    Row(
                      children: [
                        TextResponsive(
                            widget.deliveryHistory.nearbyorder == 'yes'
                                ? widget.deliveryHistory.deliveryPrice
                                    .toString()
                                : price(
                                    total: total(widget.deliveryHistory),
                                    delivery:
                                        widget.deliveryHistory.deliveryPrice *
                                            1.0,
                                    tax: tax(
                                        widget.deliveryHistory.orderInfo
                                                .shopInfo.taxOne *
                                            1.0,
                                        widget.deliveryHistory.orderInfo
                                                .shopInfo.taxTwo *
                                            1.0,
                                        widget.deliveryHistory.orderInfo
                                                .totalValue *
                                            1.0)),
                            style:
                                TextStyle(fontSize: 30, color: Colors.white)),
                        SizedBoxResponsive(width: 20),
                        TextResponsive('sr'.tr(),
                            style: TextStyle(fontSize: 30, color: Colors.white))
                      ],
                    ),
                    TextResponsive(
                        "orderNumber".tr() +
                            " : " +
                            widget.deliveryHistory.orderInfo.id.toString(),
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Container completeShopImaga() {
    try {
      return ContainerResponsive(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(right: 5),
          child: CachedNetworkImage(
            imageUrl: widget.deliveryHistory.nearbyorder != null
                ? widget.deliveryHistory.nearByShopImg
                : widget.deliveryHistory.orderInfo.shopInfo != null
                    ? APIKeys.ONLINE_IMAGE_BASE_URL +
                        widget.deliveryHistory.orderInfo.shopInfo?.image
                    : '',
            fit: BoxFit.fill,
            placeholder: (context, url) => ImageLoad(90.0),
            errorWidget: (context, url, error) => Image.asset(
              'images/image404.png',
              width: 90,
              height: 90,
            ),
          ));
    } catch (e) {
      return Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.only(right: 5),
        child: Image.asset(
          'images/image404.png',
          width: 90,
          height: 90,
        ),
      );
    }
  }

  Text completeShopName() {
    try {
      return Text(
        widget.deliveryHistory.nearbyorder == 'yes'
            ? widget.deliveryHistory.nearByShopName.toString()
            : widget.deliveryHistory.orderInfo.shopInfo.shopCity.name,
        style: TextStyle(
            fontSize: widget.deliveryHistory.orderInfo.shopInfo?.name
                        .toString()
                        .length >=
                    25
                ? 13
                : widget.deliveryHistory.orderInfo.shopInfo?.name
                            .toString()
                            .length >=
                        20
                    ? 15
                    : 17,
            color: Colors.black,
            fontWeight: FontWeight.w600),
        textAlign: TextAlign.right,
      );
    } catch (e) {
      return Text(
        'Unkown',
        style: TextStyle(
            fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
        textAlign: TextAlign.right,
      );
    }
  }
}
