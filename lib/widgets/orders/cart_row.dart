import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/orders/product_in_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class CartRow extends StatelessWidget {
  final CartItem cartItem;
  final List<String> children;

  CartRow({this.cartItem, this.children});

  @override
  Widget build(BuildContext context) {
    ScrollController scr = ScrollController();
    return LayoutBuilder(builder: (context, cons) {
      var _height = cons.maxHeight;
      var _width = cons.maxWidth;
      return Dismissible(
        key: Key(cartItem.id.toString()),
        onDismissed: (direction) {
          Provider.of<CartProvider>(context, listen: false)
              .removeCartItemById(itemId: cartItem.id);
        },
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete,
            size: 50,
            color: Colors.white,
          ),
        ),
        child: Container(
          margin: EdgeInsetsResponsive.symmetric(
              horizontal: _width * .09, vertical: _height * .03),
          padding: EdgeInsetsResponsive.symmetric(horizontal: _width * .08),
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(width: 2, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CachedNetworkImage(
                width: _width * .235,
                height: _height * .65,
                imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                    cartItem.product.image.toString(),
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                    child: Image.asset(
                  'images/loading.gif',
                  width: _width * .235,
                  height: _height * .65,
                )),
                errorWidget: (context, url, error) => Image.asset(
                  'images/image404.png',
                  width: _width * .235,
                  height: _height * .65,
                ),
              ),
              SizedBox(width: _width * .05),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: _height * .09),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductInCart(cartItem)));
                        },
                        child: Text(
                          cartItem.product.name.toString(),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      children.isNotEmpty
                          ? Row(
                              children: [
                                Text('${'adds'.tr()} : ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                                Expanded(
                                  child: SingleChildScrollView(
                                      controller: scr,
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                          '${children.toString().substring(1, children.toString().length - 1)}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15))),
                                ),
                                // Expanded(
                                //     child: SingleChildScrollView(
                                //         controller: bar,
                                //         scrollDirection: Axis.horizontal,
                                //         child: Text(
                                //             'aevhoewihvipoweghpwoighwipoghwpoeghwpeoghewio',
                                //             style: TextStyle(
                                //                 color: Colors.white))))
                              ],
                            )
                          : Container(),
                      Container(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    cartItem.product.price.toString(),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  Text('  '),
                                  Text(
                                    'OMR',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ).tr(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .addCartItem(
                                                    cartItem: cartItem);
                                          },
                                          child: Container(
                                              height: _height * .16,
                                              width: _width * .06,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: TextResponsive('+',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25)),
                                              )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: _width * .035),
                                          child: Text(
                                            cartItem.quantity.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .removeCartItem(
                                                    cartItem: cartItem);
                                          },
                                          child: Container(
                                              height: _height * .16,
                                              width: _width * .06,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: TextResponsive('-',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 25)),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
