import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class CartItemCard extends StatelessWidget {
  final bool child;
  final CartItem cartItem;
  final List<CartItem> children;
  CartItemCard({this.cartItem, this.children, this.child});

  @override
  Widget build(BuildContext context) {
    Function eq = const DeepCollectionEquality.unordered().equals;
    var _cartItems =
        Provider.of<CartProvider>(context, listen: false).cartItems;
    return Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: !child
                      ? MediaQuery.of(context).size.width / 100 * 25
                      : MediaQuery.of(context).size.width / 100 * 20,
                  child: Center(
                      child: Text(
                    ' ${cartItem.product.parent == 0 ? cartItem.total : cartItem.total * _cartItems.where((p) => eq(p.children, children)).first.quantity} ' +
                        'sr'.tr(),
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).accentColor),
                    textAlign: TextAlign.right,
                  )),
                ),
                Container(
                  margin: EdgeInsetsResponsive.symmetric(vertical: 20),
                  height: 20,
                  width: 1,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                Container(
                  width: !child
                      ? MediaQuery.of(context).size.width / 100 * 25
                      : MediaQuery.of(context).size.width / 100 * 20,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 30,
                          child: Center(
                            child: Text(
                              cartItem.quantity == null
                                  ? ''
                                  : '${cartItem.product.parent == 0 ? cartItem.quantity : _cartItems.where((p) => eq(p.children, children)).first.quantity}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).accentColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsetsResponsive.symmetric(vertical: 20),
                  height: 20,
                  width: 1,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                Container(
                  width: !child
                      ? MediaQuery.of(context).size.width / 100 * 25
                      : MediaQuery.of(context).size.width / 100 * 20,
                  child: Center(
                      child: Text(
                    cartItem.product.name == null
                        ? ''
                        : context.locale == Locale('en')
                            ? cartItem.product.name.toString()
                            : cartItem.product.nameAr.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).secondaryHeaderColor),
                    textAlign: TextAlign.center,
                    // textDirection: TextDirection.rtl,
                  )),
                ),
                !child
                    ? Container()
                    : Container(
                        margin: EdgeInsetsResponsive.symmetric(vertical: 20),
                        height: 20,
                        width: 1,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                !child
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width / 100 * 20,
                        child: Center(
                            child: Text(
                          cartItem.product.section == null
                              ? ''
                              : context.locale == Locale('en')
                                  ? cartItem.product.section.toString()
                                  : cartItem.product.sectionAr.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).secondaryHeaderColor),
                          textAlign: TextAlign.center,
                          // textDirection: TextDirection.rtl,
                        )),
                      ),
              ],
            ),
          ],
        ));
  }
}
