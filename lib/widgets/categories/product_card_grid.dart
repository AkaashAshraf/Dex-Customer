import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/pages/categories/categories_products_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/services/fav_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductCardGrid extends StatefulWidget {
  final dynamic product;
  final bool boxOn;
  ProductCardGrid({this.product, this.boxOn});

  @override
  _ProductCardGridState createState() => _ProductCardGridState();
}

class _ProductCardGridState extends State<ProductCardGrid> {
  double _endValue = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Consumer<Favorite>(builder: (context, fav, _) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryProductHome(
                        product: widget.product,
                      )));
        },
        child: Center(
          child: Container(
              height: 190,
              width: widget.boxOn ? 170 : width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      if (fav.loading == false) {
                        if (widget.product.fav != true) {
                          await fav.addFav(product: widget.product);
                        } else if (widget.product.fav == true) {
                          await fav.deleteFav(product: widget.product);
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[500]),
                              child: Icon(
                                  widget.product.fav == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 20)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 26, right: 25),
                    child: CachedNetworkImage(
                      width: 68,
                      height: 65,
                      imageUrl:
                          APIKeys.ONLINE_IMAGE_BASE_URL + widget.product.image,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => ImageLoad(75.0),
                      errorWidget: (context, url, error) => Image.asset(
                        'images/image404.png',
                        width: 78,
                        height: 65,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: 26, right: 25, top: 5, bottom: 0),
                      child: Image.asset(
                        'images/shadow.png',
                        width: 100,
                        height: 8,
                        fit: BoxFit.contain,
                      )),
                  Center(
                      child: FittedBox(
                        child: Text(
                    context.locale == Locale('en')
                          ? widget.product.name.toString()
                          : widget.product.nameAr.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                  ),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _endValue == 48 ? _endValue = 24 : _endValue = 48;
                              Provider.of<CartProvider>(context, listen: false)
                                  .handleCartList([
                                CartItem(
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .cartId,
                                    widget.product,
                                    1,
                                    widget.product.price.toDouble(),
                                    '',
                                    0,
                                    [])
                              ]);
                              if (Provider.of<CartProvider>(context,
                                      listen: false)
                                  .added) {
                                Fluttertoast.showToast(
                                    msg: "productAdded".tr(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    ////timeInSecForIos: 1,
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    textColor: Colors.white,
                                    fontSize: 13.0);
                              }
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).accentColor),
                            child: Center(
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 0),
                                  padding: EdgeInsets.only(bottom: 0),
                                  child: Text(
                                    ' ${widget.product.price} ' + 'sr'.tr(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(right: 0, top: 5),
                                  child: Text(
                                    '(${widget.product.unit} ${widget.product.weight})',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                    textAlign: TextAlign.right,
                                    // textDirection: TextDirection.rtl,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }
}
