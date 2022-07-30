import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/models/user.dart';
import 'package:customers/pages/account/profile.dart';
import 'package:customers/pages/orders/order_done_page.dart';
import 'package:customers/pages/orders/set_myloction_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart' as globals;
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CheckOutState();
}

class Item {
  final String itemName;
  final String itemQun;
  final String itemPrice;

  Item({this.itemName, this.itemQun, this.itemPrice});
}

class CheckOutState extends State<Checkout> {
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedS != null && pickedS != selectedTime)
      setState(() {
        selectedTime = pickedS;
        print(selectedTime);

        time.text =
            selectedTime.hour.toString() + ':' + selectedTime.minute.toString();
      });
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  User user;
  SharedPreferences prefs;
  var loading = false;
  List<DeliveryHistory> orderList;
  var stBo = TextEditingController();
  var nearLoc = TextEditingController();
  var type = TextEditingController();
  var time = TextEditingController();

  Future getUserInfo() async {
    try {
      loading = true;
      prefs = await SharedPreferences.getInstance();
      var userPhone = prefs.get('user_phone');

      var response = await dioClient.get(APIKeys.BASE_URL + 'getUserinfo/$userPhone');

      var data = response.data;
      print("BEFORE");
      user = User.fromJson(data);
      setState(() {
        loading = false;
      });
      print("AFTER");
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  initPrefs() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool checkboxValueC = false;
  var isLoading = false;
  dynamic comments;

  List<globals.Cityinfo> cityinfoList = List();

  setValues() async {
    setState(() {
      isLoading = true;
    });
    var prefs = await SharedPreferences.getInstance();
    String homeType = prefs.getString("homeType");
    String deliveryAdress = prefs.getString("deliveryAdress");
    String closest = prefs.getString("closest");
    setState(() {
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
    initPrefs();
    getUserInfo();
    setValues();
  }

  String toolbarname = 'CheckOut';

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    var isLoading = false;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'order',
          style: TextStyle(color: Colors.black),
        ).tr(),
      ),
      body: ConnectivityWidgetWrapper(
          child: loading
              ? Center(child: Load(150.0))
              : GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                              )
                            : Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(2.0),
                                  ),
                                  _verticalDivider(),
                                  Container(
                                      height: 150.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SetLocation()));
                                            },
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              height: 80.0,
                                              width: 100.0,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: IconButton(
                                                          icon: Icon(Icons.map),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SetLocation()));
                                                          })),
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      'myLocation',
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0),
                                                    ).tr(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 12.0,
                                                  top: 0.0,
                                                  right: 10.0,
                                                  bottom: 0.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Profile(user)));
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 5.0,
                                                            right: 1),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              user.firstName !=
                                                                      null
                                                                  ? user
                                                                      .firstName
                                                                  : '',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' : ' +
                                                                  'Name'.tr(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 5.0,
                                                            right: 4),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              user.loginPhone !=
                                                                      null
                                                                  ? user
                                                                      .loginPhone
                                                                  : '',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                            ),
                                                            Text(
                                                              ' : ' +
                                                                  'phone'.tr(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 5.0,
                                                          right: 4),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  width: 200,
                                                                  child: Text(
                                                                    stBo.text + type.text !=
                                                                            null
                                                                        ? nearLoc
                                                                                .text.isNotEmpty
                                                                            ? stBo.text +
                                                                                " / " +
                                                                                type.text +
                                                                                ' ' +
                                                                                "near".tr() +
                                                                                ": " +
                                                                                nearLoc.text
                                                                            : stBo.text + " / " + type.text
                                                                        : 'unknown'.tr(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    maxLines: 3,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          12.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            ' : ' +
                                                                'address'.tr(),
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, bottom: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            globals.nearShopClass
                                                                        .name !=
                                                                    null
                                                                ? globals
                                                                    .nearShopClass
                                                                    .name
                                                                : '',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' : ' +
                                                                'store'.tr(),
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14.0,
                                                              letterSpacing:
                                                                  0.5,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 20.0),
                                  Card(
                                    elevation: 2,
                                    child: Container(
                                        height: 160,
                                        color: Color(0xffeeeeee),
                                        padding: EdgeInsets.all(10.0),
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: 200.0,
                                            ),
                                            child: Scrollbar(
                                                child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    reverse: true,
                                                    child: SizedBox(
                                                      height: 150.0,
                                                      child: TextField(
                                                        maxLines: 100,
                                                        decoration:
                                                            InputDecoration(
                                                                icon: Icon(
                                                                  Icons.comment,
                                                                  color: Colors
                                                                      .black38,
                                                                ),
                                                                labelText:
                                                                    'orderData',
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    'writeOrders'
                                                                        .tr()),
                                                        onChanged: (text) {
                                                          print(
                                                              "First text field: $text");
                                                          comments = text;
                                                        },
                                                      ),
                                                    ))))),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Text(
                                      'deliveryTime',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 15),
                                      textAlign: TextAlign.right,
                                    ).tr(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Builder(
                                      builder: (context) => GestureDetector(
                                            onTap: () async {
                                              _selectTime(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  right: 17, left: 20, top: 5),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: TextField(
                                                  controller: time,
                                                  enabled: false,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      prefixIcon: Icon(
                                                        Icons.timer,
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                      ),
                                                      hintText:
                                                          'enterDeliveryTime'
                                                              .tr(),
                                                      hintStyle: TextStyle(
                                                          fontSize: 13)),
                                                  textAlign: TextAlign.right,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Text(
                                      'houseType',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 15),
                                      textAlign: TextAlign.right,
                                    ).tr(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Container(
                                            height: 400,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                50,
                                            child: ListView(
                                              children: <Widget>[
                                                Container(
                                                    height: 50,
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 30.0),
                                                          child: Text(
                                                            'houseType',
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          ).tr(),
                                                        )
                                                      ],
                                                    )),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20, top: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        'apartment',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ).tr(),
                                                      Radio<int>(
                                                          value: 2,
                                                          activeColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          groupValue: 1,
                                                          onChanged:
                                                              (int value) {
                                                            setState(() {
                                                              type.text =
                                                                  "apartment"
                                                                      .tr();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        'villa',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ).tr(),
                                                      Radio<int>(
                                                          value: 2,
                                                          activeColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          groupValue: 1,
                                                          onChanged:
                                                              (int value) {
                                                            setState(() {
                                                              type.text =
                                                                  "villa".tr();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        'compound',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ).tr(),
                                                      Radio<int>(
                                                          value: 2,
                                                          activeColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          groupValue: 1,
                                                          onChanged:
                                                              (int value) {
                                                            setState(() {
                                                              type.text =
                                                                  "compound"
                                                                      .tr();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        'company',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ).tr(),
                                                      Radio<int>(
                                                          value: 2,
                                                          activeColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          groupValue: 1,
                                                          onChanged:
                                                              (int value) {
                                                            setState(() {
                                                              type.text =
                                                                  "company"
                                                                      .tr();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        'fair',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ).tr(),
                                                      Radio<int>(
                                                          value: 2,
                                                          activeColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          groupValue: 1,
                                                          onChanged:
                                                              (int value) {
                                                            setState(() {
                                                              type.text =
                                                                  "fair".tr();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        'school',
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ).tr(),
                                                      Radio<int>(
                                                          value: 2,
                                                          activeColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          groupValue: 1,
                                                          onChanged:
                                                              (int value) {
                                                            setState(() {
                                                              type.text =
                                                                  "school".tr();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
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
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 17, left: 20, top: 5),
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: TextField(
                                          controller: type,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: GestureDetector(
                                                child: type.text.isNotEmpty
                                                    ? Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      )
                                                    : Icon(
                                                        Icons.home,
                                                        color:
                                                            Color(0xffEE3840),
                                                      ),
                                              ),
                                              hintText: 'enterHouseType'.tr(),
                                              hintStyle:
                                                  TextStyle(fontSize: 13)),
                                          textAlign: TextAlign.right,
                                          keyboardType: TextInputType.text,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20, top: 30),
                                    child: Text(
                                      'deliveryAddress',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 15),
                                      textAlign: TextAlign.right,
                                    ).tr(),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 17, left: 20, top: 5),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextField(
                                        controller: stBo,
                                        enabled: true,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: GestureDetector(
                                                child: Icon(
                                              Icons.location_city,
                                              color: Colors.grey,
                                            )),
                                            hintText: 'streetHouseNumber'.tr(),
                                            hintStyle: TextStyle(fontSize: 13)),
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 17, left: 20, top: 5),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextField(
                                        controller: nearLoc,
                                        enabled: true,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            prefixIcon: GestureDetector(
                                                child: Icon(
                                              Icons.location_city,
                                              color: Colors.grey,
                                            )),
                                            hintText: 'landmark'.tr(),
                                            hintStyle: TextStyle(fontSize: 13)),
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _verticalDivider(),
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      height: 85.0,
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child:
                                                        ConnectivityWidgetWrapper(
                                                      stacked: false,
                                                      offlineWidget: FlatButton(
                                                          color:
                                                              Colors.grey[500],
                                                          child: Text(
                                                              'في إنتظار الإنترنت'),
                                                          textColor:
                                                              Colors.white,
                                                          onPressed: () {},
                                                          shape:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          )),
                                                      child: Consumer<
                                                          LongLatProvider>(
                                                        builder: (context,
                                                            longLatProvider,
                                                            _) {
                                                          return FlatButton(
                                                              color: Color(
                                                                  0xff34C961),
                                                              child: const Text(
                                                                      'sendOrder')
                                                                  .tr(),
                                                              textColor:
                                                                  Colors.black,
                                                              onPressed:
                                                                  () async {
                                                                await sendOrder(
                                                                    longLatProvider
                                                                        .long,
                                                                    longLatProvider
                                                                        .lat);
                                                              },
                                                              shape:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                      ),
                    ],
                  ),
                )),
    );
  }

  sendOrder(long, lat) async {
    if (comments == null) {
      Fluttertoast.showToast(
          msg: 'enterOrderDetails'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (time.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'enterDeliveryTime'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (type.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'enterHouseType'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else
      try {
        var address = "streetNumber".tr() + ' ' + stBo.text;
        if (nearLoc.text.isNotEmpty) {
          address = address + ' / ' + "near".tr() + " : " + nearLoc.text;
        }
        address = address + " / " + type.text;

        SharedPreferences pref = await SharedPreferences.getInstance();

        setState(() {
          loading = true;
        });
        await prefs.setString("homeType", type.text);
        await prefs.setString("deliveryAdress", "${stBo.text}");
        await prefs.setString("closest", nearLoc.text);
        var id = pref.getString('userId');
        var mytime = time.text;
        var response = await dioClient.post(APIKeys.BASE_URL + 'sendOrder',
            data: FormData.fromMap({
              'time': mytime,
              'end_latitude': lat,
              'end_longitude': long,
              'customer': id,
              'note': comments.toString(),
              'shop': 0,
              'shopLatitude': globals.nearShopClass.geometry.location.lat,
              'shopLongitude': globals.nearShopClass.geometry.location.lng,
              'nearByShopName': globals.nearShopClass.name,
              'nearByShopImg': globals.nearShopClass.icon,
              'Qun': 'none',
              'OrderProductIdslist': 'none',
              'address': address,
              'nearbyorder': 'yes',
            }));
        print(response.data['Data']);

        if (response.data['State'] == "sucess") {
          var data = response.data["Data"];
          var shops = data as List;
          Provider.of<LongLatProvider>(context, listen: false)
              .setLoc(lat: null, long: null);
          Provider.of<CartProvider>(context, listen: false).clearCart();
          orderList = shops
              .map<DeliveryHistory>((json) => DeliveryHistory.fromJson(json))
              .toList();

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderDone(order: orderList[0], from: 'nearCheckOut')));
        } else {
          setState(() {
            loading = false;
          });
          print('ERROR SENDORDER  ${response.data['Data']}');

          Fluttertoast.showToast(
              msg: response.data['Data'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } on DioError catch (error) {
        setState(() {
          loading = false;
        });
        print('ERROR SENDORDER  ${error.response.statusCode}');
        print('ERROR SENDORDER  ${error.response.data}');
        switch (error.type) {
          case DioErrorType.connectTimeout:
          case DioErrorType.sendTimeout:
          case DioErrorType.cancel:
            throw error;
            break;
          default:
            throw error;
        }
      } catch (error) {
        throw error;
      }
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );
}
