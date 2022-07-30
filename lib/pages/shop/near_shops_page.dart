import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../models/shop/near_shop.dart';
import '../../providers/shop/near_shops_provider.dart';
import '../../repositories/globals.dart';
import '../../repositories/shop_keys.dart';
import '../../utils/permission_status.dart';
import '../../widgets/general/loading.dart';
import '../../widgets/shop/near_shops_appbar.dart';
import 'travel_distination_item.dart';

class NearShops_Screen extends StatefulWidget {
  final String toolbarname;

  NearShops_Screen({Key key, this.toolbarname}) : super(key: key);

  @override
  State<StatefulWidget> createState() => shop(toolbarname);
}

class shop extends State<NearShops_Screen> {
  String _searchText = "";
  List searchresult = List();
  Widget appBarTitle = Text(
    "nearShops",
    style: TextStyle(color: Colors.black),
  ).tr();
  List<NearShop> shoplist = List();
  List<NearShop> shoplistFilterd = List();
  List<NearShop> shopsearched = List();
  final List<Item> cart = List();
  int count = 0;

  showShowCase() async {
    var prefs = await SharedPreferences.getInstance();
    bool fourFt = prefs.getBool('fourft');
    if (fourFt != false) {
      ShowCaseWidget.of(context).startShowCase([ShopKeys.showcaseSeven]);
      showcase = 4;
    }
  }

  @override
  void initState() {
    super.initState();
    showShowCase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NearShopProvider>(context, listen: false).getLocation();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String toolbarname;

  shop(this.toolbarname);
  @override
  Widget build(BuildContext context) {
    return Consumer<NearShopProvider>(
      builder: (context, provider, child) {
        if (provider.myLocation != null) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: buildAppBar(context),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: permissionStatus != PermissionStatus.granted
                    ? Center(
                        child: SingleChildScrollView(
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
                                            fontSize: 18, color: Colors.black))
                                    .tr(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : provider.finalShops != null
                        ? provider.finalShops.isEmpty
                            ? Center(
                                child: Text('لا توجد أماكن قريبة'),
                              )
                            : ListView(
                                children: <Widget>[
                                  GridView.count(
                                    primary: true,
                                    crossAxisCount: 1,
                                    childAspectRatio: (200 / 70),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: const EdgeInsets.all(4.0),
                                    physics: ScrollPhysics(),
                                    children: provider.finalShops
                                        .map((NearShop Item) {
                                      return TravelDestinationItem(
                                        destination: Item,
                                        myLoc: provider.myLocation,
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                        : Center(
                            child: CircularProgressIndicator(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                          )),
          );
        }
        return Center(
          child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor),
        );
      },
    );
  }

  bool a = true;
  String mText = "Press to hide";
  double _lowerValue = 1.0;
  double _upperValue = 100.0;

  int radioValue = 0;
  bool switchValue = false;

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }
}
