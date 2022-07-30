import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/widgets/general/animate_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class IntroScreen3 extends StatefulWidget {
  @override
  _IntroScreen3State createState() => _IntroScreen3State();
}

class _IntroScreen3State extends State<IntroScreen3> {
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
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 6,
                ),
                SizedBoxResponsive(
                  child: Image.asset(
                    "assets/images/intro_three.png",
                  ),
                  height: 500.0,
                  width: 500.0,
                ),
                SizedBox(
                  height: height / 8,
                ),
                Text(
                  'intro3',
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
                //                     exitPage: IntroScreen3(),
                //                     enterPage: LoginScreen()));
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
