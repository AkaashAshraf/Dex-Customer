import 'package:community_material_icon/community_material_icon.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/providers/account/user_info_provider.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/orders/cart_row.dart';
import 'package:customers/widgets/orders/product_time_loaction_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class CartScreen extends StatefulWidget {
  final CartItem cartItem;
  final provider;

  CartScreen({this.provider, this.cartItem});
  @override
  _CartScreenState createState() => _CartScreenState(provider);
}

class _CartScreenState extends State<CartScreen> {
  var provider;
  _CartScreenState(this.provider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).calculateTotal();
      Provider.of<UserInfoProvider>(context, listen: false).checkIsLoggedIn();
    });
  }

  _cartRow([BuildContext context, int index]) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      if (cartProvider.cartItems != null) {
        if (cartProvider.cartCounter > 0) {
          List<String> child = [];
          for (int i = 0;
              i < cartProvider.parents[index].children.length;
              i++) {
            child.add(cartProvider.parents[index].children[i].product.name
                .toString());
          }
          return CartRow(
            children: child,
            cartItem: cartProvider.parents[index],
          );
        }
        return Center(
          child: Text('noProducts'.tr()),
        );
      }
      return Center(
        child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            title: Icon(
              CommunityMaterialIcons.cart_outline,
              color: Colors.black,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black))),
        body: LayoutBuilder(builder: (context, cons) {
          var _height = cons.maxHeight;
          var _width = cons.maxWidth;
          return ConnectivityWidgetWrapper(
              message: 'noInternet'.tr(),
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  if (cartProvider.cartItems != null) {
                    if (cartProvider.cartCounter > 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          /*** Header One ***/
                          SizedBoxResponsive(
                            height: 30,
                          ),
                          ContainerResponsive(
                            margin:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ContainerResponsive(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(360),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .secondaryHeaderColor),
                                  ),
                                  child: Center(
                                    child: ContainerResponsive(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor),
                                      ),
                                    ),
                                  ),
                                ),
                                ContainerResponsive(
                                    height: 1,
                                    color: Colors.black,
                                    width:
                                        MediaQuery.of(context).size.width * .6),
                                ContainerResponsive(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(360),
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                  ),
                                  child: Center(),
                                ),
                                ContainerResponsive(
                                    height: 1,
                                    color: Colors.black,
                                    width: _width * .6),
                                ContainerResponsive(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(360),
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                  ),
                                  child: Center(),
                                )
                              ],
                            ),
                          ),
                          SizedBoxResponsive(
                            height: cartProvider.cartCounter == 0 ? 200 : 50,
                          ),
                          cartProvider.cartCounter == 0
                              ? Expanded(
                                  child: Column(
                                  children: <Widget>[
                                    Image.asset('images/emptycart.PNG'),
                                    Text(
                                      'cartEmpty',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))
                              : Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          height: _height * .2,
                                          child: _cartRow(context, index));
                                    },
                                    itemCount: cartProvider.parents.length,
                                  ),
                                ),
                          cartProvider.cartCounter == 0
                              ? Container()
                              : Column(
                                  children: <Widget>[
                                    ContainerResponsive(
                                      padding: EdgeInsetsResponsive.symmetric(
                                          horizontal: 20),
                                      color: Colors.white,
                                      height: 70,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'order',
                                            style: TextStyle(fontSize: 18),
                                          ).tr(),
                                          Text(
                                            '${cartProvider.totalCost.toStringAsFixed(3)} ' +
                                                'sr'.tr(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor),
                                            textAlign: TextAlign.right,
                                            // textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 20),
                                    ContainerResponsive(
                                      padding: EdgeInsetsResponsive.symmetric(
                                          horizontal: 20),
                                      color: Colors.white,
                                      height: 90,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'VAT',
                                            style: TextStyle(fontSize: 18),
                                          ).tr(),
                                          Text(
                                            // (vat * 100).toString() + '%', old code
                                            '${(100 * vat)} %',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor),
                                            textAlign: TextAlign.right,
                                            // textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 20),
                                    ContainerResponsive(
                                      padding: EdgeInsetsResponsive.symmetric(
                                          horizontal: 20),
                                      color: Colors.white,
                                      height: 90,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'total',
                                            style: TextStyle(fontSize: 18),
                                          ).tr(),
                                          Text(
                                            '${cartProvider.totalCostWithVAT.toStringAsFixed(3)} ' +
                                                'sr'.tr(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor),
                                            textAlign: TextAlign.right,
                                            // textDirection: TextDirection.rtl,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 50),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Consumer<UserInfoProvider>(
                                            builder: (context, value, child) {
//                                    if (value.isLoggedIn != null) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductTimeAndLocationDetails(
                                                              provider:
                                                                  cartProvider
                                                                      .cartItems[
                                                                          0]
                                                                      .product
                                                                      .shop)));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15.0),
                                              child: ContainerResponsive(
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsetsResponsive
                                                    .symmetric(horizontal: 20),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.black),
                                                child: Center(
                                                    child: Text(
                                                  'pay',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ).tr()),
                                              ),
                                            ),
                                          );
                                        }
//                                    return Center(
//                                      child: CircularProgressIndicator(
//                                          backgroundColor:
//                                          Theme
//                                              .of(context)
//                                              .primaryColor),
//                                    );
//                                  },
                                            )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )
                        ],
                      );
                    }
                    return Center(
                      child: Text('noProducts'.tr()),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor),
                  );
                },
              ));
        }));
  }
}
