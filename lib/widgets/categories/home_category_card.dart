import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/categories/categories.dart';
import 'package:customers/pages/categories/product_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';

class HomeCategoryCard extends StatelessWidget {
  final Category category;
  HomeCategoryCard({this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductHome(
                      category: category,
                    )));
      },
      child: Center(
        child: Container(
            width: 160.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            margin: EdgeInsets.all(5),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 26, right: 25, top: 0),
                  child: CachedNetworkImage(
                    width: 78,
                    height: 75,
                    imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL + category.image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => ImageLoad(75.0),
                    errorWidget: (context, url, error) =>
                        Image.asset('images/image404.png'),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 26, right: 25, top: 0),
                    child: Image.asset(
                      'images/shadow.png',
                      width: 105,
                      height: 8,
                      fit: BoxFit.contain,
                    )),
                SizedBox(height: 10),
                Center(
                    child: Container(
                  child: Text(
                    context.locale == Locale('ar')
                        ? category.nameAr.toString()
                        : category.name.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                )),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 5),
                //   child: Center(
                //       child: Container(
                //     child: Text(
                //       category.description == null
                //           ? category.name.toString()
                //           : category.description,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         fontSize: 15,
                //         color: Colors.black45,
                //       ),
                //     ),
                //   )),
                // ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
    );
  }
}
