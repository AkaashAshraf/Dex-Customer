import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../models/shops.dart';
import '../../pages/categories/categories_products_page.dart';
import 'package:easy_localization/easy_localization.dart';

class ProviderProductsListCard extends StatelessWidget {
  final Product product;
  final Shop shop;
  ProviderProductsListCard({this.product, this.shop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryProductHome(product: product, provider: shop)));
        },
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      context.locale == Locale('en')
                          ? product.name != null
                              ? product.name
                              : ''
                          : product.nameAr,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      textAlign: TextAlign.right,
                      // textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 5, top: 5),
                        child: Text(
                          '${product.price} ' + 'sr'.tr(),
                          style: TextStyle(fontSize: 11, color: Colors.black),
                          textAlign: TextAlign.right,
                          // textDirection:TextDirection.rtl,
                        )),
                  ],
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: CachedNetworkImage(
                  imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL + product.image,
                  width: 66,
                  height: 66,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ImageLoad(65.0),
                  errorWidget: (context, url, error) => Image.asset(
                    'images/image404.png',
                    width: 66,
                    height: 66,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
