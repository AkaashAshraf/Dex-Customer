import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/product.dart';
import 'package:customers/pages/categories/categories_products_page.dart';
import 'package:customers/providers/services/fav_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class FavCard extends StatefulWidget {
  final dynamic product;
  FavCard({this.product});
  @override
  _FavCardState createState() => _FavCardState(product);
}

class _FavCardState extends State<FavCard> {
  Product product;
  _FavCardState(this.product);

  @override
  Widget build(BuildContext context) {
    return Consumer<Favorite>(builder: (context, fav, _) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryProductHome(
                        product: product,
                      )));
        },
        child: ContainerResponsive(
            margin: EdgeInsetsResponsive.all(30),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey[300],
                  blurRadius: 5,
                  offset: Offset.fromDirection(1.5, 5))
            ], borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: <Widget>[
                ContainerResponsive(
                  margin: EdgeInsets.only(top: 15, left: 25, right: 25),
                  child: CachedNetworkImage(
                    width: 68,
                    height: 65,
                    imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                        widget.product.image.toString(),
                    fit: BoxFit.contain,
                    placeholder: (context, url) => ImageLoad(75.0),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 78,
                      height: 65,
                    ),
                  ),
                ),
                ContainerResponsive(
                    margin:
                        EdgeInsets.only(left: 26, right: 25, top: 5, bottom: 0),
                    child: Image.asset(
                      'images/shadow.png',
                      width: 100,
                      height: 8,
                      fit: BoxFit.contain,
                    )),
                Center(
                    child: Text(
                      (context.locale == Locale('en', ''))
                                      ?
                  widget.product.name.toString() : widget.product.nameAr.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
                SizedBoxResponsive(height: 40),
                ContainerResponsive(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          await fav.deleteFav(product: product);
                        },
                        child: ContainerResponsive(
                          padding: EdgeInsetsResponsive.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[500]),
                          child: Center(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            ContainerResponsive(
                                margin: EdgeInsets.only(left: 0),
                                padding: EdgeInsets.only(bottom: 0),
                                child: Text(
                                  ' ${widget.product.price} ' + 'sr'.tr(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.right,
                                )),
                            ContainerResponsive(
                                margin: EdgeInsets.only(right: 0, top: 5),
                                child: Text(
                                  (context.locale == Locale('en', ''))
                                      ? widget.product.unit == 'غير محدد'
                                          ? 'undefined ${widget.product.weight}'
                                          : '(${widget.product.unit} ${widget.product.weight})'
                                      : '(${widget.product.unitAr} ${widget.product.weight.toString().replaceAll('gram', 'غرام')})', //! change in arabic
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                  textAlign: TextAlign.right,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}
