import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/shop/near_shop.dart';
import 'package:customers/pages/orders/map_page.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/providers/shop/near_shops_provider.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/utils/calc_distance.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class TravelDestinationItem extends StatefulWidget {
  TravelDestinationItem(
      {Key key, @required this.destination, @required this.myLoc});
  final NearShop destination;
  final LocationData myLoc;

  @override
  _TravelDestinationItemState createState() => _TravelDestinationItemState();
}

class _TravelDestinationItemState extends State<TravelDestinationItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<NearShopProvider>(context, listen: false).myLocation ==
          null) {
        Provider.of<NearShopProvider>(context, listen: false).getLocation();
      }

      // Provider.of<PermissionsProvider>(context, listen: false).checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Container(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                nearShopClass = widget.destination;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapSample(
                              from: 'shops',
                              loc: widget.myLoc,
                            )));
              },
              child: Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // photo and title
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.destination.icon.toString(),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                            backgroundColor:
                                                Theme.of(context).primaryColor),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ), // cashed network

                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.all(5.0),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 20.0, 20.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0.0),
                                        child: Text(
                                          widget.destination.name,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      // rate Star

                                      Container(
                                        padding: EdgeInsets.all(2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 5, left: 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('K.M'),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4.0, left: 5, right: 5),
                                            child: buildText(),
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            // color: globals.accentcolor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  dynamic myText;
  dynamic text;
  Text buildText() {
    myText = distMath(
            widget.destination.geometry.location.lng,
            widget.destination.geometry.location.lat,
            widget.myLoc.latitude,
            widget.myLoc.longitude)
        .toString();
    text = 'كلم';
    return Text(
      myText[0] + myText[1] + myText[2],
    );
  }
}
