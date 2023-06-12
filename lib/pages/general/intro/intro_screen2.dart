import 'package:customers/app.dart';
import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/pages/general/intro/intro_screen3.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/animate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class IntroScreen2 extends StatefulWidget {
  @override
  _IntroScreen2State createState() => _IntroScreen2State();
}

class _IntroScreen2State extends State<IntroScreen2> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 6,
                ),
                SizedBoxResponsive(
                  child: Image.asset(
                    "assets/images/intro_two.png",
                  ),
                  height: 500.0,
                  width: 500.0,
                ),
                SizedBox(
                  height: height / 8,
                ),
                Text(
                  'intro2',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ).tr(),
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: ButtonTheme(
                //       minWidth: width / 1.3,
                //       child: FlatButton(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8.0),
                //           ),
                //           color: Theme.of(context).primaryColor,
                //           onPressed: () {
                //             Navigator.push(
                //                 context,
                //                 EnterExitRoute(
                //                     exitPage: IntroScreen2(),
                //                     enterPage: IntroScreen3()));
                //           },
                //           child: Text(
                //             'متابعة',
                //             style: TextStyle(color: Colors.white),
                //           )),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
