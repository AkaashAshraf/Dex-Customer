import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/widgets/orders/product_incartitem_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInCart extends StatefulWidget {
  CartItem cartItem;

  ProductInCart(this.cartItem);

  @override
  _ProductInCartState createState() => _ProductInCartState(cartItem);
}

class _ProductInCartState extends State<ProductInCart> {
  CartItem cartItem;
  var totalCost = 0.0;

  _ProductInCartState(this.cartItem);
  @override
  void initState() {
    super.initState();
    totalCost = cartItem.total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        if (cartProvider.cartItems != null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      /*** Header One ***/
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 25,
                              top: 5,
                              child: Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen()));
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  Image.asset(
                                    'images/crt.png',
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
                                      child: Center(
                                          child: Text(
                                        cartProvider.cartCounter.toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                left: 70,
                                top: 5,
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
                                          'images/ring.PNG',
                                          fit: BoxFit.contain,
                                        )))),
                            Positioned(
                                right: 55,
                                top: 3,
                                child: Text(
                                  'orderDetails',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w300,
                                      color: Theme.of(context).accentColor),
                                ).tr()),
                            Positioned(
                                right: 5,
                                top: 3,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })),
                          ],
                        ),
                      ),

                      /*** Header Two ***/
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: 25, left: 25, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Color(0xffF2F2F2)),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(right: 8),
                                      child: Text(
                                        'alfares',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.right,
                                      ).tr()),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        'riyadh',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.right,
                                      ).tr(),
                                      Icon(
                                        Icons.location_on,
                                        size: 15,
                                        color: Theme.of(context).accentColor,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 90,
                              margin: EdgeInsets.only(right: 5),
                              child: Image.asset('images/fruit.PNG'),
                            )
                          ],
                        ),
                      ),

                      /*** Header Three ***/
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        color: Theme.of(context).secondaryHeaderColor,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 30),
                                child: Text(
                                  'purchasesList',
                                  style: TextStyle(fontSize: 18),
                                ).tr())
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) => ProductInCartItem(
                          cartItem: cartProvider.cartItems[index],
                        ),
                        itemCount: 1,
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).accentColor,
                      height: 50,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text(
                                '$totalCost ' + 'sr'.tr(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).accentColor),
                                textAlign: TextAlign.right,
                                // textDirection: TextDirection.rtl,
                              )),
                          Container(
                              margin: EdgeInsets.only(right: 30),
                              child: Text(
                                'total',
                                style: TextStyle(fontSize: 18),
                              ).tr()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 100 * 85,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).accentColor),
                            child: Center(
                                child: Text(
                              'edit',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ).tr()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
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
