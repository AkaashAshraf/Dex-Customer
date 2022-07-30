import 'package:customers/models/orders/cart_products.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class OrderDetailsCartItem extends StatelessWidget {
  final CartProdcuts cartProdcut;
  final bool child;
  OrderDetailsCartItem({this.cartProdcut, this.child});

  @override
  Widget build(BuildContext context) {
    var count = cartProdcut.price;
    var total = count * cartProdcut.quantity;
    var width = MediaQuery.of(context).size.width;
    return ContainerResponsive(
        widthResponsive: true,
        heightResponsive: true,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: <Widget>[
            ContainerResponsive(
              margin: EdgeInsetsResponsive.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ContainerResponsive(
                    width: child ? width / 4 : width / 3,
                    // height: 100,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ContainerResponsive(
                            // product name
                            widthResponsive: true,
                            heightResponsive: true,
                            child: ContainerResponsive(
                              decoration: BoxDecoration(
                                border: Border(),
                              ),
                              child: Center(
                                  child: TextResponsive(
                                context.locale == Locale('en')
                                    ? cartProdcut.productName.toString()
                                    : cartProdcut.productNameAr.toString(),
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                // textDirection: TextDirection.rtl,
                              )),
                            ),
                          ),
                          SizedBoxResponsive(height: 15),
                          ContainerResponsive(
                            // shop name
                            widthResponsive: true,
                            heightResponsive: true,
                            child: Center(
                                child: ContainerResponsive(
                              width: 100,
                              child: TextResponsive(
                                context.locale == Locale('ar')
                                    ? cartProdcut.shopnameAr.toString()
                                    : cartProdcut.shopname.toString(),
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).accentColor,
                                ),
                                textAlign: TextAlign.center,
                                // textDirection: TextDirection.rtl,
                              ),
                            )),
                          ),
                        ]),
                  ),
                  Container(height: 20, width: 1, color: Colors.grey[600]),
                  ContainerResponsive(
                    width: child ? width / 4 : 550 / 3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ContainerResponsive(
                            // product price
                            widthResponsive: true,
                            heightResponsive: true,
                            child: ContainerResponsive(
                              decoration: BoxDecoration(
                                border: Border(),
                              ),
                              child: Center(
                                  child: TextResponsive(
                                count.toStringAsFixed(3) + ' ' + 'sr'.tr(),
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.right,
                                // textDirection: TextDirection.rtl,
                              )),
                            ),
                          ),
                        ]),
                  ),
                  Container(height: 20, width: 1, color: Colors.grey[600]),
                  ContainerResponsive(
                    // total price
                    widthResponsive: true,
                    heightResponsive: true,

                    width: child ? width / 4 : 550 / 3,
                    // height: 100,
                    // height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextResponsive(
                          'total'.tr(),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor),
                        ),
                        SizedBoxResponsive(height: 15),
                        Center(
                            child: TextResponsive(
                          total.toStringAsFixed(3) +' '+ 'sr'.tr(),
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor),
                          textAlign: TextAlign.right,
                        )),
                      ],
                    ),
                  ),
                  !child
                      ? Container()
                      : Container(
                          height: 20, width: 1, color: Colors.grey[600]),
                  !child
                      ? Container()
                      : ContainerResponsive(
                          width: child ? width / 4 : 0,
                          child: Text(context.locale == Locale('en')
                              ? cartProdcut.section.toString()
                              : cartProdcut.sectionAr.toString())),
                ],
              ),
            ),
          ],
        ));
  }
}
