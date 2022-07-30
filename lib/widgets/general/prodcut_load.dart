import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductLoad extends StatelessWidget {
  final String title;
  ProductLoad({this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        CommonAppBar(
          backButton: true,
          title: title,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 100 * 85,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xffF9F9F9),
                        borderRadius: BorderRadius.circular(2)),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'searchProduct'.tr(),
                        contentPadding: EdgeInsets.only(right: 10, top: 8),
                        hintStyle: TextStyle(fontSize: 15),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                        ),
                      ),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Center(child: Load(150.0))
      ],
    );
  }
}
