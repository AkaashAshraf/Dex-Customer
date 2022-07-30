import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/carType.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/models/log_trip.dart';
import 'package:customers/models/user.dart';
import 'package:customers/pages/auth/registor_driver.dart';
import 'package:customers/pages/orders/order_done_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/providers/services/media_pick.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart' as globals;
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/services/last_position_provider.dart';
import '../../providers/services/location.dart';

class SpicalOrder extends StatefulWidget {
  final String from;

  const SpicalOrder({Key key, this.from}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SpicalOrderState();
}

class SpicalOrderState extends State<SpicalOrder> {
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
  int loading = 0;
  List<DeliveryHistory> orderList;
  var stBo = TextEditingController();
  var nearLoc = TextEditingController();
  var type = TextEditingController();
  var time = TextEditingController();

  Future getUserInfo() async {
    try {
      prefs = await SharedPreferences.getInstance();
      var userPhone = prefs.get('user_phone') ?? '';

      var response = await dioClient.get(APIKeys.BASE_URL + 'getUserinfo/$userPhone');

      var data = response.data;
      print("BEFORE");
      user = User.fromJson(data);
      setState(() {
        loading++;
      });
      print("AFTER");
    } on DioError catch (error) {
      setState(() {
        loading++;
      });
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
      setState(() {
        loading++;
      });
      throw error;
    }
  }

  List<LogTrip> trips = [];
  bool tripPicked = false;
  int tripId = 0;

  Future getLogTrips() async {
    try {
      prefs = await SharedPreferences.getInstance();
      var id = prefs.get('user_id') ?? '1';

      var response =
          await dioClient.get(APIKeys.BASE_URL + 'getLogisticTrips&customerId=$id');

      var data = response.data["data"] as List;
      trips = data.map<LogTrip>((trip) => LogTrip.fromJson(trip)).toList();
      setState(() {
        loading++;
      });
    } on DioError catch (error) {
      setState(() {
        loading++;
      });
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
      setState(() {
        loading++;
      });
      throw error;
    }
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    lat = prefs.getDouble('lat');
    long = prefs.getDouble('long');
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool checkboxValueC = false;
  var isLoading = false;
  var lat = 0.0;
  var long = 0.0;
  dynamic comments;
  var _location = Location();
  LocationData loc;
  var _profileLicenseNumber;
  List<globals.Cityinfo> cityinfoList = List();

  setValues() async {
    var prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("user_phone");
    String deliveryAdress = prefs.getString("deliveryAdress");
    String closest = prefs.getString("closest");
    String email = prefs.getString('email') ?? '';
    setState(() {
      type.text = phone;
      stBo.text = deliveryAdress;
      time.text = email;
      nearLoc.text = closest;
    });
  }

  String price(List<LogTrip> trips, List<CarType> cars) {
    var tripPrice = 0.0;
    var carPrice = 0.0;
    if (trips.where((t) => t.id == tripId).isNotEmpty) {
      tripPrice = trips.where((t) => t.id == tripId).first.price;
    }
    if (cars.where((c) => c.id == pickedcarId).isNotEmpty) {
      carPrice = cars.where((c) => c.id == pickedcarId).first.price;
    }
    var total = tripPrice + carPrice;
    return total.toStringAsFixed(1);
  }

  String _dropTrip = 'picktrip'.tr();

  Widget tripDropDown(List<LogTrip> list) {
    return DropdownButton(
      items: list.map((item) {
        return DropdownMenuItem(
          value: item.id,
          child: TextResponsive(
            context.locale == Locale('en', '') ?
            "${item.fromCity} - ${item.toCity}" : "${item.fromCityAr} - ${item.toCityAr}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),isExpanded: true,
      underline: Container(
          decoration: BoxDecoration(
        border: null,
      )),
      hint: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextResponsive(
          _dropTrip,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _dropDate = 'pickDate'.tr();
          pickedDateId = 0;
          tripId = value;
          _dropTrip =
              "${list.where((v) => v.id == value).first.fromCity} - ${list.where((v) => v.id == value).first.toCity}";
        });
        print(tripId);
      },
    );
  }

  List<CarType> cars = [];
  int pickedcarId = 0;
  String _dropCar = 'pickCarType'.tr();

  Widget carsDropDown(List<CarType> list) {
    return DropdownButton(
      items: list.map((item) {
        return DropdownMenuItem(
          value: item.id,
          child: TextResponsive(
            context.locale == Locale('ar')
                ? item.nameAr.toString()
                : item.name.toString(),
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),isExpanded: true,
      underline: Container(
          decoration: BoxDecoration(
        border: null,
      )),
      hint: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextResponsive(
          _dropCar,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          pickedcarId = value;
          _dropCar = context.locale == Locale('ar')
                ? 
                list.where((v) => v.id == value).first.nameAr.toString():
                list.where((v) => v.id == value).first.name.toString();
        });
        print(pickedcarId);
      },
    );
  }

  int pickedDateId = 0;
  String _dropDate = 'pickDate'.tr();

  Widget datesDropDown(List<Dates> list) {
    return DropdownButton(
      items: list.map((item) {
        return DropdownMenuItem(
          value: item.id,
          child: TextResponsive(
            "${DateTime.parse(item.date).year}" +
                "/" +
                "${DateTime.parse(item.date).month}" +
                "/" +
                "${DateTime.parse(item.date).day}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        );
      }).toList(),isExpanded: true,
      underline: Container(
          decoration: BoxDecoration(
        border: null,
      )),
      hint: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: TextResponsive(
          _dropDate,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {
          pickedDateId = value;
          var date = DateTime.parse(
              list.where((v) => v.id == value).first.date.toString());
          _dropDate =
              "${date.year}" + "/" + "${date.month}" + "/" + "${date.day}";
        });
        print(pickedDateId);
      },
    );
  }

  Future getCarTypes() async {
    try {
      var response = await Dio().get(APIKeys.BASE_URL + 'DeliveryCarTypes');
      var data = response.data as List;
      cars = data.map<CarType>((car) => CarType.fromJson(car)).toList();
      setState(() {
        loading++;
      });
    } on DioError catch (error) {
      setState(() {
        loading++;
      });
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
      setState(() {
        loading++;
      });
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    getUserInfo();
    getLogTrips();
    getCarTypes();
    setValues();
  }

  getLocation() async {
    try {
      loc = await _location.getLocation();
      LatLng latLng = LatLng(loc.latitude, loc.longitude);
      Provider.of<LongLatProvider>(context, listen: false)
          .setLoc(lat: loc.latitude, long: loc.longitude);
      await Provider.of<LastPositionProvider>(context, listen: false)
          .updatePosition(updated: latLng);
      setState(() {
        loading++;
      });
    } catch (e) {
      setState(() {
        loading++;
      });
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'permissiondenied'.tr();
        print(error);
      }
      loc = null;
    }
  }

  String toolbarname = 'CheckOut';

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        loading < 3 || isLoading
            ? Center(child: Load(150.0))
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor),
                      )
                    : !tripPicked
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 100),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBoxResponsive(height: 10),
                                  TextResponsive('picktrip'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                      )),
                                  SizedBoxResponsive(height: 10),
                                  ContainerResponsive(
                                      width: 720,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: tripDropDown(trips)),
                                  SizedBoxResponsive(height: 10),
                                  ContainerResponsive(
                                      width: 720,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: datesDropDown(trips
                                              .where((v) => v.id == tripId)
                                              .isNotEmpty
                                          ? trips
                                              .where((v) => v.id == tripId)
                                              .first
                                              .dates
                                          : trips[0].dates)),
                                  SizedBoxResponsive(height: 10),
                                  Row(
                                    children: [
                                      TextResponsive(
                                          'price'.tr() +
                                              ' : ' +
                                              price(trips, cars) +
                                              ' ${"sr".tr()} ',
                                          style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  SizedBoxResponsive(height: 20),
                                  TextResponsive('pickCarType'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                      )),
                                  SizedBoxResponsive(height: 10),
                                  ContainerResponsive(
                                      width: 720,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: carsDropDown(cars)),
                                  SizedBoxResponsive(height: 30),
                                  GestureDetector(
                                    onTap: () {
                                      if (tripId != 0 &&
                                          pickedcarId != 0 &&
                                          pickedDateId != 0) {
                                        setState(() {
                                          tripPicked = true;
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: 'pickBoth'.tr(),
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                          textColor: Colors.white,
                                        );
                                      }
                                    },
                                    child: Center(
                                        child: ContainerResponsive(
                                            width: 250,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: Center(
                                              child: TextResponsive(
                                                  'continue'.tr(),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white)),
                                            ))),
                                  ),
                                  SizedBoxResponsive(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistorDriver()));
                                    },
                                    child: Center(
                                        child: ContainerResponsive(
                                            width: 250,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                            ),
                                            child: Center(
                                              child: TextResponsive(
                                                  'registorAsDriver'.tr(),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white)),
                                            ))),
                                  ),
                                ]),
                          )
                        : Column(
                            children: <Widget>[
                              SizedBoxResponsive(height: 0),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            tripPicked = false;
                                          });
                                        },
                                        icon: Icon(Icons.arrow_back)),
                                    Text(
                                      'picktripdetails',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                          fontSize: 25),
                                    ).tr(),
                                    Container(width: 10)
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(
                                height: 20,
                              ),
                              GestureDetector(onTap: () async {
                                var locationPicked = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductLocation(
                                              secondPick: false,
                                            )));
                                if (locationPicked) {
                                  setState(() {
                                    lat = Provider.of<LongLatProvider>(context,
                                            listen: false)
                                        .lat;
                                    long = Provider.of<LongLatProvider>(context,
                                            listen: false)
                                        .long;
                                  });
                                }
                              }, child: Consumer<LongLatProvider>(
                                builder: (context, longLatProvider, _) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: lat != null && long != null
                                          ? Theme.of(context).accentColor
                                          : Colors.grey[300],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "deliveryLoc".tr(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: lat != null && long != null
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                        lat != null && long != null
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              )
                                            : Icon(
                                                Icons.location_off,
                                                color: Colors.white,
                                              )
                                      ],
                                    ),
                                  );
                                },
                              )),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductLocation(secondPick: true)));
                              }, child: Consumer<LongLatProvider>(
                                builder: (context, longLatProvider, _) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: longLatProvider.lat2 != null &&
                                              longLatProvider.long2 != null
                                          ? Colors.black
                                          : Colors.grey[300],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "pickLoc".tr(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: longLatProvider.lat2 !=
                                                          null &&
                                                      longLatProvider.long2 !=
                                                          null
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                        longLatProvider.lat2 != null &&
                                                longLatProvider.long2 != null
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                              )
                                            : Icon(
                                                Icons.location_off,
                                                color: Colors.white,
                                              )
                                      ],
                                    ),
                                  );
                                },
                              )),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var pickedFile = await showDialog(
                                      context: context,
                                      builder: (context) => MediaPickDialog());
                                  if (pickedFile != null) {
                                    setState(() {
                                      _profileLicenseNumber = pickedFile;
                                    });
                                    getImgUrl();
                                  }
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          _profileLicenseNumber == null
                                              ? 'insertImg'.tr()
                                              : 'photoChoosed'.tr(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                        _profileLicenseNumber == null
                                            ? Icon(Icons.camera_alt,
                                                color: Colors.white)
                                            : Icon(Icons.check,
                                                color: Colors.white)
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  'email',
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
                                  builder: (context) => Container(
                                        margin: EdgeInsets.only(
                                            right: 17, left: 20, top: 5),
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextField(
                                            controller: time,
                                            enabled: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'enterEmailFirst'.tr(),
                                                hintStyle: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black)),
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                              SizedBox(height: 10),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  'phone',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 15),
                                  textAlign: TextAlign.right,
                                ).tr(),
                              ),
                              SizedBox(height: 5),
                              Container(
                                margin: EdgeInsets.only(
                                    right: 17, left: 20, top: 5),
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor),
                                  borderRadius: BorderRadius.circular(5),
                                  // color: Theme.of(context)
                                  //     .secondaryHeaderColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextField(
                                    controller: type,
                                    enabled: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'writePhone'.tr(),
                                        hintStyle: TextStyle(
                                            fontSize: 13, color: Colors.black)),
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(height: 10),
                              Card(
                                elevation: 2,
                                child: Container(
                                    color: Color(0xffeeeeee),
                                    padding: EdgeInsets.all(10.0),
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: 200.0,
                                        ),
                                        child: Scrollbar(
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                reverse: true,
                                                child: SizedBox(
                                                  height: 150.0,
                                                  child: TextField(
                                                    maxLines: 100,
                                                    decoration: InputDecoration(
                                                        icon: Icon(
                                                          Icons.comment,
                                                          color: Colors.black,
                                                        ),
                                                        labelText:
                                                            'orderData'.tr(),
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black54),
                                                        border:
                                                            InputBorder.none,
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black54),
                                                        hintText:
                                                            'writeOrders'.tr()),
                                                    onChanged: (text) {
                                                      print(
                                                          "First text field: $text");
                                                      comments = text;
                                                    },
                                                  ),
                                                ))))),
                              ),
                              _verticalDivider(),
                              ConnectivityWidgetWrapper(
                                stacked: false,
                                offlineWidget: FlatButton(
                                    color: Colors.grey[500],
                                    child: Text('waitingNetwork'.tr()),
                                    textColor: Colors.white,
                                    onPressed: () {},
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    )),
                                child: Consumer<LongLatProvider>(
                                  builder: (context, longLatProvider, _) {
                                    return isLoading
                                        ? FlatButton(
                                            onPressed: () {},
                                            color: Colors.white,
                                            child: CupertinoActivityIndicator(),
                                            textColor: Colors.white,
                                            shape: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ))
                                        : FlatButton(
                                            color:
                                                Theme.of(context).accentColor,
                                            child: const Text('sendOrder').tr(),
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              await sendOrder(
                                                longLatProvider.long,
                                                longLatProvider.lat,
                                                longLatProvider.long2,
                                                longLatProvider.lat2,
                                              );
                                            },
                                            shape: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ));
                                  },
                                ),
                              ),
                            ],
                          ),
              ),
      ],
    );
  }

  Future getImgUrl() async {
    try {
      isLoading = true;
      FormData data = FormData.fromMap({
        'img': await MultipartFile.fromFile(_profileLicenseNumber.path),
      });

      var response = await dioClient.post(
        APIKeys.BASE_URL + 'uploadimage',
        data: data,
      );
      print('REGISTER  $response');
      isLoading = false;
      setState(() {});
      if (response != null) {
        _profileLicenseNumber = response.data;
      } else {
        setState(() {});
        await Fluttertoast.showToast(
            msg: 'tryAgain'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        return response;
      }
    } on DioError catch (error) {
      isLoading = false;

      setState(() {});
      await Fluttertoast.showToast(
          msg: 'tryAgain'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);

      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          return error;
          break;
        default:
          rethrow;
      }
    } catch (error) {
      isLoading = false;

      setState(() {});
      await Fluttertoast.showToast(
          msg: error.response.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return error;
    }
  }

  sendOrder(long, lat, long2, lat2) async {
    if (comments == null) {
      Fluttertoast.showToast(
          msg: 'enterOrderDetails'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (time.text.isEmpty || !time.text.contains('@')) {
      Fluttertoast.showToast(
          msg: 'enterEmailFirst'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (long == null || lat == null || long2 == null || lat2 == null) {
      Fluttertoast.showToast(
          msg: 'pickupAndDelivreyLocationMustNotBeNull'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (_profileLicenseNumber == null) {
      Fluttertoast.showToast(
          msg: 'insertImg'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else if (type.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'writePhoneNumber'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();

        setState(() {
          isLoading = true;
        });
        await prefs.setString("email", time.text);
        var id = pref.getString('userId');
        var email = time.text;
        var response = await Dio().post(APIKeys.BASE_URL + 'sendOrder',
            data: FormData.fromMap({
              'logistticTripId': tripId,
              'image':
                  _profileLicenseNumber != null ? _profileLicenseNumber : '',
              'email': email,
              'description': comments,
              'fromLongtude': lat,
              'fromLatitude': long,
              'toLongtude': lat2,
              'toLatitude': long2,
              'customer': id,
              'phone': type.text,
              'carId': pickedcarId,
              'date': pickedDateId
            }));
        print(response.data['Data']);

        if (response.data['State'] == "sucess") {
          var data = response.data["Data"];
          var shops = data as List;
          Provider.of<LongLatProvider>(context, listen: false)
              .setLoc(lat: null, long: null);
          Provider.of<LongLatProvider>(context, listen: false)
              .setLoc2(lat: null, long: null);
          Provider.of<CartProvider>(context, listen: false).clearCart();
          orderList = shops
              .map<DeliveryHistory>((json) => DeliveryHistory.fromJson(json))
              .toList();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderDone(order: orderList[0], from: 'nearCheckOut')));
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
              msg: response.data['Data'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Theme.of(context).primaryColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } on DioError catch (error) {
        setState(() {
          isLoading = false;
        });
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
        setState(() {
          isLoading = false;
        });
        throw error;
      }
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );
}
