import 'package:customers/pages/orders/near_checkout_page.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:customers/repositories/globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

class SetLocation extends StatefulWidget {
  @override
  State<SetLocation> createState() => SetLocationState();
}

class SetLocationState extends State<SetLocation> {
  Completer<GoogleMapController> _controller = Completer();
//var currentLocation = LocationData;
  var location = Location();

  Future _getLocation(BuildContext context) async {
    LocationData loc;
    var location = Location();
    try {
      loc = await location.getLocation();
      Provider.of<LongLatProvider>(context, listen: false)
          .setLoc(lat: loc.latitude, long: loc.longitude);

      _goToMyLoction();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
        print(error);
      }
      loc = null;
    }
  }

  List<Marker> marker1 = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      marker1.clear();
      marker1.add(Marker(
          markerId: MarkerId('customer'),
          draggable: false,
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration.empty, 'images/market.png'),
          zIndex: 9.2,
          onTap: () {},
          position: LatLng((globals.nearShopClass.geometry.location.lat),
              (globals.nearShopClass.geometry.location.lng))));
      _getLocation(context);
    });
  }

  static CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(globals.nearShopClass.geometry.location.lat,
          globals.nearShopClass.geometry.location.lng),
      //tilt: 59.440717697143555,
      zoom: 14.4746);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Checkout()));
            }),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'map',
          style: TextStyle(color: Colors.black),
        ).tr(),
        //  backgroundColor: globals.appbarcolor,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            // markers: (null),
            compassEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(globals.nearShopClass.geometry.location.lat,
                  globals.nearShopClass.geometry.location.lng),
              zoom: 14.4746,
            ),
          ), // maps
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 60.0,
                ),
              )),
          Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () {
                  _getLocation(context);
                  Navigator.pop(context);
                },
                child: const Text('detectLocation',
                        style: TextStyle(fontSize: 14, color: Colors.white))
                    .tr(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _goToMyLoction() async {
    GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    isLogin();
  }

  isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final logedinstate = prefs.getString('logedinstate') ?? '';
    print(logedinstate);
    if (logedinstate == 'true') {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => Home_screen()));
    } else {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => Login_Screen()));

    }
  }

  @override
  void initState() {
    super.initState();
    // startTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(30.0),
        width: 250.0,
        height: 250.0,
        child: Image.asset(
          'images/gro.jpg',
        ),
      ),
    );
  }
}
