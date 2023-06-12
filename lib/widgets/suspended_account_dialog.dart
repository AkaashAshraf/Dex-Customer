import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showSuspendedAccountDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: ListTile(
          title: Text(
            "accountSuspended".tr(),
          ),
          subtitle: Text(
            "suspendedAccount".tr(),
          ),
        ),
        actions: <Widget>[
          // FlatButton(
          //   color: Colors.grey[200],
          //   child: Text(
          //     'no',
          //     style: TextStyle(color: Colors.black),
          //   ).tr(),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          FlatButton(
            color: Colors.black,
            child: Text(
              'ok',
              style: TextStyle(color: Colors.white),
            ).tr(),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              // value.prefs.clear();
              Navigator.of(context).pop();
              // bottomSelectedIndex = 0;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      );
    },
  );
}
