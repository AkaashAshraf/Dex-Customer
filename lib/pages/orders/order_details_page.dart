import 'dart:async';
import 'dart:developer';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/models/orders/cart_products.dart';
import 'package:customers/pages/orders/chat.dart';
import 'package:customers/pages/orders/map_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/orders/order_details_provider.dart';
import 'package:customers/providers/orders/order_providors.dart';
import 'package:customers/providers/orders/rate_provider.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/utils/permission_status.dart';
import 'package:customers/utils/show_notification.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:customers/widgets/orders/cancel.dart';
import 'package:customers/widgets/orders/driver_card.dart';
import 'package:customers/widgets/orders/logstic_card.dart';
import 'package:customers/widgets/orders/order_details_cart_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class OrderDetails extends StatefulWidget {
  final DeliveryHistory order;

  OrderDetails({this.order});

  @override
  _OrderDetailsState createState() => _OrderDetailsState(order);
}

class _OrderDetailsState extends State<OrderDetails>
    with WidgetsBindingObserver {
  DeliveryHistory order;

  _OrderDetailsState(this.order);
  var _isClientVisible = false;

  var _showOrderDetails = false;
  var _showoffers = false;
  var _isOrederVisible = false;
  ProgressDialog pr;
  var _showClientDetails = false;

  var loading = false;

  //after new strucutre
  Timer t;
  bool ondetails = false;

  @override
  Widget build(BuildContext context) {
    log('total' +(order.orderInfo.totalValue ?? 0.0).toString() +
        ' VAT '+(vat * order.orderInfo.totalValue).toString() +
        'tex'+ totalTax.toString() +
        'price'+order.deliveryPrice.toString());
    ResponsiveWidgets.init(
      context,
      height: 1560, // Optional
      width: 720, // Optional
      allowFontScaling: true, // Optional
    );
    pr = ProgressDialog(context, isDismissible: false);
    pr.style(
        message: 'sending'.tr(),
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Consumer<RateProvider>(
      builder: (context, rate, _) {
        return Consumer<CartProvider>(builder: (context, cartProvider, _) {
          if (cartProvider.cartItems != null) {
            if (cartProvider.cartCounter != null) {
              return ConnectivityWidgetWrapper(
                message:
                    'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
                child: Scaffold(
                  appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      title: TextResponsive(
                        'orderDetails'.tr(),
                        style: TextStyle(
                          fontSize: 45,
                          color: Colors.black,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      actions: [
                        IconButton(
                            icon: Icon(Icons.chat, color: Colors.black),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Chat(
                                        status: order.state,
                                        orderId: order.id.toString(),
                                        targetId: order.orderInfo.shopInfo.id
                                            .toString(),
                                        targetName: order
                                            .orderInfo.shopInfo.name
                                            .toString(),
                                        to: 'provider',
                                        targetPrise: order.orderInfo.totalValue
                                            .toString(),
                                        targetImage: order
                                            .orderInfo.shopInfo.image
                                            .toString(),
                                      )));
                            })
                      ]),
                  body: loading
                      ? Center(child: Load(150.0))
                      : ListView(
                          children: [
                            ResponsiveWidgets.builder(
                              height: 1560, // Optional
                              width: 720, // Optional
                              allowFontScaling: true, // Optional
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    SizedBoxResponsive(
                                      height: 20,
                                    ),
                                    order.nearbyorder != 'yes'
                                        ? ContainerResponsive(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBoxResponsive(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: [
                                                        ContainerResponsive(
                                                          widthResponsive: true,
                                                          heightResponsive:
                                                              true,
                                                          width: 35,
                                                          height: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black26),
                                                              color:
                                                                  Colors.black,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 17,
                                                          )),
                                                        ),
                                                        SizedBoxResponsive(
                                                            width: 10),
                                                        TextResponsive(
                                                          'orderSent',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                    ContainerResponsive(
                                                      width: 35,
                                                      child: Column(
                                                        children: <Widget>[
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBoxResponsive(
                                                            height: 5,
                                                          ),
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: Colors.black,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        ContainerResponsive(
                                                          widthResponsive: true,
                                                          heightResponsive:
                                                              true,
                                                          width: 35,
                                                          height: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black26),
                                                              color: stateId >=
                                                                      2
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 17,
                                                          )),
                                                        ),
                                                        SizedBoxResponsive(
                                                            width: 10),
                                                        TextResponsive(
                                                          'prepairingOrder',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                    ContainerResponsive(
                                                      width: 35,
                                                      child: Column(
                                                        children: <Widget>[
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: stateId >= 2
                                                                ? Colors.black
                                                                : Colors.grey,
                                                          ),
                                                          SizedBoxResponsive(
                                                            height: 5,
                                                          ),
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: stateId >= 2
                                                                ? Colors.black
                                                                : Colors.grey,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        ContainerResponsive(
                                                          widthResponsive: true,
                                                          heightResponsive:
                                                              true,
                                                          width: 35,
                                                          height: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black26),
                                                              color: stateId >=
                                                                      3
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 17,
                                                          )),
                                                        ),
                                                        SizedBoxResponsive(
                                                            width: 10),
                                                        TextResponsive(
                                                          'orderSentCommissioner',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                    ContainerResponsive(
                                                      width: 35,
                                                      child: Column(
                                                        children: <Widget>[
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: stateId >= 3
                                                                ? Colors.black
                                                                : Colors.grey,
                                                          ),
                                                          SizedBoxResponsive(
                                                            height: 5,
                                                          ),
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: stateId >= 3
                                                                ? Colors.black
                                                                : Colors.grey,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        ContainerResponsive(
                                                          widthResponsive: true,
                                                          heightResponsive:
                                                              true,
                                                          width: 35,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black26,
                                                                  ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: oStateId >=
                                                                          4
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                            size: 17,
                                                          )),
                                                        ),
                                                        SizedBoxResponsive(
                                                            width: 10),
                                                        TextResponsive(
                                                          'deliveringOrder',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                    ContainerResponsive(
                                                      width: 35,
                                                      child: Column(
                                                        children: <Widget>[
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: oStateId >= 4
                                                                ? Colors.black
                                                                : Colors.grey,
                                                          ),
                                                          SizedBoxResponsive(
                                                            height: 5,
                                                          ),
                                                          ContainerResponsive(
                                                            widthResponsive:
                                                                true,
                                                            heightResponsive:
                                                                true,
                                                            width: 1,
                                                            height: 11,
                                                            color: oStateId >= 4
                                                                ? Colors.black
                                                                : Colors.grey,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        ContainerResponsive(
                                                          widthResponsive: true,
                                                          heightResponsive:
                                                              true,
                                                          width: 35,
                                                          height: 35,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .black26),
                                                              color: oStateId >=
                                                                      5
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
                                                              size: 17,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBoxResponsive(
                                                            width: 10),
                                                        TextResponsive(
                                                          'orderHanded',
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ).tr(),
                                                      ],
                                                    ),
                                                    SizedBoxResponsive(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : order.nearByShopName != null
                                            ? Container()
                                            : ContainerResponsive(
                                                widthResponsive: true,
                                                heightResponsive: true,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    ContainerResponsive(
                                                      margin:
                                                          EdgeInsetsResponsive
                                                              .only(
                                                                  top: 10,
                                                                  right: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          SizedBoxResponsive(
                                                            height: 35,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        SizedBoxResponsive(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          children: [
                                                            TextResponsive(
                                                              'lookingCommisssioner',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ).tr(),
                                                            SizedBoxResponsive(
                                                              width: 10,
                                                            ),
                                                            ContainerResponsive(
                                                              widthResponsive:
                                                                  true,
                                                              heightResponsive:
                                                                  true,
                                                              width: 35,
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black26),
                                                                  color: Colors
                                                                      .black,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: Center(
                                                                  child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                        ContainerResponsive(
                                                          width: 35,
                                                          child: Column(
                                                            children: <Widget>[
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              SizedBoxResponsive(
                                                                height: 5,
                                                              ),
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            TextResponsive(
                                                              'commissionerStore',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ).tr(),
                                                            SizedBoxResponsive(
                                                              width: 10,
                                                            ),
                                                            ContainerResponsive(
                                                              widthResponsive:
                                                                  true,
                                                              heightResponsive:
                                                                  true,
                                                              width: 35,
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black26),
                                                                  color: oStateId >=
                                                                          2
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: Center(
                                                                  child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                        ContainerResponsive(
                                                          width: 35,
                                                          child: Column(
                                                            children: <Widget>[
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: oStateId >= 2
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                              SizedBoxResponsive(
                                                                height: 5,
                                                              ),
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: oStateId >= 2
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            TextResponsive(
                                                              'commissionerYou',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ).tr(),
                                                            SizedBoxResponsive(
                                                              width: 10,
                                                            ),
                                                            ContainerResponsive(
                                                              widthResponsive:
                                                                  true,
                                                              heightResponsive:
                                                                  true,
                                                              width: 35,
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black26),
                                                                  color: oStateId >=
                                                                          3
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: Center(
                                                                  child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                        ContainerResponsive(
                                                          width: 35,
                                                          child: Column(
                                                            children: <Widget>[
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: oStateId >= 3
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                              SizedBoxResponsive(
                                                                height: 5,
                                                              ),
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: oStateId >= 3
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            TextResponsive(
                                                              'commissionerArrived',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ).tr(),
                                                            SizedBoxResponsive(
                                                              width: 10,
                                                            ),
                                                            ContainerResponsive(
                                                              widthResponsive:
                                                                  true,
                                                              heightResponsive:
                                                                  true,
                                                              width: 35,
                                                              height: 35,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        width:
                                                                            1,
                                                                        color: Colors
                                                                            .black26,
                                                                      ),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: oStateId >= 4
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .white),
                                                              child: Center(
                                                                  child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                        ContainerResponsive(
                                                          width: 35,
                                                          child: Column(
                                                            children: <Widget>[
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: oStateId >= 4
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                              SizedBoxResponsive(
                                                                height: 5,
                                                              ),
                                                              ContainerResponsive(
                                                                widthResponsive:
                                                                    true,
                                                                heightResponsive:
                                                                    true,
                                                                width: 1,
                                                                height: 11,
                                                                color: oStateId >= 4
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            TextResponsive(
                                                              'orderDelivered',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ).tr(),
                                                            SizedBoxResponsive(
                                                              width: 10,
                                                            ),
                                                            ContainerResponsive(
                                                              widthResponsive:
                                                                  true,
                                                              heightResponsive:
                                                                  true,
                                                              width: 35,
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black26),
                                                                  color: oStateId >=
                                                                          5
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: Center(
                                                                  child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBoxResponsive(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                    SizedBoxResponsive(height: 20),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showOrderDetails
                                              ? _showOrderDetails = false
                                              : _showOrderDetails = true;
                                          _isOrederVisible
                                              ? _isOrederVisible = false
                                              : _isOrederVisible = true;
                                        });
                                      },
                                      child: ContainerResponsive(
                                          widthResponsive: true,
                                          heightResponsive: true,
                                          height: 80,
                                          color: Color(0xffeeeeee),
                                          child: ContainerResponsive(
                                            padding:
                                                EdgeInsetsResponsive.symmetric(
                                                    horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                ContainerResponsive(
                                                  child: TextResponsive(
                                                    'orderDetails',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ).tr(),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                    Visibility(
                                      visible: true,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBoxResponsive(
                                            height: 20,
                                          ),
                                          TextResponsive("${'products'.tr()}",
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                              )),
                                          SizedBoxResponsive(
                                            height: 5,
                                          ),
                                          order.logsticTripId != null
                                              ? LogsticCard(
                                                  order: order,
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(
                                                      parent:
                                                          NeverScrollableScrollPhysics()),
                                                  itemBuilder:
                                                      (context, index) {
                                                    List<CartProdcuts> childs =
                                                        [];
                                                    for (int i = 0;
                                                        i < children.length;
                                                        i++) {
                                                      if (children[i].parent ==
                                                          parents[index]
                                                              .productsId) {
                                                        childs.add(children[i]);
                                                      }
                                                    }
                                                    return ExpansionTile(
                                                      title:
                                                          OrderDetailsCartItem(
                                                        child: false,
                                                        cartProdcut:
                                                            parents[index],
                                                      ),
                                                      children: [
                                                        TextResponsive(
                                                          'adds'.tr(),
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBoxResponsive(
                                                            height: 10),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              childs.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return OrderDetailsCartItem(
                                                                child: true,
                                                                cartProdcut:
                                                                    childs[
                                                                        index]);
                                                          },
                                                        ),
                                                        SizedBoxResponsive(
                                                            height: 10),
                                                      ],
                                                    );
                                                  },
                                                  itemCount: parents.length,
                                                ),
                                          SizedBoxResponsive(height: 10),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(
                                                      vertical: 10,
                                                      horizontal: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  TextResponsive(
                                                    'customerNote'.tr() + ' : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 23),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      // width:
                                                      // MediaQuery.of(context)
                                                      //         .size
                                                      //         .width -
                                                      //     135,
                                                      child: TextResponsive(
                                                        order.orderInfo.note
                                                            .toString(),
                                                        maxLines: null,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 23),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          SizedBoxResponsive(height: 30),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            color: Color(0xffF8F8F8),
                                            height: 80,
                                            child: ContainerResponsive(
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(horizontal: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  ContainerResponsive(
                                                      widthResponsive: true,
                                                      heightResponsive: true,
                                                      child: TextResponsive(
                                                        'totalCartItems',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ).tr()),
                                                  TextResponsive(
                                                      order.orderInfo
                                                          .cartProdcuts.length
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 30))
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBoxResponsive(
                                            height: 20,
                                          ),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            color: Color(0xffF8F8F8),
                                            height: 80,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                ContainerResponsive(
                                                    margin: EdgeInsetsResponsive
                                                        .symmetric(
                                                            horizontal: 30),
                                                    widthResponsive: true,
                                                    heightResponsive: true,
                                                    child: TextResponsive(
                                                      'paymentMethod',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ).tr())
                                              ],
                                            ),
                                          ),
                                          SizedBoxResponsive(
                                            height: 20,
                                          ),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                ContainerResponsive(
                                                    widthResponsive: true,
                                                    heightResponsive: true,
                                                    margin: EdgeInsetsResponsive
                                                        .symmetric(
                                                            horizontal: 30,
                                                            vertical: 10),
                                                    child: TextResponsive(
                                                      order.orderInfo.payment ==
                                                              1
                                                          ? 'payOnDelivery'
                                                          : 'onlinePayment',
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ).tr()),
                                              ],
                                            ),
                                          ),
                                          SizedBoxResponsive(
                                            height: 40,
                                          ),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            color: Color(0xffF8F8F8),
                                            height: 80,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                ContainerResponsive(
                                                    widthResponsive: true,
                                                    heightResponsive: true,
                                                    margin: EdgeInsetsResponsive
                                                        .symmetric(
                                                            horizontal: 30),
                                                    child: TextResponsive(
                                                      'handingDetails',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ).tr())
                                              ],
                                            ),
                                          ),
                                          SizedBoxResponsive(height: 30),
                                          ContainerResponsive(
                                            margin:
                                                EdgeInsetsResponsive.symmetric(
                                                    horizontal: 30),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MapSample(
                                                                    from:
                                                                        'details',
                                                                    order:
                                                                        order)));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        size: 13,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBoxResponsive(
                                                        width: 5,
                                                      ),
                                                      TextResponsive(
                                                          'viewLocation'.tr(),
                                                          style: TextStyle(
                                                              fontSize: 23,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                ),
                                                order.address == null
                                                    ? Container()
                                                    : TextResponsive(
                                                        order.address
                                                            .toString(),
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            fontSize: 23,
                                                            color:
                                                                Colors.black),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          SizedBoxResponsive(
                                            height: 40,
                                          ),
                                          order.driverInfo != null
                                              ? ContainerResponsive(
                                                  widthResponsive: true,
                                                  heightResponsive: true,
                                                  color: Color(0xffF8F8F8),
                                                  height: 80,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      ContainerResponsive(
                                                          widthResponsive: true,
                                                          heightResponsive:
                                                              true,
                                                          margin:
                                                              EdgeInsetsResponsive
                                                                  .symmetric(
                                                                      horizontal:
                                                                          30),
                                                          child: TextResponsive(
                                                            'commissionerDetails',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ).tr())
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          order.driverInfo != null
                                              ? ContainerResponsive(
                                                  padding: EdgeInsetsResponsive
                                                      .symmetric(
                                                          horizontal: 30),
                                                  child: DriverCard(
                                                    driver: order.driverInfo,
                                                    order: order,
                                                  ))
                                              : SizedBox(),
                                          SizedBoxResponsive(height: 30),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            color: Color(0xffF8F8F8),
                                            height: 80,
                                            child: ContainerResponsive(
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(horizontal: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  ContainerResponsive(
                                                      widthResponsive: true,
                                                      heightResponsive: true,
                                                      child: TextResponsive(
                                                        'totalTax',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ).tr()),
                                                  TextResponsive(
                                                      order.orderInfo
                                                                  .shopInfo ==
                                                              null
                                                          ? "0.0" +
                                                              " " +
                                                              "sr".tr()
                                                          : calcTax(
                                                                  order
                                                                          .orderInfo
                                                                          .shopInfo
                                                                          .taxOne *
                                                                      1.0,
                                                                  order
                                                                          .orderInfo
                                                                          .shopInfo
                                                                          .taxTwo *
                                                                      1.0,
                                                                  order.orderInfo
                                                                          .totalValue *
                                                                      1.0) +
                                                              ' ' +
                                                              'sr'.tr(),
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 25))
                                                ],
                                              ),
                                            ),
                                          ),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            color: Color(0xffF8F8F8),
                                            height: 80,
                                            child: ContainerResponsive(
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(horizontal: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  ContainerResponsive(
                                                      widthResponsive: true,
                                                      heightResponsive: true,
                                                      child: TextResponsive(
                                                        'deliveryPrice',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ).tr()),
                                                  TextResponsive(
                                                      order.deliveryPrice
                                                              .toStringAsFixed(
                                                                  3) +
                                                          ' ' +
                                                          'sr'.tr(),
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 25))
                                                ],
                                              ),
                                            ),
                                          ),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            color: Color(0xffF8F8F8),
                                            height: 80,
                                            child: ContainerResponsive(
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(horizontal: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  ContainerResponsive(
                                                      widthResponsive: true,
                                                      heightResponsive: true,
                                                      child: TextResponsive(
                                                        'VAT',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ).tr()),
                                                  TextResponsive(
                                                      '${((vat * order.orderInfo.totalValue)).toStringAsFixed(3)} ' +
                                                          'sr'.tr(),
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 25))
                                                ],
                                              ),
                                            ),
                                          ),
                                          ContainerResponsive(
                                            widthResponsive: true,
                                            heightResponsive: true,
                                            color: Color(0xffF8F8F8),
                                            height: 80,
                                            child: ContainerResponsive(
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(horizontal: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  ContainerResponsive(
                                                      widthResponsive: true,
                                                      heightResponsive: true,
                                                      child: TextResponsive(
                                                        'total',
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ).tr()),
                                                  TextResponsive(
                                                      ((order.orderInfo.totalValue ??
                                                                      0.0) +
                                                                  (vat *
                                                                      order
                                                                          .orderInfo
                                                                          .totalValue) +
                                                                  totalTax +
                                                                  order
                                                                      .deliveryPrice)
                                                              .toStringAsFixed(
                                                                  3) +
                                                          ' ' +
                                                          'sr'.tr(),
                                                      style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .secondaryHeaderColor,
                                                          fontSize: 25))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsetsResponsive.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  order.state.toString() == '6' ||
                                          order.state.toString() == '0'
                                      ? ContainerResponsive()
                                      : order.state.toString() == '5'
                                          ? GestureDetector(
                                              onTap: () async {
                                                // ignore: unused_local_variable
                                                await rate.showRate(
                                                    context, order.id, order);
                                                if (rate.rated) {
                                                  setState(() {
                                                    order = rate.orderDetails;
                                                    rate.falseRate();
                                                  });
                                                }
                                              },
                                              child: ContainerResponsive(
                                                margin:
                                                    EdgeInsetsResponsive.only(
                                                        top: 10),
                                                widthResponsive: true,
                                                heightResponsive: true,
                                                width: 600,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.black),
                                                child: Center(
                                                    child: TextResponsive(
                                                  'Rate',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.white),
                                                )),
                                              ),
                                            )
                                          : oStateId < 2
                                              ? ConnectivityWidgetWrapper(
                                                  stacked: false,
                                                  offlineWidget:
                                                      ContainerResponsive(
                                                          margin:
                                                              EdgeInsetsResponsive
                                                                  .only(
                                                                      top: 10),
                                                          widthResponsive: true,
                                                          heightResponsive:
                                                              true,
                                                          width: 600,
                                                          height: 70,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Colors
                                                                  .grey[500]),
                                                          child: Center(
                                                            child:
                                                                TextResponsive(
                                                              'في إنتظار الإنترنت',
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Cancel(
                                                                        order:
                                                                            order,
                                                                      )));
                                                    },
                                                    child: ContainerResponsive(
                                                      widthResponsive: true,
                                                      heightResponsive: true,
                                                      width: 600,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black),
                                                      child: Center(
                                                          child: TextResponsive(
                                                        'cancelOrder',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ).tr()),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              );
            }
            return Center(
              child: Text('لا توجد عناصر'),
            );
          }
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor),
          );
        });
      },
    );
  }

  int stateId;
  int oStateId;

  void noti() {
    if (ondetails) {
      FirebaseMessaging.onMessage.listen((message) async {
        print('on message $message ');
        setState(() {
          loading = true;
        });
        _loadOrders();
        await Provider.of<OrderDetailsProvider>(context, listen: false)
            .getDilveryDriversOffers(orderId: order.id.toString());
        await Provider.of<OrderDetailsProvider>(context, listen: false)
            .getOrderDetails(deliveryId: order.id.toString());
        order = Provider.of<OrderDetailsProvider>(context, listen: false)
            .orderDetails;
        oStateId =
            Provider.of<OrderDetailsProvider>(context, listen: false).oStateId;
        stateId =
            Provider.of<OrderDetailsProvider>(context, listen: false).stateId;
        setState(() {
          loading = false;
        });
        print(
            'order state is ${Provider.of<OrderDetailsProvider>(context, listen: false).oStateId}');
        loading = false;
        print('on message $message ');
        dynamic notification = message.notification;
        dynamic data = message.data;
        dynamic notificationtitle = notification['title'].toString();
        dynamic notificationbody = notification['body'].toString();
        var orderid = data['text'];
        if (orderid == order.id.toString()) {
          if (data['title'] == ' offer') {
            Provider.of<OrderDetailsProvider>(context, listen: false)
                .getDilveryDriversOffers(orderId: order.id.toString());
            Fluttertoast.showToast(
                msg: 'newOrder'.tr(),
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.white,
                textColor: Colors.green[500],
                fontSize: 15.0);
          } else if (data['title'] == 'changeState') {
            Provider.of<OrderDetailsProvider>(context, listen: false)
                .getDilveryDriversOffers(orderId: order.id.toString());
            if (order.state.toString() == '0') {
              Fluttertoast.showToast(
                  msg: 'orderCancelled'.tr(),
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.white,
                  textColor: Colors.grey[500],
                  fontSize: 15.0);
            } else {
              Fluttertoast.showToast(
                  msg: 'orderUpdated'.tr(),
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.white,
                  textColor: Colors.green[500],
                  fontSize: 15.0);
            }
          }
        }
        if (notification['title'] != null) {
          await showNotification(notificationtitle, notificationbody);
        }
      });
    }
  }

  Future<void> _loadOrders() async {
    await Provider.of<OrdersProvider>(context, listen: false).getOrders();
  }

  String driverName() {
    try {
      return order.driverInfo.firstName.toString();
    } catch (e) {
      return 'Unkown';
    }
  }

  AppLifecycleState _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _notification = state;
    });
    if (state.toString() == "AppLifecycleState.resumed") {
      setState(() {
        loading = true;
      });
      _loadOrders();
      await Provider.of<OrderDetailsProvider>(context, listen: false)
          .getDilveryDriversOffers(orderId: order.id.toString());
      await Provider.of<OrderDetailsProvider>(context, listen: false)
          .getOrderDetails(deliveryId: order.id.toString());
      order = Provider.of<OrderDetailsProvider>(context, listen: false)
          .orderDetails;
      oStateId =
          Provider.of<OrderDetailsProvider>(context, listen: false).oStateId;
      stateId =
          Provider.of<OrderDetailsProvider>(context, listen: false).stateId;
      print('======');
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    ondetails = false;
    WidgetsBinding.instance.removeObserver(this);
    if (t != null) {
      t.cancel();
    }
  }

  LocationData loc;
  Future getLocation() async {
    setState(() {
      loading = true;
    });
    var location = Location();
    try {
      loc = await location.getLocation();
      Provider.of<LongLatProvider>(context, listen: false)
          .setLoc(lat: loc.latitude, long: loc.longitude);
      setState(() {
        loading = false;
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
        print(error);
      }
      loc = null;
      setState(() {
        loading = false;
      });
    }
  }

  List<CartProdcuts> parents = [];
  List<CartProdcuts> children = [];
  double totalTax = 0.0;

  String calcTax(double tax1, double tax2, double totalPrice) {
    var tax = 0.0;
    tax = (totalPrice * (tax1 + tax2));
    totalTax = tax;
    return tax.toStringAsFixed(3);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // fromDetails = true;

    ondetails = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadOrders();
      Provider.of<OrderDetailsProvider>(context, listen: false)
          .getDilveryDriversOffers(orderId: order.id.toString());
      await Provider.of<OrderDetailsProvider>(context, listen: false)
          .getOrderDetails(deliveryId: order.id.toString());
      noti();
    });
    Provider.of<PermissionsProvider>(context, listen: false).checkStatus();
    filterOrder(order);
    stateId = int.parse(order.orderInfo.state).toInt();
    oStateId = int.parse(order.state).toInt();
  }

  void filterOrder(DeliveryHistory order) {
    for (int o = 0; o < order.orderInfo.cartProdcuts.length; o++) {
      if (order.orderInfo.cartProdcuts[o].parent == 0) {
        parents.add(order.orderInfo.cartProdcuts[o]);
      } else {
        children.add(order.orderInfo.cartProdcuts[o]);
      }
    }
  }
}
