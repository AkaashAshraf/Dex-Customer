import 'package:customers/providers/services/last_position_provider.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductLocation extends StatefulWidget {
  final bool secondPick;
  final String from;

  const ProductLocation({Key key, this.secondPick, this.from})
      : super(key: key);
  @override
  ProductLocationState createState() => ProductLocationState();
}

class ProductLocationState extends State<ProductLocation> {
  var location = Location();
  Completer<GoogleMapController> _controller = Completer();
  LatLng _lastPosition;
  Future _getLocation(BuildContext context) async {
    LocationData loc;
    try {
      loc = await location.getLocation();
      Provider.of<LongLatProvider>(context, listen: false)
          .setLoc(lat: loc.latitude, long: loc.longitude);
      _kLake = CameraPosition(
          target: LatLng(loc.latitude, loc.longitude), zoom: 15.4746);
      _goToMyLoction();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        String error = 'Permission denied';
        print(error);
      }
      loc = null;
    }
  }

  var add;
  void _onCameraMove(CameraPosition position) {
    setState(() {
      Provider.of<LongLatProvider>(context, listen: false).setLoc(
          lat: position.target.latitude, long: position.target.longitude);
      add = position.toMap();
    });
  }

  Future<void> _goToMyLoction() async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocation(context);
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.4735, 55.9754),
    zoom: 0.0,
  );

  CameraPosition _kLake;

  @override
  Widget build(BuildContext context) {
    return Consumer<LongLatProvider>(
      builder: (context, longLatPorivder, _) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24),
                child: GoogleMap(
                  // key: "AIzaSyCaw8QnvSlitKZNRIQvJ_KwhzvWfmJORWc",
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onCameraMove: _onCameraMove,
                  onMapCreated: (GoogleMapController controller) {
                    _lastPosition =
                        LatLng(longLatPorivder.lat, longLatPorivder.long);
                    _kLake = CameraPosition(
                        bearing: 192.8334901395799,
                        target: _lastPosition,
                        zoom: 15.4746);
                    _controller.complete(controller);
                  },
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Icon(
                    CupertinoIcons.location_solid,
                    color: Theme.of(context).accentColor,
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      var pref = await SharedPreferences.getInstance();
                      if (widget.from != 'checkout') {
                        if (widget.from != 'main') {
                          if (!widget.secondPick) {
                            pref.setBool('locSelected', true);
                            pref.setDouble('lat', longLatPorivder.lat);
                            pref.setDouble('long', longLatPorivder.long);
                            longLatPorivder.setLoc(
                                lat: longLatPorivder.lat,
                                long: longLatPorivder.long);
                            Provider.of<LastPositionProvider>(context,
                                    listen: false)
                                .updatePosition(
                                    updated: LatLng(longLatPorivder.lat,
                                        longLatPorivder.long));
                          } else {
                            longLatPorivder.setLoc2(
                                lat: longLatPorivder.lat,
                                long: longLatPorivder.long);
                          }
                          Navigator.pop(context, true);
                        } else {
                          pref.setBool('locSelected', true);
                          pref.setDouble('lat', longLatPorivder.lat);
                          pref.setDouble('long', longLatPorivder.long);
                          Navigator.pushReplacementNamed(context, 'home');
                        }
                      } else {
                        longLatPorivder.setLoc(
                            lat: longLatPorivder.lat,
                            long: longLatPorivder.long);
                        Navigator.pop(context, true);
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                      child: Center(
                        child: Text(
                          'confirm',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ).tr(),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
