import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/app.dart';
import 'package:customers/models/delivery_history.dart';
import 'package:customers/pages/orders/order_details_page.dart';
import 'package:customers/pages/orders/rate_page.dart';
import 'package:customers/repositories/globals.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderDone extends StatefulWidget {
  final DeliveryHistory order;
  final String from;

  OrderDone({this.order, this.from});

  @override
  _OrderDoneState createState() => _OrderDoneState(order, from);
}

class _OrderDoneState extends State<OrderDone> {
  DeliveryHistory order;
  String from;

  _OrderDoneState(this.order, this.from);
  @override
  void initState() {
    super.initState();
    detailsFrom = 2;
  }

  Future<bool> onBackPress() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ConnectivityWidgetWrapper(
          message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/done.PNG',
                width: 100,
                height: 100,
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                'orderSent',
                style: TextStyle(
                    fontSize: 23, color: Theme.of(context).accentColor),
              ).tr()),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Text(
                'storeNotification',
                style: TextStyle(fontSize: 13, color: Color(0xff707070)),
              ).tr()),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  if (from == 'nearCheckOut') {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('home');
                  } else {
                    Navigator.popUntil(context, ModalRoute.withName('home'));
                    Navigator.of(context).pushReplacementNamed('home');
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width / 100 * 91,
                    margin: EdgeInsets.only(right: 17, left: 20, top: 5),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        'backMain',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ).tr(),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('home'));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetails(
                                order: order,
                              )));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width / 100 * 91,
                    margin: EdgeInsets.only(right: 17, left: 20, top: 5),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        'orderTracking'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
