import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/product.dart';
import 'package:customers/pages/categories/categories_page.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => CategoryHome(product: product)));
      },
      child: Center(
        child: ContainerResponsive(
            width: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL + product.image,
                      fit: BoxFit.contain,
                      width: 95,
                      height: 95,
                      placeholder: (context, url) => ImageLoad(60.0),
                      errorWidget: (context, url, error) => Image.asset(
                        'images/image404.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ),
                SizedBoxResponsive(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextResponsive(
                        context.locale == Locale('en')
                            ? product.name.toString()
                            : product.nameAr.toString(),
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextResponsive(
                            product.rate.toString(),
                            style: TextStyle(
                                fontSize: 25,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                          Padding(
                            padding: EdgeInsetsResponsive.only(bottom: 5),
                            child: Icon(Icons.star_border,
                                size: ScreenUtil().setSp(23),
                                color: Theme.of(context).secondaryHeaderColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBoxResponsive(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage('images/tag.png'),
                      ),
                      SizedBoxResponsive(width: 10),
                      TextResponsive(
                        context.locale == Locale('ar')
                            ? product.tagsAr.toString()
                            : product.tags.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        TextResponsive(
                          'Delivery',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                        SizedBoxResponsive(width: 10),
                        TextResponsive(
                          product.price.toString() + " OMR",
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}
