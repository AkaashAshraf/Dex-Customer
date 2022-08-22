import 'package:customers/pages/general/intro/intro_screen2.dart';
import 'package:customers/widgets/general/animate_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class IntroScreen1 extends StatefulWidget {
  @override
  _IntroScreen1State createState() => _IntroScreen1State();
}

class _IntroScreen1State extends State<IntroScreen1> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 5,
                ),
                SizedBoxResponsive(
                  child: Image.asset(
                    "assets/images/intro_one.png",
                  ),
                  height: MediaQuery.of(context).size.height * .6,
                  width: 450,
                ),
                SizedBox(
                  height: height / 8,
                ),
                Text(
                  'intro1',
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
                //                     exitPage: IntroScreen1(),
                //                     enterPage: IntroScreen2()));
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
