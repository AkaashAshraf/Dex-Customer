import 'package:customers/providers/shop/near_shops_provider.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class NearShopSearchDailog extends StatelessWidget {
  TextEditingController _shopcontroller = TextEditingController();
  TextEditingController _citycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 26, right: 26),
            child: TextField(
              controller: _shopcontroller,
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: "storeName".tr(),
                  hintStyle: TextStyle(color: Colors.black)),
              onChanged: (value) {
                Provider.of<NearShopProvider>(context, listen: false)
                    .lastShopName(shopName: value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 26, right: 26),
            child: TextField(
              controller: _citycontroller,
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: "city".tr(),
                  hintStyle: TextStyle(color: Colors.black)),
              onChanged: (value) {
                Provider.of<NearShopProvider>(context, listen: false)
                    .lastCity(city: value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
