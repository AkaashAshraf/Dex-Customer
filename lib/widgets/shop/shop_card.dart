import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/pages/shop/provider_page.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  ShopCard({this.shop});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProviderScreen(provider: shop)));
      },
      child: Center(
        child: ContainerResponsive(
            heightResponsive: true,
            widthResponsive: true,
            width: 525,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsetsResponsive.all(10),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                ContainerResponsive(
                  heightResponsive: true,
                  widthResponsive: true,
                  width: 400,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL + shop.image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => ImageLoad(200.0),
                    errorWidget: (context, url, error) =>
                        Image.asset('images/image404.png'),
                  ),
                ),
                SizedBoxResponsive(height: 15),
                ContainerResponsive(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextResponsive(
                      context.locale == Locale('ar')
                          ? shop.nameAr.toString()
                          : shop.name.toString(),
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextResponsive(
                          shop.rate.toString(),
                          style: TextStyle(
                              fontSize: 25,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        SizedBoxResponsive(width: 5),
                        Padding(
                          padding: EdgeInsetsResponsive.only(bottom: 5),
                          child: Icon(
                            Icons.star_border,
                            size: ScreenUtil().setSp(23),
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        )
                      ],
                    )
                  ],
                )),
              ],
            )),
      ),
    );
  }
}
