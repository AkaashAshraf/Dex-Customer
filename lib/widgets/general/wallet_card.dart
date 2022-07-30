import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/shared_product.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class WalletCard extends StatefulWidget {
  final SharedProduct sharedProduct;
  const WalletCard({Key key, this.sharedProduct}) : super(key: key);

  @override
  _WalletCardState createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  @override
  Widget build(BuildContext context) {
    return ContainerResponsive(
        margin: EdgeInsetsResponsive.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsetsResponsive.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[200],
                blurRadius: 7,
                offset: Offset.fromDirection(1.5, 5))
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              CachedNetworkImage(
                  imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                      widget.sharedProduct.product.image.toString(),
                  width: 75,
                  height: 65),
              SizedBoxResponsive(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextResponsive(
                    context.locale == Locale('ar')
                        ? widget.sharedProduct.product.nameAr.toString()
                        : widget.sharedProduct.product.name.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBoxResponsive(
                    height: 20,
                  ),
                  TextResponsive(
                    '${widget.sharedProduct.product.price.toStringAsFixed(1)}' +
                        ' ' +
                        'sr'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextResponsive(
                "${DateTime.parse(widget.sharedProduct.createdAt).year}" +
                    "/" +
                    "${DateTime.parse(widget.sharedProduct.createdAt).month}" +
                    "/" +
                    "${DateTime.parse(widget.sharedProduct.createdAt).day}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBoxResponsive(height: 20),
              TextResponsive(
                'PointsEarned'.tr() +
                    ' :' +
                    ' ${widget.sharedProduct.points}' +
                    ' ' +
                    'pts'.tr(),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ]));
  }
}
