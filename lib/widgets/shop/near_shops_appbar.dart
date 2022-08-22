import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/shop/near_shops_provider.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/repositories/shop_keys.dart';
import 'package:customers/widgets/shop/near_shop_search_dailog.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:showcaseview/showcase.dart';
import 'package:easy_localization/easy_localization.dart';

String text = 'مطاعم';
var selectedLoc;

Text appBarText() {
  if (selectedLoc == 1) {
    text = 'مطاعم';
  } else if (selectedLoc == 2) {
    text = 'كافيهات';
  } else if (selectedLoc == 3) {
    text = 'صيدليات';
  } else if (selectedLoc == 4) {
    text = 'مخابز';
  } else if (selectedLoc == 5) {
    text = 'سوبرماركت';
  } else if (selectedLoc == 6) {
    text = 'جميع المتاجر';
  }
}

bool isSearching = false;

buildAppBar(context) {
  return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: TextResponsive(text,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          )),
      leading: IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.black,
        ),
        onPressed: () {
          Provider.of<NearShopProvider>(context, listen: false).isSearching();
          isSearching = !isSearching;
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: NearShopSearchDailog(),
              // actionsPadding: EdgeInsets.all(50),
              actions: <Widget>[
                FlatButton(
                  color: Colors.grey.shade200,
                  child: Text('إلغاء').tr(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  color: Colors.green,
                  child: Text('بحث').tr(),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Provider.of<NearShopProvider>(context, listen: false)
                        .fetchSearchHistory();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Showcase(
              key: ShopKeys.showcaseSeven,
              overlayOpacity: 0.75,
              showcaseBackgroundColor: Colors.green,
              overlayColor: Colors.blue[200],
              description: 'إضغط هنا لتحديد نوع المتاجر المعروضه',
              disableAnimation: false,
              child: PopupMenuButton<int>(
                  onSelected: (value) async {
                    selectedLoc = value;
                    Provider.of<NearShopProvider>(context, listen: false)
                        .clearLists();
                    var location = Location();

                    final loc = await location.getLocation();
                    appBarText();
                    Provider.of<NearShopProvider>(context, listen: false)
                        .clearLists();
                    if (selectedLoc == 1) {
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataRestaurant(loc.latitude, loc.longitude);
                    } else if (selectedLoc == 2) {
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataCafes(loc.latitude, loc.longitude);
                    } else if (selectedLoc == 3) {
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataPharmacies(loc.latitude, loc.longitude);
                    } else if (selectedLoc == 4) {
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataBakeries(loc.latitude, loc.longitude);
                    } else if (selectedLoc == 5) {
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchSupermarket(loc.latitude, loc.longitude);
                    } else if (selectedLoc == 6) {
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataRestaurant(loc.latitude, loc.longitude);
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataCafes(loc.latitude, loc.longitude);
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataPharmacies(loc.latitude, loc.longitude);
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchDataBakeries(loc.latitude, loc.longitude);
                      Provider.of<NearShopProvider>(context, listen: false)
                          .fetchSupermarket(loc.latitude, loc.longitude);
                    }
                  },
                  child: Icon(Icons.filter_list, size: 25),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 1,
                            height: 40,
                            child: ContainerResponsive(
                              width: 200,
                              height: 50,
                              color: Colors.green,
                              child: Center(
                                  child: TextResponsive('مطاعم',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            )),
                        PopupMenuItem(
                            value: 2,
                            height: 40,
                            child: ContainerResponsive(
                              width: 200,
                              height: 50,
                              color: Colors.green,
                              child: Center(
                                  child: TextResponsive('كافيهات',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            )),
                        PopupMenuItem(
                            value: 3,
                            height: 40,
                            child: ContainerResponsive(
                              width: 200,
                              height: 50,
                              color: Colors.green,
                              child: Center(
                                  child: TextResponsive('صيدليات',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            )),
                        PopupMenuItem(
                            value: 4,
                            height: 40,
                            child: ContainerResponsive(
                              width: 200,
                              height: 50,
                              color: Colors.green,
                              child: Center(
                                  child: TextResponsive('مخابز',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            )),
                        PopupMenuItem(
                            value: 5,
                            height: 40,
                            child: ContainerResponsive(
                              height: 50,
                              width: 200,
                              color: Colors.green,
                              child: Center(
                                  child: TextResponsive('سوبرماركت',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            )),
                        PopupMenuItem(
                            value: 6,
                            height: 40,
                            child: ContainerResponsive(
                              height: 50,
                              width: 200,
                              color: Colors.green,
                              child: Center(
                                  child: TextResponsive('الكل',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                            )),
                      ]),
            ),
            Container(
              width: 55,
              height: 35,
              child: FlatButton(
                  onPressed: () {
                    if (isLogin == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationPage()));
                    }
                  },
                  child: Image.asset(
                    'images/ring.PNG',
                    fit: BoxFit.contain,
                  )),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      'images/crt.png',
                      width: 35,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 2,
                      top: 3,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(39),
                          color: Theme.of(context).accentColor,
                        ),
                        child: Center(child: Consumer<CartProvider>(
                          builder: (context, cartProvider, _) {
                            if (cartProvider != null) {
                              return TextResponsive(
                                cartProvider.cartCounter.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              );
                            }
                            return Container();
                          },
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBoxResponsive(width: 5),
          ],
        )
      ]);
}
