import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    var string = appInfo.aboutUs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  CommonAppBar(
                    backButton: true,
                    title: 'aboutTheApp'.tr(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Image.asset(
                    'images/wellcome.png',
                    width: 100,
                    height: 90,
                    fit: BoxFit.contain,
                  )),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      string,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      string,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    child: Text(
                      string,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'images/bottom_town.png',
              height: 180,
            )
          ],
        ),
      ),
    );
  }
}
