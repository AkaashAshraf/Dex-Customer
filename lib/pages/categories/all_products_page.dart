import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/shop/shop_product_provider.dart';
import 'package:customers/widgets/shop/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class AllProducts extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.all(0.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 40,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 25,
                          top: 7,
                          child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartScreen()));
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Image.asset(
                                'images/cart_gray.PNG',
                                width: 40,
                                height: 35,
                                fit: BoxFit.contain,
                              ),
                              Positioned(
                                right: 2,
                                top: 3,
                                child: Container(
                                  width: 19,
                                  height: 19,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(39),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  child: Center(child: Consumer<CartProvider>(
                                    builder: (context, cartProvider, _) {
                                      if (cartProvider != null) {
                                        return TextResponsive(
                                          cartProvider.cartCounter.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        );
                                      }
                                      return Container();
                                    },
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            left: 70,
                            top: 7,
                            child: Container(
                                width: 55,
                                height: 35,
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationPage()));
                                    },
                                    child: Image.asset(
                                      'images/ring_gray.PNG',
                                      fit: BoxFit.contain,
                                    )))),
                        Positioned(
                            right: 5,
                            top: 3,
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  size: 28,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "allProducts",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ).tr(),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
          Consumer<ShopProductProvider>(
            builder: (context, shopProductProvider, _) {
              if (shopProductProvider.products != null) {
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => ProductCard(),
                    childCount: shopProductProvider.products.length,
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
