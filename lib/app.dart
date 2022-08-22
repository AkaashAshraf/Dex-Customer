import 'dart:async';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/pages/account/settings_page.dart';
import 'package:customers/pages/categories/category_page.dart';
import 'package:customers/pages/chat/chat_list_page.dart';
import 'package:customers/pages/orders/orders_page.dart';
import 'package:customers/repositories/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'models/special_offer.dart';
import 'pages/shop/shop_page.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Timer _timer;
  List<SpecialOffer> specialOffer;
  List imgList;
  TabController _tabController;

  List<Widget> pages = [
    HomePage(),
    // CategoryPage(),
    OrdersPage(),
    SettingsPage()
  ];

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, length: pages.length, initialIndex: bottomSelectedIndex);
  }

  void fFt() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool('fft', false);
  }

  void sFt() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool('sft', false);
  }

  void tFt() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool('tft', false);
  }

  void fourFt() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool('fourft', false);
  }

  DateTime onPress;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (onPress == null || now.difference(onPress) > Duration(seconds: 2)) {
      onPress = now;
      Fluttertoast.showToast(
        msg: 'exitApp'.tr(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[500],
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: ConnectivityWidgetWrapper(
        message: 'noInternet'.tr(),
        disableInteraction: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ShowCaseWidget(
              onFinish: () {
                if (showcase == 1) {
                  fFt();
                } else if (showcase == 2) {
                  sFt();
                } else if (showcase == 3) {
                  tFt();
                } else if (showcase == 4) {
                  fourFt();
                }
              },
              builder: Builder(
                builder: (context) => TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: pages,
                ),
              )),
          bottomNavigationBar: AnimatedBottomNav(
              currentIndex: bottomSelectedIndex,
              onChange: (index) {
                setState(() {
                  bottomSelectedIndex = index;
                  _tabController.animateTo(bottomSelectedIndex);
                });
              }),
        ),
      ),
    );
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;
  const AnimatedBottomNav({Key key, this.currentIndex, this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: Icons.home,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).accentColor,
                title: ('mainMenu').tr(),
                isActive: currentIndex == 0,
              ),
            ),
          ),
          // Expanded(
          //   child: InkWell(
          //     onTap: () => onChange(1),
          //     child: BottomNavItem(
          //       icon: Icons.category,
          //       activeColor: Theme.of(context).primaryColor,
          //       inactiveColor: Theme.of(context).accentColor,
          //       title: ('categories').tr(),
          //       isActive: currentIndex == 1,
          //     ),
          //   ),
          // ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: Icons.history,
                title: ('myOrders').tr(),
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).accentColor,
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.person,
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).accentColor,
                title: ('myAccount').tr(),
                isActive: currentIndex == 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final String title;
  const BottomNavItem(
      {Key key,
      this.isActive = false,
      this.icon,
      this.activeColor,
      this.inactiveColor,
      this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 200),
      child: isActive
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isActive == true ? activeColor : inactiveColor,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive == true ? activeColor : inactiveColor,
                    ),
                  ),
                ],
              ),
            )
          : Icon(
              icon,
              color: isActive == true ? activeColor : inactiveColor,
            ),
    );
  }
}
