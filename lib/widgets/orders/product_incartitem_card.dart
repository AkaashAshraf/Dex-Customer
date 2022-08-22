import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductInCartItem extends StatelessWidget {
  final CartItem cartItem;
  ProductInCartItem({this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        if (cartProvider.cartItems != null) {
          if (cartProvider.cartCounter > 0) {
            return Container(
              height: 40,
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.3, color: Color(0xff505050)),
                  bottom: BorderSide(width: 0.3, color: Color(0xff505050)),
                ),
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .removeCartItemById(itemId: cartItem.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 100 * 15,
                      child: Center(
                          child: IconButton(
                              icon: Icon(
                                CupertinoIcons.clear_circled,
                                color: Colors.red,
                              ),
                              onPressed: null)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 100 * 23,
                    child: Center(
                        child: Text(
                      '${cartItem.total} ' + 'sr'.tr(),
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).accentColor),
                      textAlign: TextAlign.right,
                      // textDirection: TextDirection.rtl,
                    )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 100 * 29,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.3, color: Color(0xffEBEBEB))),
//            color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 0.5,
                              color: Theme.of(context).secondaryHeaderColor),
                          right: BorderSide(
                              width: 0.5,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              final tile = cartProvider.cartItems
                                  .firstWhere((item) => item.id == cartItem.id);
                              Provider.of<CartProvider>(context, listen: false)
                                  .removeCartItem(cartItem: tile);
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                child: Image.asset('images/minus.PNG')),
                          ),
                          Container(
                            width: 30,
                            child: Center(
                              child: Text(
                                '${cartItem.quantity}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final tile = cartProvider.cartItems
                                  .firstWhere((item) => item.id == cartItem.id);
                              Provider.of<CartProvider>(context, listen: false)
                                  .addCartItem(cartItem: tile);
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                child: Image.asset('images/greenadd.PNG')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 100 * 32,
                    child: Center(
                        child: Text(
                      '${cartItem.product.name}',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).secondaryHeaderColor),
                      textAlign: TextAlign.right,
                      // textDirection: TextDirection.rtl,
                    )),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text('لا توجد عناصر'),
          );
        }
        return Center(
          child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor),
        );
      },
    );
  }
}
