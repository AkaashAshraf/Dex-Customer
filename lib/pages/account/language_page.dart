import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    int activeLanguaue = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),

                /////////// Header
                SizedBox(
                  height: 40,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 25,
                        top: 5,
                        child: Stack(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CartScreen()));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          left: 70,
                          top: 5,
                          child: Container(
                              width: 55,
                              height: 35,
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotificationPage()));
                                  },
                                  child: Image.asset(
                                    'images/ring.PNG',
                                    fit: BoxFit.contain,
                                  )))),
                      Positioned(
                          right: 55,
                          top: 5,
                          child: Text(
                            'appLanguage',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                          ).tr()),
                      Positioned(
                          right: 5,
                          top: 3,
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                    ],
                  ),
                ),

                SizedBox(
                  height: 40,
                ),
                Container(
                    height: 50,
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Text(
                            'appLanguage',
                            style: TextStyle(fontSize: 18),
                          ).tr(),
                        )
                      ],
                    )),

                //Radio Groups
                Container(
                  margin: EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'arabic',
                        style: TextStyle(fontSize: 18),
                      ).tr(),
                      Radio<int>(
                          value: 1,
                          activeColor: Theme.of(context).accentColor,
                          groupValue: 1,
                          onChanged: (int value) {
                            setState(() {
                              activeLanguaue = 1;
                              print(activeLanguaue);
                            });
                          })
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'English',
                        style: TextStyle(fontSize: 18),
                      ),
                      Radio<int>(
                          value: 2,
                          activeColor: Theme.of(context).accentColor,
                          groupValue: 1,
                          onChanged: (int value) {
                            setState(() {
                              activeLanguaue = 2;
                              print(activeLanguaue);
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset('images/bottom_town.png')
        ],
      ),
    );
  }
}
