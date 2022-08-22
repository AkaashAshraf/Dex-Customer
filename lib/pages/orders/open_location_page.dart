import 'package:customers/providers/services/last_position_provider.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
// import 'package:customers/repositories/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class OpenLocation extends StatefulWidget {
  final LatLng location;

  OpenLocation({this.location});

  @override
  OpenLocationState createState() => OpenLocationState();
}

class OpenLocationState extends State<OpenLocation> {
  var title;
  var location = Location();
  var loc;
  Completer<GoogleMapController> _controller = Completer();

  Future _getLocation() async {
    var location = Location();
    try {
      loc = await location.getLocation();
      Provider.of<LongLatProvider>(context, listen: false)
          .setLoc(lat: loc.latitude, long: loc.longitude);
      Provider.of<LastPositionProvider>(context, listen: false)
          .updatePosition(updated: LatLng(loc.latitude, loc.longitude));
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

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  static LatLng locat;
  @override
  void initState() {
    super.initState();
    locat = widget.location;
    _getLocation();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    //userLocation = await location.getLocation();

    target: LatLng(locat.latitude, locat.longitude),
    zoom: 2.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(locat.latitude, locat.longitude),
      //tilt: 59.440717697143555,
      zoom: 15.4746);

  @override
  Widget build(BuildContext context) {
    return Consumer<LongLatProvider>(
      builder: (context, longLatProvider, _) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 24),
                child: GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onCameraMove: _onCameraMove,
                  onMapCreated: (GoogleMapController controller) {
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
                    onTap: () {
                      Provider.of<LastPositionProvider>(context, listen: false)
                          .updatePosition(
                              updated: LatLng(
                                  longLatProvider.lat, longLatProvider.long));
                      Navigator.pop(context);
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
                        'back',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ).tr()),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
