import 'dart:convert';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/pages/orders/order_review_page.dart';
import 'package:customers/providers/api/api_provider.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/payment_provider/online_payment_provider.dart';
import 'package:customers/providers/services/last_position_provider.dart';
import 'package:customers/providers/services/location.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/repositories/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductTimeAndLocationDetails extends StatefulWidget {
  final provider;
  ProductTimeAndLocationDetails({this.provider});
  @override
  _ProductTimeAndLocationDetailsState createState() =>
      _ProductTimeAndLocationDetailsState(provider);
}

class _ProductTimeAndLocationDetailsState
    extends State<ProductTimeAndLocationDetails> {
  SharedPreferences prefs;
  var provider;
  _ProductTimeAndLocationDetailsState(this.provider);

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
        time.text =
            selectedTime.hour.toString() + ':' + selectedTime.minute.toString();
      });
  }

  bool loading = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController location = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController stBo = TextEditingController();
  TextEditingController nearLoc = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController visitorName = TextEditingController();
  TextEditingController visitorNum = TextEditingController();
  // var activeLanguage = 0;
  bool isOnlinePayment = false;

  Future<void> _showAlertDialog() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          height: 400,
          width: MediaQuery.of(context).size.width - 50,
          child: ListView(
            children: <Widget>[
              Container(
                  height: 50,
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                          'houseType',
                          style: TextStyle(fontSize: 18),
                        ).tr(),
                      )
                    ],
                  )),

              //Radio Groups
              Container(
                margin: EdgeInsets.only(right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'apartment',
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                    Radio<int>(
                        value: 2,
                        activeColor: Theme.of(context).accentColor,
                        groupValue: 1,
                        onChanged: (int value) {
                          setState(() async {
                            type.text = "apartment".tr();
                            await prefs.setString("homeType", type.text);
                            Navigator.of(context).pop();
                          });
                        })
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'villa',
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                    Radio<int>(
                        value: 2,
                        activeColor: Theme.of(context).accentColor,
                        groupValue: 1,
                        onChanged: (int value) {
                          setState(() async {
                            type.text = "villa".tr();
                            await prefs.setString("homeType", type.text);
                            Navigator.of(context).pop();
                          });
                        })
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'compound',
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                    Radio<int>(
                        value: 2,
                        activeColor: Theme.of(context).accentColor,
                        groupValue: 1,
                        onChanged: (int value) {
                          setState(() async {
                            type.text = "compound".tr();
                            await prefs.setString("homeType", type.text);
                            Navigator.of(context).pop();
                          });
                        })
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'company',
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                    Radio<int>(
                        value: 2,
                        activeColor: Theme.of(context).accentColor,
                        groupValue: 1,
                        onChanged: (int value) {
                          setState(() async {
                            type.text = "company".tr();
                            await prefs.setString("homeType", type.text);
                            Navigator.of(context).pop();
                          });
                        })
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'fair',
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                    Radio<int>(
                        value: 2,
                        activeColor: Theme.of(context).accentColor,
                        groupValue: 1,
                        onChanged: (int value) {
                          setState(() async {
                            type.text = "fair".tr();
                            await prefs.setString("homeType", type.text);
                            Navigator.of(context).pop();
                          });
                        })
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'school',
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                    Radio<int>(
                        value: 2,
                        activeColor: Theme.of(context).accentColor,
                        groupValue: 1,
                        onChanged: (int value) {
                          setState(() async {
                            type.text = "school".tr();

                            // print(prefs.getString("homeType"));
                            Navigator.of(context).pop();
                          });
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('save').tr(),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  LocationData loc;
  var _location = Location();
  getLocation() async {
    setState(() {
      loading = true;
    });
    try {
      if (await _location.serviceEnabled()) {
        loc = await _location.getLocation();
        LatLng latLng = LatLng(loc.latitude, loc.longitude);
        Provider.of<LongLatProvider>(context, listen: false)
            .setLoc(lat: loc.latitude, long: loc.longitude);
        await Provider.of<LastPositionProvider>(context, listen: false)
            .updatePosition(updated: latLng);
      } else if (await _location.requestService()) {
        await getLocation();
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
        print(error);
      }
      loc = null;
    }
  }

  Future<void> setValues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String homeType = pref.getString("homeType");
    String deliveryAdress = pref.getString("deliveryAdress");
    String closest = pref.getString("closest");
    setState(() {
      visitorName.text = pref.getString("vName") ?? '';
      visitorNum.text = pref.getString("vNum") ?? '';
      type.text = homeType;
      stBo.text = deliveryAdress;
      time.text = TimeOfDay.now().hour.toString() +
          ':' +
          TimeOfDay.now().minute.toString();
      nearLoc.text = closest;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<LongLatProvider>(context, listen: false)
          .setLoc(lat: null, long: null);
      Provider.of<CartProvider>(context, listen: false).calculateTotal();
      initPrefs();
      setValues();
      getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text('deliverTo').tr(),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Colors.black))),
      backgroundColor: Colors.white,
      body: ConnectivityWidgetWrapper(
        message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(children: <Widget>[
              SizedBoxResponsive(
                height: 30,
              ),
              ContainerResponsive(
                margin: EdgeInsetsResponsive.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ContainerResponsive(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(360),
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      child: Center(
                        child: ContainerResponsive(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: BorderRadius.circular(360),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                        ),
                      ),
                    ),
                    ContainerResponsive(
                        height: 1, color: Colors.black, width: MediaQuery.of(context).size.width * .6),
                    ContainerResponsive(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(360),
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      child: Center(
                        child: ContainerResponsive(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: BorderRadius.circular(360),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                        ),
                      ),
                    ),
                    ContainerResponsive(
                        height: 1, color: Colors.black, width: MediaQuery.of(context).size.width * .6),
                    ContainerResponsive(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(360),
                        border: Border.all(width: 1, color: Colors.black),
                      ),
                      child: Center(),
                    )
                  ],
                ),
              ),
              SizedBoxResponsive(height: 30),
              Container(
                margin: EdgeInsetsResponsive.symmetric(horizontal: 20),
                child: Text(
                  'handingLocation',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 15),
                ).tr(),
              ),
              SizedBox(
                height: 7,
              ),
              GestureDetector(onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductLocation(from: 'checkout')));
              }, child: Consumer<LongLatProvider>(
                builder: (context, longLatProvider, _) {
                  return Container(
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 20),
                    margin: EdgeInsetsResponsive.symmetric(horizontal: 20),
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: longLatProvider.lat != null &&
                              longLatProvider.long != null
                          ? Colors.black
                          : Colors.grey[300],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextResponsive(
                          "handingLocation".tr(),
                          style: TextStyle(
                              fontSize: 25,
                              color: longLatProvider.lat != null &&
                                      longLatProvider.long != null
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        longLatProvider.lat != null &&
                                longLatProvider.long != null
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              )
                            : CupertinoActivityIndicator()
                      ],
                    ),
                  );
                },
              )),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: visitor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsetsResponsive.symmetric(horizontal: 20),
                      child: Text(
                        'vistorInfo',
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontSize: 15),
                      ).tr(),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin: EdgeInsetsResponsive.only(right: 20, left: 20),
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsResponsive.only(right: 10.0, left: 10),
                        child: TextField(
                          controller: visitorName,
                          enabled: true,
                          decoration: InputDecoration(
                            hintText: 'vistorName'.tr(),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin: EdgeInsetsResponsive.only(right: 20, left: 20),
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsResponsive.only(right: 10.0, left: 10),
                        child: TextField(
                          controller: visitorNum,
                          enabled: true,
                          decoration: InputDecoration(
                            hintText: 'vistorNumber'.tr(),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsetsResponsive.symmetric(horizontal: 20),
                child: Text(
                  'deliveryTime',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 15),
                ).tr(),
              ),
              SizedBox(
                height: 7,
              ),
              Builder(
                  builder: (context) => GestureDetector(
                        onTap: () async {
                          _selectTime(context);
                        },
                        child: Container(
                          margin:
                              EdgeInsetsResponsive.only(right: 20, left: 20),
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300],
                          ),
                          child: Padding(
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 10.0),
                            child: TextField(
                              controller: time,
                              enabled: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'enterDeliveryTime'.tr(),
                                  hintStyle: TextStyle(fontSize: 13)),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )),
              // SizedBox(
              //   height: 15,
              // ),
              // Container(
              //   margin: EdgeInsets.only(right: 20),
              //   child: Text(
              //     'houseType',
              //     style: TextStyle(
              //         color: Theme.of(context).accentColor, fontSize: 15),
              //     textAlign: TextAlign.right,
              //   ).tr(),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // GestureDetector(
              //   onTap: _showAlertDialog,
              //   child: Container(
              //     margin: EdgeInsets.only(right: 17, left: 20, top: 5),
              //     height: 40,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //           color: Theme.of(context).secondaryHeaderColor),
              //       borderRadius: BorderRadius.circular(5),
              //       color: Theme.of(context).secondaryHeaderColor,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.only(right: 8.0),
              //       child: TextField(
              //         controller: type,
              //         enabled: false,
              //         decoration: InputDecoration(
              //             border: InputBorder.none,
              //             prefixIcon: GestureDetector(
              //               child: type.text.isNotEmpty
              //                   ? Icon(
              //                       Icons.check,
              //                       color: Colors.green,
              //                     )
              //                   : Icon(
              //                       Icons.home,
              //                       color: Color(0xffEE3840),
              //                     ),
              //             ),
              //             hintText: 'enterHouseType'.tr(),
              //             hintStyle: TextStyle(fontSize: 13)),
              //         textAlign: TextAlign.right,
              //         keyboardType: TextInputType.text,
              //         style: TextStyle(
              //           color: Theme.of(context).accentColor,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsetsResponsive.only(right: 20, left: 20),
                child: Text(
                  'deliveryAddress',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 15),
                ).tr(),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                margin: EdgeInsetsResponsive.only(right: 20, left: 20),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: EdgeInsetsResponsive.only(right: 10.0, left: 10),
                  child: TextField(
                    controller: stBo,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'streetNumber'.tr(),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsetsResponsive.only(right: 20, left: 20, top: 10),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: EdgeInsetsResponsive.only(right: 10.0, left: 10),
                  child: TextField(
                    controller: nearLoc,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'nearestLocation'.tr(),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsetsResponsive.only(left: 20, right: 20),
                child: Text(
                  'instructions',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 15),
                ).tr(),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                margin: EdgeInsetsResponsive.only(right: 20, left: 20),
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: EdgeInsetsResponsive.only(right: 10.0, left: 10),
                  child: TextField(
                    controller: note,
                    enabled: true,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsetsResponsive.only(left: 20, right: 20),
                child: Text(
                  'deliveryType'.tr(),
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 15),
                ),
              ),
              SizedBox(height: 7),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          padding:
                              EdgeInsetsResponsive.only(right: 20, left: 20),
                          // width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: context.locale.languageCode == 'en'
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              bottomLeft: context.locale.languageCode == 'en'
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              bottomRight: context.locale.languageCode == 'ar'
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              topRight: context.locale.languageCode == 'ar'
                                  ? Radius.circular(10)
                                  : Radius.zero,
                            ),
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    'delivery',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: Container(
                          padding:
                              EdgeInsetsResponsive.only(right: 20, left: 20),
                          // width: 200,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: context.locale.languageCode == 'ar'
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              bottomLeft: context.locale.languageCode == 'ar'
                                  ? Radius.circular(10)
                                  : Radius.zero,
                              bottomRight: context.locale.languageCode == 'ar'
                                  ? Radius.zero
                                  : Radius.circular(10),
                              topRight: context.locale.languageCode == 'ar'
                                  ? Radius.zero
                                  : Radius.circular(10),
                            ),
                            color: Colors.black,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Center(
                                    child: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                )),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsetsResponsive.only(left: 20, right: 20),
                child: Text(
                  'paymentMethod',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 15),
                ).tr(),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isOnlinePayment = true;
                          });
                        },
                        child: Container(
                            padding:
                                EdgeInsetsResponsive.only(right: 20, left: 20),
                            // width: 200,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: context.locale.languageCode == 'en'
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomLeft: context.locale.languageCode == 'en'
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomRight: context.locale.languageCode == 'ar'
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                topRight: context.locale.languageCode == 'ar'
                                    ? Radius.circular(10)
                                    : Radius.zero,
                              ),
                              color: Colors.grey[300],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Center(
                                    child: Text(
                                      'onlinePayment'.tr(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                isOnlinePayment
                                    ? Icon(Icons.check_circle)
                                    : Container()
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isOnlinePayment = false;
                          });
                        },
                        child: Container(
                            padding:
                                EdgeInsetsResponsive.only(right: 20, left: 20),
                            // width: 200,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: context.locale.languageCode == 'ar'
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomLeft: context.locale.languageCode == 'ar'
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomRight: context.locale.languageCode == 'ar'
                                    ? Radius.zero
                                    : Radius.circular(10),
                                topRight: context.locale.languageCode == 'ar'
                                    ? Radius.zero
                                    : Radius.circular(10),
                              ),
                              color: Colors.black,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Center(
                                    child: Text(
                                      'payOnDelivery'.tr(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                isOnlinePayment
                                    ? Container()
                                    : Icon(Icons.check_circle,
                                        color: Colors.white)
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ])),
            Consumer<LongLatProvider>(
              builder: (context, longLatProvider, _) {
                return GestureDetector(
                  onTap: isOnlinePayment
                      ? () {
                          _navigateToOrderReviewPage(longLatProvider);
//                           Provider.of<OnlinePaymentProvider>(context,
//                                   listen: false)
//                               .webStarted();
//                           showModalBottomSheet(
//                             context: context,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(15),
//                                   topRight: Radius.circular(15)),
//                             ),
//                             isScrollControlled: true,
//                             builder: (context) => Consumer<ApiProvider>(
//                               builder: (context1, api, _) =>
//                                   SingleChildScrollView(
//                                 physics: AlwaysScrollableScrollPhysics(),
//                                 child: Container(
//                                   height: 550,
//                                   padding: EdgeInsets.all(15.0),
//                                   margin: EdgeInsets.only(
//                                       bottom: MediaQuery.of(context)
//                                           .viewInsets
//                                           .bottom),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.stretch,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Consumer<OnlinePaymentProvider>(
//                                         builder: (_, paymentWebView, __) =>
//                                             Expanded(
//                                           child: Stack(children: [
//                                             Positioned.fill(
//                                               child: WebView(
//                                                 javascriptMode:
//                                                     JavascriptMode.unrestricted,
//                                                 initialUrl:
//                                                     'http://mishwar.thiqatech.com/api/v1/payment/thawani?data=' +
//                                                         paymentJson(),
//                                                 onPageFinished: (v) {
//                                                   paymentWebView
//                                                       .webViewSucceed();
//                                                 },
//                                               ),
//                                             ),
//                                             if (!paymentWebView.finished)
//                                               Center(
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   color: Colors.green,
//                                                 ),
//                                               )
//                                           ]),
//                                         ),
//                                       ),
//                                       TextButton(
//                                         child: api.loading
//                                             ? CircularProgressIndicator(
//                                                 color: Colors.white,
//                                               )
//                                             : Text(
//                                                 'close'.tr(),
//                                                 style: TextStyle(
//                                                     color: Colors.white),
//                                               ),
//                                         style: ButtonStyle(
//                                             backgroundColor:
//                                                 MaterialStateProperty.all(
//                                                     Colors.green)),
//                                         onPressed: api.loading
//                                             ? null
//                                             : () {
// // api.request(url:'http://mishwar.thiqatech.com/api/v1/payment/verify_payment',method: HTTP_METHOD.post );
//                                                 Navigator.of(context).pop();
//                                               },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
                        }
                      : () {
                          _navigateToOrderReviewPage(longLatProvider);
                        },
                  child: Container(
                      margin: EdgeInsetsResponsive.only(
                          right: 20, left: 20, top: 5, bottom: 30),
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'continue',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ).tr(),
                      )),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String paymentJson() {
    return jsonEncode({
      'user_token': '',
      'user_id': userId,
      'delivery_charges': 1,
      'total_amount': 100.0,
      'client_ref_id': 1,
      'product': [productJson()],
    }).toString();
  }

  productJson() {
    return {'name': 'm', 'quantity': 1, 'unit_amount': 1000};
  }

  _navigateToOrderReviewPage(LongLatProvider longLatProvider) async {
    if (longLatProvider.lat == null && longLatProvider.long == null) {
      Fluttertoast.showToast(
          msg: 'enterLocationFirst'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (time.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'enterHandingTimeFirst'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (visitor && visitorName.text.length < 5) {
      Fluttertoast.showToast(
          msg: 'name>6'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (visitor &&
        (visitorNum.text.length != 9 && visitorNum.text.length != 10)) {
      Fluttertoast.showToast(
          msg: 'writePhoneNumber'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //timeInSecForIos: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      String address = "streetNumber".tr() + ' ' + stBo.text;
      if (nearLoc.text.isNotEmpty) {
        address = nearLoc.text + "near".tr() + ": " + address;
      }
      await prefs.setString("homeType", type.text);
      await prefs.setString("deliveryAdress", "${stBo.text}");
      await prefs.setString("closest", nearLoc.text);
      address = address + " / " + type.text;
      userName = visitorName.text;
      userPhone = visitorNum.text;
      await prefs.setString('vName', visitorName.text);
      await prefs.setString('vNum', visitorNum.text);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderReview(
                    location: address,
                    time: time.text,
                    provider: provider,
                    note: note.text,
                    payMethod: isOnlinePayment ? "0" : "1",
                  )));
    }
  }
}
