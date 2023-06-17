import 'dart:developer';

import 'package:customers/providers/services/last_position_provider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:location/location.dart' as l;
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Place extends StatefulWidget {
  @override
  _PlaceState createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  String mapKey = "AIzaSyCaw8QnvSlitKZNRIQvJ_KwhzvWfmJORWc";
  Position _pickPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  GoogleMapController _mapController;
  var initialPosition = LatLng(-33.8567844, 151.213108);
  // PickResult selectedPlace;

  var location = l.Location();
  Completer<GoogleMapController> _controller = Completer();
  LatLng _lastPosition;
  Future _getLocation(BuildContext context) async {
    l.LocationData loc;
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
              InkWell(
                // onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  // color: AppColors.whiteshade,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 24),
                child: GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onCameraMove: _onCameraMove,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
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
                    color: Theme.of(context).colorScheme.secondary,
                    size: 30,
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      var pref = await SharedPreferences.getInstance();
                      pref.setBool('locSelected', true);
                      pref.setDouble('lat', longLatPorivder.lat);
                      pref.setDouble('long', longLatPorivder.long);
                      //  setState(() {
                      //    selectedPlace = selectedPlac;
                      //  });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      width: 550,
                      margin: EdgeInsetsResponsive.only(
                        left: 20,
                        right: 20,
                        bottom: 30,
                      ),
                      child: Center(
                        child: Text(
                          'ConfirmLocation'.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
    // return Consumer<LongLatProvider>(builder: (context, longLatPorivder, _) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       iconTheme: IconThemeData(color: Colors.black),
    //       backgroundColor: Colors.white,
    //       title: Icon(
    //         Icons.edit_location,
    //         color: Colors.black,
    //       ),
    //       centerTitle: true,
    //     ),
    //     body: Stack(
    //       children: [
    //         ContainerResponsive(
    //            child: PlacePicker(
    //              initialPosition: initialPosition,
    //              apiKey: 'AIzaSyCaw8QnvSlitKZNRIQvJ_KwhzvWfmJORWc',
    //              hintText: 'enterLocation'.tr(),
    //              automaticallyImplyAppBarLeading: true,
    //              useCurrentLocation: true,
    //              selectInitialPosition: true,
    //              enableMapTypeButton: false,
    //              pinBuilder: (context, state) {
    //                if (state == PinState.Idle) {
    //                  return Image(
    //                    image: AssetImage('images/shopmarker.png'),
    //                    width: 40,
    //                    height: 40,
    //                  );
    //                } else {
    //                  return Image(
    //                    image: AssetImage('images/shopmarker.png'),
    //                    width: 50,
    //                    height: 50,
    //                  );
    //                }
    //              },
    //              selectedPlaceWidgetBuilder:
    //                  (context, selectedPlac, state, isSearching) {
    //                log('selected plase: $selectedPlac');
    //                return Align(
    //                  alignment: Alignment.bottomCenter,
    //                  child: GestureDetector(
    //                    onTap: () async {
    //                      var pref = await SharedPreferences.getInstance();
    //                      pref.setBool('locSelected', true);
    //                      pref.setDouble('lat', selectedPlac.geometry.location.lat);
    //                      pref.setDouble(
    //                          'long', selectedPlac.geometry.location.lng);
    //                      setState(() {
    //                        selectedPlace = selectedPlac;
    //                      });
    //                      Navigator.of(context).pop(selectedPlace);
    //                    },
    //                    child: ContainerResponsive(
    //                        decoration: BoxDecoration(
    //                            color: Colors.black,
    //                            borderRadius: BorderRadius.circular(10)),
    //                        width: 550,
    //                        height: 80,
    //                        margin: EdgeInsetsResponsive.only(
    //                          left: 20,
    //                          right: 20,
    //                          bottom: 30,
    //                        ),
    //                        child: Center(
    //                          child: TextResponsive('ConfirmLocation'.tr(),
    //                              style:
    //                                  TextStyle(fontSize: 27, color: Colors.white)),
    //                        )),
    //                  ),
    //                );
    //              },
    //            ),

    //         Positioned(
    //           bottom: 80,
    //           child: ContainerResponsive(
    //               padding: EdgeInsetsResponsive.symmetric(horizontal: 40),
    //               height: 80,
    //               child: Row(
    //                 children: [
    //                   Icon(Icons.location_on,
    //                       color: Color(0xffED8437), size: 25),
    //                   SizedBoxResponsive(width: 20),
    //                   // TextResponsive(selectedPlace.formattedAddress ?? "",
    //                   //     style: TextStyle(
    //                   //       fontSize: 25,
    //                   //     )),
    //                 ],
    //               )),
    //         ),
    //       ],
    //     ),
    //   );
    // });
  }
}
