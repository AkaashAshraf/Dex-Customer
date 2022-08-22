import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/pages/chat/chat_list_page.dart';
import 'package:customers/pages/chat/chat_page.dart';
import 'package:customers/pages/shop/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'intro_screen1.dart';
import 'intro_screen2.dart';
import 'intro_screen3.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  var currentPage = 0;
  List<Widget> _introPges = [
    IntroScreen1(),
    IntroScreen2(),
    IntroScreen3(),
  ];
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  _buildPageView() {
    return ContainerResponsive(
      heightResponsive: true,
      widthResponsive: true,
      color: Colors.white,
      child: NotificationListener<OverscrollIndicatorNotification>(
          // ignore: missing_return
          onNotification: (overscroll) {
            overscroll.disallowGlow();
          },
          child: PageView(
            children: _introPges,
            onPageChanged: (int index) {
              pageChanged(index);
            },
            controller: pageController,
          )),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _currentPageNotifier.value = index;
      currentPage = index;
    });
  }

  _buildCircleIndicator() {
    return Positioned(
      top: 70 / 2,
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsetsResponsive.all(0),
            child: CirclePageIndicator(
              selectedSize: 10,
              dotColor: Color(0xfffdd4ee),
              selectedDotColor: Theme.of(context).accentColor,
              size: 10,
              itemCount: _introPges.length,
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    ResponsiveWidgets.init(
      context,
      height: 1600,
      width: 720,
      allowFontScaling: true,
    );

    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: <Widget>[
              _buildPageView(),
              _buildCircleIndicator(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonTheme(
                  height: MediaQuery.of(context).size.height * .07,
                  minWidth: width / 1.3,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'continue'.tr(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
