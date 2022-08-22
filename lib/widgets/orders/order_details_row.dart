import 'package:customers/models/delivery_history.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderDetailsRow extends StatelessWidget {
  final DeliveryHistory order;
  OrderDetailsRow({this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => OrderDetails(order: order,)));
      },
      child: ContainerResponsive(
        widthResponsive: true,
        heightResponsive: true,
        margin: EdgeInsets.only(right: 120, left: 20),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              ContainerResponsive(
                widthResponsive: true,
                heightResponsive: true,
                width: 160,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: TextResponsive(
                      'orderNumber',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold),
                    ).tr()),
                    Center(
                        child: Padding(
                      padding: EdgeInsetsResponsive.all(4.0),
                      child: TextResponsive(
                        order.orderInfo.id.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ))
                  ],
                ),
              ),
              ContainerResponsive(
                margin: EdgeInsetsResponsive.symmetric(vertical: 10),
                color: Colors.grey[300],
                width: 2,
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ContainerResponsive(
                  widthResponsive: true,
                  heightResponsive: true,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ContainerResponsive(
                          widthResponsive: true,
                          heightResponsive: true,
                          child: shopName()),
                      SizedBoxResponsive(
                        height: 5,
                      ),
                      ContainerResponsive(
                        widthResponsive: true,
                        heightResponsive: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextResponsive(
                              order.createdAt.replaceRange(
                                  9, order.createdAt.length - 1, ''),
                              style: TextStyle(
                                fontSize: 25,
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

  String shopname() {
    final text = order.nearbyorder == 'yes'
        ? order.nearByShopName
        : order.orderInfo.shopInfo.shopCity.name;
    return text;
  }

  TextResponsive shopName() {
    try {
      return TextResponsive(
        shopname(),
        style: TextStyle(
          fontSize: shopname().length > 30 ? 25 : 30,
          color: Colors.black,
        ),
        textAlign: TextAlign.right,
      );
    } catch (e) {
      return TextResponsive(
        'unkown',
        style: TextStyle(
          fontSize: 25,
          color: Colors.black,
        ),
        textAlign: TextAlign.right,
      );
    }
  }
}
