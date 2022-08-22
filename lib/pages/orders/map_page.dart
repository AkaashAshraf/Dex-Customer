import 'dart:async';

import 'package:customers/models/delivery_history.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/repositories/globals.dart' as globals;
import 'package:customers/utils/calc_distance.dart';
import 'package:customers/utils/permission_status.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class MapSample extends StatefulWidget {
  final from;
  final LocationData loc;
  final DeliveryHistory order;

  MapSample({this.from, this.order, this.loc});

  @override
  State<MapSample> createState() => MapSampleState(from, order, loc);
}

class MapSampleState extends State<MapSample> {
  var from;
  DeliveryHistory order;
  LocationData loc;

  MapSampleState(this.from, this.order, this.loc);

  GoogleMapController _controller;
  bool polyCalled = false;
  bool loading = false;
  var location = Location();
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyD24UJE5__LvBFf6IvrYfVz7Lof9vy8jJw";
  Future _getLocation() async {
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

  List<Marker> marker1 = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<PermissionsProvider>(context, listen: false)
          .checkStatus();
      await _getLocation();
      marker1.clear();
      if (order.orderInfo.shopInfo != null) {
        marker1.add(Marker(
            markerId: MarkerId('shop'),
            draggable: false,
            icon: await BitmapDescriptor.fromAssetImage(
                ImageConfiguration.empty, 'images/shopmarker.png'),
            zIndex: 9.2,
            onTap: () {},
            position: from == 'shops'
                ? LatLng((globals.nearShopClass.geometry.location.lat),
                    (globals.nearShopClass.geometry.location.lng))
                : LatLng(
                    (double.parse(
                        order.orderInfo.shopInfo.Latitude.toString())),
                    double.parse(
                        order.orderInfo.shopInfo.longitude.toString()))));
      }
      marker1.add(Marker(
          markerId: MarkerId('customer'),
          draggable: false,
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration.empty, 'images/location0.png'),
          zIndex: 9.2,
          onTap: () {},
          position: LatLng(order.endLatitude, order.endLongitude)));
      if (order.driverInfo != null) {
        marker1.add(Marker(
            markerId: MarkerId('driver'),
            draggable: false,
            icon: await BitmapDescriptor.fromAssetImage(
                ImageConfiguration.empty, 'images/car.png'),
            zIndex: 9.2,
            onTap: () {},
            position:
                LatLng(order.driverInfo.latitude, order.driverInfo.longtude)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionsProvider>(builder: (context, value, _) {
      return SafeArea(
        child: Scaffold(
            body: loading == false
                ? Column(
                    children: <Widget>[
                      value.permissionStatus !=
                              permission.PermissionStatus.granted
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_off,
                                    size: 40,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Text('locationError',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black))
                                        .tr(),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ContainerResponsive(
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      onCameraMove: (cam) {
                                        // print(cam);
                                      },
                                      markers: Set.from(marker1),
                                      compassEnabled: true,
                                      polylines: _polylines,
                                      myLocationEnabled: true,
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(order.endLatitude,
                                            order.endLongitude),
                                        zoom: 14.4746,
                                      ),
                                      onMapCreated: (controller) async {
                                        if (polyCalled == false) {
                                          setPolylines();
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                      Container(),
                    ],
                  )
                : Center(
                    child: Load(200.0),
                  )),
      );
    });
  }

  dynamic myText;
  dynamic text;
  Text buildText() {
    myText = from == 'shops'
        ? distMath(
            globals.nearShopClass.geometry.location.lng,
            globals.nearShopClass.geometry.location.lat,
            loc.latitude,
            loc.longitude)
        : distMath(
            order.endLongitude, order.endLatitude, loc.latitude, loc.longitude);

    text = 'mins to arrive';
    return Text(
      // widget.destination.rating.toString(),
      (myText / 60).toString(),
      style: TextStyle(fontSize: 12.0, color: Colors.black54),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
    if (_polylines != null) {
      setPolylines();
    }
  }

  setPolylines() async {
    List<LatLng> ctoSLine = [];
    List<LatLng> dtoSLine = [];
    Polyline polyline1;
    Polyline polyline2;

    setState(() {});
    polyCalled = true;
    if (order.orderInfo.shopInfo != null) {
      var _ctoS = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(order.orderInfo.shopInfo.Latitude * 1.0,
              order.orderInfo.shopInfo.longitude * 1.0),
          PointLatLng(
              from == 'shops'
                  ? globals.nearShopClass.geometry.location.lat
                  : order.endLatitude * 1.0,
              from == 'shops'
                  ? globals.nearShopClass.geometry.location.lng
                  : order.endLongitude * 1.0),
          travelMode: TravelMode.driving);
      List<PointLatLng> ctoS = _ctoS.points;
      if (ctoS.isNotEmpty) {
        ctoS.forEach((PointLatLng point) {
          ctoSLine.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

    if (order.driverInfo != null) {
      var _dtoS = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(
              order.driverInfo.latitude * 1.0, order.driverInfo.longtude * 1.0),
          PointLatLng(order.orderInfo.shopInfo.Latitude * 1.0,
              order.orderInfo.shopInfo.longitude * 1.0),
          travelMode: TravelMode.driving);
      List<PointLatLng> dtoS = _dtoS.points;
      if (dtoS.isNotEmpty) {
        dtoS.forEach((PointLatLng point) {
          dtoSLine.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

    setState(() {
      if (order.orderInfo.shopInfo != null) {
        polyline1 = Polyline(
            polylineId: PolylineId("poly1"),
            color: Theme.of(context).accentColor,
            width: 4,
            points: ctoSLine);
      }
      if (order.driverInfo != null) {
        polyline2 = Polyline(
            polylineId: PolylineId("poly"),
            color: Theme.of(context).secondaryHeaderColor,
            width: 4,
            points: dtoSLine);
      }
      if (order.orderInfo.shopInfo != null) {
        _polylines.add(polyline1);
      }
      if (polyline2 != null) {
        _polylines.add(polyline2);
      }
    });
  }
}
