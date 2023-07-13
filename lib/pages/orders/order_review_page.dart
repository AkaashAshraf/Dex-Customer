import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/models/orders/cart_products.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/pages/orders/open_location_page.dart';
import 'package:customers/pages/orders/order_done_page.dart';
import 'package:customers/pages/shop/shop_page.dart';
import 'package:customers/providers/api/api_provider.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/orders/send_order_provider.dart';
import 'package:customers/providers/payment_provider/online_payment_provider.dart';
import 'package:customers/providers/services/last_position_provider.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/providers/shop/shops_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:customers/widgets/orders/cart_item.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class OrderReview extends StatefulWidget {
  final String location, time, note, payMethod;
  final provider;

  OrderReview(
      {this.location, this.time, this.provider, this.note, this.payMethod});

  @override
  _OrderReviewState createState() =>
      _OrderReviewState(location, time, provider, note);
}

class _OrderReviewState extends State<OrderReview> {
  String location, time, note;
  var provider;

  _OrderReviewState(this.location, this.time, this.provider, this.note);
  Shop shop;
  bool isCalculated = false;
  bool loading = false;
  double total;
  double totalTax;
  var counter = 0;
  var quantity = [];
  var orderProductList = [];
  var pay = '';

  List<DeliveryHistory> orderList;
  bool _isSendOrderSuccess = false;
  @override
  void initState() {
    super.initState();
    pay = widget.payMethod;
    init();
  }

  void init() async {
    setState(() {
      loading = true;
    });
    shop = await Provider.of<ShopsProvider>(context, listen: false)
        .getShopDetails(shopId: provider);
    await Provider.of<OrderCRUDProvider>(context, listen: false).deliveryPrice(
        time: widget.time,
        lat: Provider.of<LongLatProvider>(context, listen: false).lat,
        long: Provider.of<LongLatProvider>(context, listen: false).long,
        address: location,
        note: note,
        shopId: provider,
        orderProductList:
            Provider.of<CartProvider>(context, listen: false).orderProductList,
        quantity: Provider.of<CartProvider>(context, listen: false).quantity,
        payMethod: widget.payMethod);
    var _totalWithoutDelivery =
        Provider.of<CartProvider>(context, listen: false).totalCostWithVAT;
    // final totalVat = _totalWithoutDelivery * vat;
    totalTax = Provider.of<CartProvider>(context, listen: false).calculateTax(
        totalCart:
            Provider.of<CartProvider>(context, listen: false).totalWithoutVAT,
        taxOne: shop.taxOne,
        taxTwo: shop.taxTwo);
    total = _totalWithoutDelivery * 1.0 +
        totalTax +
        Provider.of<OrderCRUDProvider>(context, listen: false).price * 1.0;
    log('total $_totalWithoutDelivery tex $totalTax price ${Provider.of<OrderCRUDProvider>(context, listen: false).price * 1.0}');
    Provider.of<CartProvider>(context, listen: false).initOrder();
    if (Provider.of<OrderCRUDProvider>(context, listen: false).loading ==
        false) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      return ResponsiveWidgets.builder(
        height: 1560,
        width: 720,
        allowFontScaling: true,
        child: ConnectivityWidgetWrapper(
          message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
          child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                elevation: 0.0,
                centerTitle: true,
                backgroundColor: Colors.white,
                title: Text(
                  'reviewOrder'.tr(),
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                )),
            backgroundColor: Colors.white,
            body: cartProvider.loading == true || loading == true
                ? Center(child: Load(200.0))
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Consumer<CartProvider>(
                              builder: (context, cartProvider, _) {
                                if (cartProvider.cartItems != null) {
                                  if (cartProvider.cartCounter > 0) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          right: 25,
                                          left: 25,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Color(0xffF2F2F2)),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: Text(
                                                      userName.toString(),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 200,
                                                      child: Text(
                                                        location,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 15,
                                                      color: Color(0xffFBB746),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ContainerResponsive(
                                            padding:
                                                EdgeInsetsResponsive.all(5),
                                            width: 120,
                                            height: 120,
                                            margin: EdgeInsetsResponsive.only(),
                                            child: CachedNetworkImage(
                                              imageUrl: APIKeys
                                                      .ONLINE_IMAGE_BASE_URL +
                                                  userImage.toString(),
                                              placeholder: (context, url) =>
                                                  ImageLoad(50.0),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/images/logodex.png'),
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return Center(
                                    child: Text('لا توجد عناصر'),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                );
                              },
                            ),

                            /*** Header Three ***/
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              padding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 15),
                              color: Colors.grey[200],
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    'purchasesList',
                                    style: TextStyle(fontSize: 15),
                                  ).tr())
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                List<CartItem> childs =
                                    cartProvider.parents[index].children;
                                return ExpansionTile(
                                  title: CartItemCard(
                                      child: false,
                                      children: [],
                                      cartItem: cartProvider.parents[index]),
                                  children: [
                                    TextResponsive(
                                      'adds'.tr(),
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.black),
                                    ),
                                    SizedBoxResponsive(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: childs.length,
                                      itemBuilder: (context, index) {
                                        return CartItemCard(
                                            child: true,
                                            children: childs,
                                            cartItem: childs[index]);
                                      },
                                    ),
                                    SizedBoxResponsive(height: 10),
                                  ],
                                );
                              },
                              itemCount: cartProvider.parents.length,
                            ),
                            // Container(
                            //   padding: EdgeInsetsResponsive.symmetric(
                            //       horizontal: 15),
                            //   color: Colors.grey[200],
                            //   height: 40,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: <Widget>[
                            //       Container(
                            //           child: Text(
                            //         'adds',
                            //         style: TextStyle(fontSize: 15),
                            //       ).tr())
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 2,
                            // ),
                            // ListView.builder(
                            //   shrinkWrap: true,
                            //   physics: ClampingScrollPhysics(),
                            //   itemBuilder: (context, index) => CartItemCard(
                            //       cartItem: cartProvider.children[index]),
                            //   itemCount: cartProvider.children.length,
                            // ),
                            // SizedBox(
                            //   height: 4,
                            // ),
                            Container(
                              padding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 15),
                              color: Colors.grey[200],
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    'paymentMethod',
                                    style: TextStyle(fontSize: 15),
                                  ).tr())
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 35, vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(right: 25),
                                      child: Text(
                                        pay == '1'
                                            ? 'payOnDelivery'
                                            : 'onlinePayment',
                                        style: TextStyle(fontSize: 17),
                                      ).tr()),
                                  // GestureDetector(
                                  //   onTap: _isSendOrderSuccess
                                  //       ? null
                                  //       : () {
                                  //           setState(() {
                                  //             pay == '1'
                                  //                 ? pay = '0'
                                  //                 : pay == '0'
                                  //                     ? pay = '1'
                                  //                     : pay = '0';
                                  //           });
                                  //         },
                                  //   child: ContainerResponsive(
                                  //     padding: EdgeInsetsResponsive.symmetric(
                                  //         horizontal: 10, vertical: 5),
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(
                                  //             color:
                                  //                 Theme.of(context).accentColor,
                                  //             width: 1),
                                  //         borderRadius:
                                  //             BorderRadius.circular(5)),
                                  //     child: Center(
                                  //         child: TextResponsive('change',
                                  //                 style:
                                  //                     TextStyle(fontSize: 17))
                                  //             .tr()),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              padding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 15),
                              color: Colors.grey[200],
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      child: Text(
                                    'handingDetails',
                                    style: TextStyle(fontSize: 15),
                                  ).tr())
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'handingLocation',
                                    style: TextStyle(
                                        color: Color(0xff616161), fontSize: 15),
                                  ).tr(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Consumer<LastPositionProvider>(
                                          builder: (context,
                                              lastPositionProvider, _) {
                                            if (lastPositionProvider
                                                    .lastMapPosition !=
                                                null) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OpenLocation(
                                                                    location:
                                                                        lastPositionProvider
                                                                            .lastMapPosition)));
                                                  },
                                                  child: Text(
                                                      '(' +
                                                          'viewLocation'.tr() +
                                                          ')',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xffFBB746))));
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.location_on,
                                          size: 13,
                                          color: Color(0xffFBB746),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          // width: 250,
                                          child: Text(
                                            location,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff707070)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(right: 20, left: 20),
                              color: Color(0xffE4DEDE),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsetsResponsive.symmetric(
                                  horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'deliveryTime',
                                    style: TextStyle(
                                        color: Color(0xff616161), fontSize: 14),
                                  ).tr(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(time,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff818181))),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(right: 20, left: 20),
                              color: Color(0xffE4DEDE),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsetsResponsive.symmetric(
                                  horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    context.locale == Locale('ar')
                                        ? shop.taxOneNameAr.toString()
                                        : shop.taxOneName,
                                    style: TextStyle(
                                        color: Color(0xff616161), fontSize: 14),
                                  ).tr(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child: Text(
                                    '${(shop.taxOne * 100)} %',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(right: 20, left: 20),
                              color: Color(0xffE4DEDE),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsetsResponsive.symmetric(
                                  horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    context.locale == Locale('ar')
                                        ? shop.taxTwoNameAr.toString()
                                        : shop.taxTwoName,
                                    style: TextStyle(
                                        color: Color(0xff616161), fontSize: 14),
                                  ).tr(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child: Text(
                                    '${(shop.taxTwo * 100)} %',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(right: 20, left: 20),
                              color: Color(0xffE4DEDE),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsetsResponsive.symmetric(
                                  horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'totalCartItems',
                                    style: TextStyle(
                                        color: Color(0xff616161), fontSize: 14),
                                  ).tr(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child: Text(
                                    '${cartProvider.totalCost.toStringAsFixed(3)} ' +
                                        'sr'.tr(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(right: 20, left: 20),
                              color: Color(0xffE4DEDE),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsetsResponsive.symmetric(
                                  horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'deliveryPrice',
                                    style: TextStyle(
                                        color: Color(0xff616161), fontSize: 14),
                                  ).tr(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child: Text(
                                    '${Provider.of<OrderCRUDProvider>(context, listen: false).price.toStringAsFixed(3)} ' +
                                        'sr'.tr(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              margin: EdgeInsets.only(right: 20, left: 20),
                              color: Color(0xffE4DEDE),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: EdgeInsetsResponsive.symmetric(
                                  horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'VAT',
                                    style: TextStyle(
                                        color: Color(0xff616161), fontSize: 14),
                                  ).tr(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child: Text(
                                    '${(cartProvider.totalCost * vat).toStringAsFixed(3)}' +
                                        'sr'.tr(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 15),
                            color: Colors.grey[200],
                            height: 42,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 30),
                                    child: Text(
                                      'totalTax',
                                      style: TextStyle(fontSize: 15),
                                    ).tr()),
                                Container(
                                    child: Text(
                                  '${((totalTax) + (cartProvider.totalCost * vat)).toStringAsFixed(3)} ' +
                                      'sr'.tr(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                  textAlign: TextAlign.right,
                                  // textDirection: TextDirection.rtl,
                                )),
                              ],
                            ),
                          ),
                          SizedBoxResponsive(height: 5),
                          Container(
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 15),
                            color: Colors.grey[200],
                            height: 42,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 30),
                                    child: Text(
                                      'total',
                                      style: TextStyle(fontSize: 15),
                                    ).tr()),
                                Container(
                                    child: Text(
                                  '${total.toStringAsFixed(3)} ' + 'sr'.tr(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                  textAlign: TextAlign.right,
                                  // textDirection: TextDirection.rtl,
                                )),
                              ],
                            ),
                          ),
                          SizedBoxResponsive(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ConnectivityWidgetWrapper(
                                stacked: false,
                                offlineWidget: Container(
                                  width: MediaQuery.of(context).size.width /
                                      100 *
                                      85,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey[500]),
                                  child: Center(
                                      child: Text(
                                    'في إنتظار الإنترنت',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )),
                                ),
                                child: Consumer<LongLatProvider>(
                                  builder: (context, longLatProvider, _) {
                                    return Consumer<OrderCRUDProvider>(
                                      builder: (context, orderProvider, _) {
                                        return GestureDetector(
                                          onTap: () async {
                                            if (orderProvider.loading ==
                                                    false &&
                                                !_isSendOrderSuccess) {
                                              if (pay == '1') {
                                                final isActive =
                                                    await orderProvider
                                                        .checkAccount(context);
                                                if (isActive) {
                                                  await orderProvider.sendOrder(
                                                      context: context,
                                                      time: widget.time,
                                                      name: userName,
                                                      number: userPhone,
                                                      isGuest: visitor == true
                                                          ? 1
                                                          : 0,
                                                      lat: longLatProvider.lat,
                                                      long:
                                                          longLatProvider.long,
                                                      address: location,
                                                      note: note,
                                                      shopId: provider,
                                                      ref: cartProvider
                                                          .refrences,
                                                      orderProductList:
                                                          cartProvider
                                                              .orderProductList,
                                                      quantity:
                                                          cartProvider.quantity,
                                                      notes: cartProvider.notes,
                                                      amount: total
                                                          .toStringAsFixed(3),
                                                      userId: userId,
                                                      payMethod: pay);

                                                  if (orderProvider
                                                          .isSuccessful !=
                                                      null) {
                                                    if (orderProvider
                                                            .isSuccessful !=
                                                        null) {
                                                      if (orderProvider
                                                          .isSuccessful) {
                                                        _isSendOrderSuccess =
                                                            orderProvider
                                                                .isSuccessful;

                                                        // if (pay == '0') {
                                                        // _buildPaymentBottomSheet(
                                                        //     orderProvider,
                                                        //     cartProvider);
                                                        Fluttertoast.showToast(
                                                            msg: 'orderCreated'
                                                                .tr(),
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            backgroundColor:
                                                                Colors.green,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                        // } else {
                                                        Provider.of<LongLatProvider>(
                                                                context,
                                                                listen: false)
                                                            .setLoc(
                                                                lat: null,
                                                                long: null);
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .clearCart();
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    OrderDone(
                                                                        order: orderProvider
                                                                            .orderList[0])));
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'errorRetry'.tr(),
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  }
                                                }
                                              } else if (pay == '0') {
                                                final isActive =
                                                    await orderProvider
                                                        .checkAccount(context);
                                                if (isActive) {
                                                  _buildPaymentBottomSheet(
                                                      orderProvider,
                                                      cartProvider,
                                                      longLatProvider);
                                                }
                                              }
                                            } else if (pay == '0' &&
                                                orderProvider.orderList.length >
                                                    0) {
                                              _buildPaymentBottomSheet(
                                                  orderProvider,
                                                  cartProvider,
                                                  longLatProvider);
                                            }
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                100 *
                                                85,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: orderProvider.loading ==
                                                        true
                                                    ? Colors.white
                                                    : Colors.black),
                                            child: Center(
                                                child: orderProvider.loading
                                                    ? CupertinoActivityIndicator()
                                                    : Text(
                                                        'sendOrder',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white),
                                                      ).tr()),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
          ),
        ),
      );
    });
  }

  _buildPaymentBottomSheet(
    OrderCRUDProvider orderProvider,
    CartProvider cartProvider,
    LongLatProvider longLatProvider,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString('userId');
    // String jsonString = jsonEncode(paymentJson(orderProvider.orderList[0]));
    String jsonString = jsonEncode(productListData(cartProvider));
    Provider.of<OnlinePaymentProvider>(context, listen: false).webStarted();
    log("products=" +
        jsonString +
        '&user_id=' +
        userId.toString() +
        '&total_amount=' +
        total.toStringAsFixed(3) +
        '&status=Order');
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      isScrollControlled: true,
      builder: (context) => Consumer<ApiProvider>(
        builder: (context1, api, _) => SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: 550,
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Consumer<OnlinePaymentProvider>(
                  builder: (_, paymentWebView, __) => Expanded(
                    child: Stack(children: [
                      Positioned.fill(
                        // child: WebView(
                        //   javascriptMode: JavascriptMode.unrestricted,
                        //   initialUrl:
                        //       'http://165.227.116.15/mishwar/api/v1/payment/thawani?data=' +
                        //           jsonString +
                        //           '&order_id=' +
                        //           orderProvider.orderList[0].orderInfo.id
                        //               .toString() +
                        //           '&total_amount=' +
                        //           total.toString(),
                        //   onPageFinished: (v) {
                        //     _onFinshedWebView(orderProvider, v, paymentWebView);
                        //   },
                        // ),
                        child: InAppWebView(
                            initialUrlRequest: URLRequest(
                                url: Uri.parse(
                                  APIKeys.THAWANI_URL,
                                ),
                                method: 'POST',
                                body: Uint8List.fromList(utf8.encode(
                                    "products=" +
                                        jsonString +
                                        '&user_id=' +
                                        userId.toString() +
                                        '&total_amount=' +
                                        total.toStringAsFixed(3) +
                                        '&status=Order'
                                    // '&order_id=' +
                                    // orderProvider.orderList[0].orderInfo.id
                                    //     .toString()
                                    )),
                                headers: {
                                  'Content-Type':
                                      'application/x-www-form-urlencoded'
                                }),
                            onWebViewCreated: (controller) {},
                            onUpdateVisitedHistory:
                                (InAppWebViewController controller, url,
                                    bool) async {
                              _onFinshedWebView(
                                  orderProvider,
                                  url.toString(),
                                  paymentWebView,
                                  cartProvider,
                                  longLatProvider);
                            }),
                        // onLoadStop:
                        //     (InAppWebViewController controller, url) async {
                        //   _onFinshedWebView(
                        //       orderProvider,
                        //       url.toString(),
                        //       paymentWebView,
                        //       cartProvider,
                        //       longLatProvider);
                        // }),
                      ),
                      if (!paymentWebView.finished)
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        )
                    ]),
                  ),
                ),
//                 TextButton(
//                   child: api.loading
//                       ? CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                       : Text(
//                           'close'.tr(),
//                           style: TextStyle(color: Colors.white),
//                         ),
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(Colors.green)),
//                   onPressed: api.loading
//                       ? null
//                       : () {
// // api.request(url:'http://mishwar.thiqatech.com/api/v1/payment/verify_payment',method: HTTP_METHOD.post );
//                           Navigator.of(context).pop();
//                         },
//                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // paymentJson(DeliveryHistory order) {
  //   return ({
  //     'user_token': userToken,
  //     "user_id": userId,
  //     "order_id": order.orderInfo.id,
  //     "delivery_charges": null,
  //     "total_amount": null,
  //     "client_ref_id": null,
  //     'product': [productJson(order.orderInfo.cartProdcuts[0])],
  //   });
  // }
  //
  // productJson(CartProdcuts product) {
  //   return {
  //     'name': product.productName,
  //     'quantity': product.quantity,
  //     'unit_amount': (total * 1000).roundToDouble()
  //   };
  // }
  //
  Map<String, dynamic> productToJson(CartItem product, double productPrice) {
    log('product total: $productPrice, product quantity: ${product.quantity} ');
    return {
      'name': product.product.name == null || product.product.name == ''
          ? 'product'
          : product.product.name,
      'quantity': 1,
      'unit_amount': (productPrice * 1000).roundToDouble(),
    };
  }

  Map<String, dynamic> deliveryCargesJson(CartProvider cartProvider) {
    final totalTextAndDeliveryPrice =
        Provider.of<OrderCRUDProvider>(context, listen: false).price +
            (cartProvider.totalCost * vat) +
            totalTax;
    log('text: $totalTextAndDeliveryPrice');
    return {
      'name': "deliver charges",
      'quantity': 1,
      'unit_amount': (totalTextAndDeliveryPrice * 1000).roundToDouble(),
    };
  }

  List<Map<String, dynamic>> productListData(CartProvider cartProvider) {
    List<Map<String, dynamic>> products = [];
    double productPrice = 0.0;
    if (cartProvider.cartItems != null) {
      for (int i = 0; i < cartProvider.cartItems.length; i++) {
        if (cartProvider.cartItems[i].product.parent == 0) {
          productPrice = cartProvider.cartItems[i].total;
          for (int v = 0; v < cartProvider.cartItems[i].children.length; v++) {
            productPrice += cartProvider.cartItems[i].children[v].total *
                cartProvider.cartItems[i].quantity;
          }
          if ((productPrice * 1.0) < 0.1) {
          } else {
            products
                .add(productToJson(cartProvider.cartItems[i], productPrice));
          }
        }
      }
    }
    products.add(deliveryCargesJson(cartProvider));
    return products;
  }

  _onFinshedWebView(
    OrderCRUDProvider orderProvider,
    String v,
    var paymentWebView,
    CartProvider cartProvider,
    LongLatProvider longLatProvider,
  ) {
    log(v.toString());
    if (v.contains('/thwani/cancel')) {
      // orderProvider.setPaymentStatus(
      //     orderProvider.orderList[0].orderInfo.id.toString(), 'fail');
      Fluttertoast.showToast(
          msg: 'paymentCanceled'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pop();
    } else if (v.contains('/thawani/succuss')) {
      // Provider.of<LongLatProvider>(context, listen: false)
      //     .setLoc(lat: null, long: null);
      // Provider.of<CartProvider>(context, listen: false).clearCart();
      // orderProvider.setPaymentStatus(
      //     orderProvider.orderList[0].orderInfo.id.toString(), 'success');
      // if (!orderProvider.isUpdateStatusSuccess) {
      //   orderProvider.setPaymentStatus(
      //       orderProvider.orderList[0].orderInfo.id.toString(), 'success');
      // } else {
      //   Provider.of<CartProvider>(context, listen: false).clearCart();
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               OrderDone(order: orderProvider.orderList[0])));
      // }
      _thawaniSuccess(orderProvider, cartProvider, longLatProvider, userId);
    }
    paymentWebView.webViewSucceed();
  }

  _thawaniSuccess(
    OrderCRUDProvider orderProvider,
    CartProvider cartProvider,
    LongLatProvider longLatProvider,
    String userId,
  ) async {
    Navigator.pop(context);
    await orderProvider.sendOrder(
        context: context,
        time: widget.time,
        name: userName,
        number: userPhone,
        isGuest: visitor == true ? 1 : 0,
        lat: longLatProvider.lat,
        long: longLatProvider.long,
        address: location,
        note: note,
        shopId: provider,
        ref: cartProvider.refrences,
        orderProductList: cartProvider.orderProductList,
        quantity: cartProvider.quantity,
        notes: cartProvider.notes,
        amount: total.toStringAsFixed(3),
        userId: userId,
        payMethod: pay);

    if (orderProvider.isSuccessful != null) {
      if (orderProvider.isSuccessful != null) {
        if (orderProvider.isSuccessful) {
          _isSendOrderSuccess = orderProvider.isSuccessful;

          // if (pay == '0') {
          // _buildPaymentBottomSheet(
          //     orderProvider,
          //     cartProvider);
          Fluttertoast.showToast(
              msg: 'orderCreated'.tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          // } else {
          Provider.of<LongLatProvider>(context, listen: false)
              .setLoc(lat: null, long: null);
          Provider.of<CartProvider>(context, listen: false).clearCart();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderDone(order: orderProvider.orderList[0])));
          // }
        } else {
          Fluttertoast.showToast(
              msg: 'errorRetry'.tr(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
  }
}
