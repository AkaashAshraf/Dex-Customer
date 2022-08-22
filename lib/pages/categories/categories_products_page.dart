import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/providers/categories/get_products_by_categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:customers/models/orders/cart_item.dart';
import 'package:customers/models/product.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/pages/categories/categories_page.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/services/link_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class CategoryProductHome extends StatefulWidget {
  final String refrence;
  final String from;
  final String refName;
  final Product product;
  final Shop provider;
  CategoryProductHome(
      {this.product, this.provider, this.from, this.refrence, this.refName});
  @override
  _CategoryProductHomeState createState() => _CategoryProductHomeState(
      product: product, provider: provider, from: from, refrence: refrence);
}

class _CategoryProductHomeState extends State<CategoryProductHome> {
  Product product;
  var provider;
  String from;
  String refrence;
  List<CartItem> cartItems = [];
  _CategoryProductHomeState(
      {this.refrence, this.product, this.provider, this.from});

  int quantity = 1;
  var addToCart = false;
  var nextpage;
  var loading2 = false;
  ScrollController scrollController = ScrollController();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  ProgressDialog _pr;
  TextEditingController add = TextEditingController();
  Shop shop;
  double posL = 310;
  double posR = 0;
  double posT = 700;
  double posB = 0;
  Future getShops() async {
    try {
      var response =
          await dioClient.post(APIKeys.BASE_URL + 'getShopInfoByShopId',
              data: FormData.fromMap({
                'shopId': product.shop.toString(),
              }));

      var data = response.data;
      shop = Shop.fromJson(data['Data']);
      provider = shop;
      setState(() {});
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  var childs = [];
  var sections = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getShops();
      _pr = ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      _pr.style(message: "جاري التقييم");
      for (int i = 0; i < product.childProducts.length; i++) {
        product.childProducts[i].isInCart = false;
      }
      getProducts(product.name.toString());
      await Provider.of<CategoyProductProvider>(context, listen: false)
          .getProductChildren(id: product.id, section: provider.sections);
      
      childs =
          Provider.of<CategoyProductProvider>(context, listen: false).children;
          log(childs.toString());
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            loading2 != true) {
          setState(() {
            loading2 = true;
          });
          getMoreProducts();
        }
      });
    });
  }

  void init() async {
    await getShops();
    await getProducts(product.name);
    if (widget.refrence != null && widget.from == 'main') {
      // await getRefName();
    }
  }

  Future onSubmit(double rating) async {
    _pr.show();
    int id = product.id;
    String value = rating.toString();
    try {
      // ignore: unused_local_variable
      var response = await dioClient.get(APIKeys.BASE_URL +
          'rateProduct/CustomerId&$userId"+"ProdcutId&$id/value&$value');
      _pr.hide();

      //var comment = data as List;
      setState(() {
        //comments = comment.map<ShopsComments>((json) => ShopsComments.fromJson(json)).toList();
        //commentLoading = false;
      });
      Fluttertoast.showToast(
          msg: "successed".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } on DioError catch (error) {
      _pr.hide();
      Fluttertoast.showToast(
          msg: "errorRetry".tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  double _endValue = 0;

  List<Product> newestProduct;

  bool loading = true;

  productsCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => CategoryHome(product: newestProduct[index])));
      },
      child: Center(
        child: Container(
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 3,
                ),
                Container(
                  child: CachedNetworkImage(
                    imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                        newestProduct[index].image,
                    fit: BoxFit.contain,
                    width: 50,
                    height: 50,
                    placeholder: (context, url) => ImageLoad(60.0),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                Container(
                    margin:
                        EdgeInsets.only(left: 26, right: 25, top: 3, bottom: 0),
                    child: Image.asset(
                      'images/shadow.png',
                      width: 100,
                      height: 6,
                      fit: BoxFit.contain,
                    )),
                SizedBox(
                  height: 5,
                ),
                Center(
                    child: Text(
                  newestProduct[index].name != null
                      ? context.locale == Locale('en')
                          ? newestProduct[index].name.toString()
                          : newestProduct[index].nameAr.toString()
                      : 'empty',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                )),
              ],
            )),
      ),
    );
  }

  int len = 0;
  getMoreProducts() async {
    if (nextPage != null) {
      var response = await Dio().get(nextPage);
      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var _product = data as List;
      var _productsList =
          _product.map<Product>((json) => Product.fromJson(json)).toList();
      newestProduct = newestProduct + _productsList;
    }
    setState(() {
      loading2 = false;
    });
  }

  Future getProducts(String keywords) async {
    try {
      setState(() {
        loading = true;
      });
      print('GET PRODUCTS START');
      var response = await dioClient.get(APIKeys.BASE_URL +
          'getProducts/keywords=$keywords/orderBy=id&ascOrdesc=desc&regionId=1');

      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var products = data as List;
      newestProduct =
          products.map<Product>((json) => Product.fromJson(json)).toList();

      setState(() {
        loading = false;
        print('GET PRODUCTS DONE');
        len = newestProduct.length;
      });

      print(products.length);
      print(newestProduct[0].name);
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          throw error;
          break;
        default:
          throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    var _height = MediaQuery.of(context).size.height;
    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Consumer<CategoyProductProvider>(builder: (context, pro, _) {
        return Consumer<LinkProvider>(builder: (context, link, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: loading == true
                    ? Center(child: Load(200.0))
                    : Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView(
                                  children: <Widget>[
                                    /*** Header One ***/
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Stack(
                                      children: [
                                        Center(
                                          child: ContainerResponsive(
                                              width: 380,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  CachedNetworkImage(
                                                    imageUrl: APIKeys
                                                            .ONLINE_IMAGE_BASE_URL +
                                                        product.image
                                                            .toString(),
                                                    fit: BoxFit.fill,
                                                    width: 140,
                                                    height: 140,
                                                    placeholder:
                                                        (context, url) =>
                                                            ImageLoad(80.0),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'images/image404.png',
                                                      width: 80,
                                                      height: 80,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 10,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (widget.from != "main") {
                                                Navigator.of(context).pop();
                                              } else {
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        'home');
                                              }
                                            },
                                            child: ContainerResponsive(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                    child: Icon(Icons.clear))),
                                          ),
                                        )
                                      ],
                                    ),
                                    /*** Header Three ***/
                                    SizedBoxResponsive(height: 70),
                                    ContainerResponsive(
                                      margin: EdgeInsetsResponsive.symmetric(
                                          horizontal: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextResponsive(
                                              context.locale == Locale('en')
                                                  ? product.name.toString()
                                                  : product.nameAr.toString(),
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 25),
                                    ContainerResponsive(
                                      margin: EdgeInsetsResponsive.symmetric(
                                          horizontal: 40),
                                      child: Row(
                                        children: [
                                          Image(
                                            image: AssetImage('images/tag.png'),
                                          ),
                                          SizedBoxResponsive(width: 10),
                                          TextResponsive(
                                              context.locale == Locale('ar')
                                                  ? product.tagsAr.toString()
                                                  : product.tags.toString(),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.grey[500])),
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 25),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            context.locale == Locale('en')
                                                ? product.description.toString()
                                                : product.descriptionAr
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          widget.refName == null
                                              ? Container()
                                              : Row(children: [
                                                  Text(
                                                    'productSharedBy'.tr(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    widget.refName.toString(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                ])
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(
                                      height: 70,
                                    ),
                                    ContainerResponsive(
                                      margin: EdgeInsetsResponsive.symmetric(
                                          horizontal: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextResponsive(
                                              product.price.toString(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black)),
                                          SizedBoxResponsive(width: 10),
                                          TextResponsive('sr'.tr(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(height: 70),
                                    ContainerResponsive(
                                      padding: EdgeInsetsResponsive.symmetric(
                                          horizontal: 10, vertical: 10),
                                      margin: EdgeInsetsResponsive.symmetric(
                                          horizontal: 40),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              var pref = await SharedPreferences
                                                  .getInstance();
                                              var name =
                                                  pref.getString('userName');
                                              var id = pref.getString('userId');
                                              await link.generateDynamicLink(
                                                  productName:
                                                      product.name.toString(),
                                                  pic: APIKeys
                                                          .ONLINE_IMAGE_BASE_URL +
                                                      product.image.toString(),
                                                  name: name,
                                                  title: product.id.toString(),
                                                  id: id);
                                              // ignore: unused_local_variable
                                              var _link =
                                                  'https://delieryx.page.link/share?refrence=$id&product=${product.id}';
                                              // if (await canLaunch(
                                              //     link.shortLink.toString())) {
                                              //   launch(link.shortLink.toString());
                                              // } else {
                                              //   print("can't launch");
                                              // }
                                              await FlutterShare.share(
                                                  title: 'Delivery X',
                                                  linkUrl:
                                                      link.shortLink.toString(),
                                                  text:
                                                      "Check This Aewsome Product",
                                                  chooserTitle: "DELIVERY X");
                                            },
                                            child: ContainerResponsive(
                                              padding:
                                                  EdgeInsetsResponsive.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black)),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color: Colors.grey[500],
                                                    size: 20,
                                                  ),
                                                  SizedBoxResponsive(width: 10),
                                                  TextResponsive('share'.tr(),
                                                      style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.black,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*** Header Four ***/
                                    SizedBoxResponsive(
                                      height: 70,
                                    ),
                                    ContainerResponsive(
                                      margin: EdgeInsetsResponsive.symmetric(
                                          horizontal: 40),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextResponsive("Adds".tr(),
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                    SizedBoxResponsive(
                                      height: 20,
                                    ),
                                    Center(
                                      child: ContainerResponsive(
                                          height: 221,
                                          margin:
                                              EdgeInsetsResponsive.symmetric(
                                                  horizontal: 40),
                                          padding:
                                              EdgeInsetsResponsive.symmetric(
                                                  horizontal: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey[400]),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: add,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  maxLines: null,
                                                  textAlignVertical:
                                                      TextAlignVertical.top,
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'writeAdds'.tr(),
                                                      hintStyle: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors
                                                              .grey[500])),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    SizedBoxResponsive(height: 80),
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                quantity++;
                                              });
                                            },
                                            child: ContainerResponsive(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: TextResponsive(
                                                    '+',
                                                    style: TextStyle(
                                                        fontSize: 50,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ),
                                          SizedBoxResponsive(width: 80),
                                          Text(
                                            quantity.toString(),
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                          SizedBoxResponsive(width: 80),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                quantity > 0
                                                    ? quantity--
                                                    : quantity = quantity;
                                              });
                                            },
                                            child: ContainerResponsive(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: TextResponsive(
                                                    '-',
                                                    style: TextStyle(
                                                        fontSize: 50,
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // ****************DONOT DELETE*******************

                                    // Container(
                                    //   margin: EdgeInsets.only(left: 20, right: 20),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //     children: <Widget>[
                                    //       Container(
                                    //         child: Row(
                                    //           children: <Widget>[
                                    //             Icon(
                                    //               Icons.arrow_back_ios,
                                    //               size: 13,
                                    //             ),
                                    //             SizedBox(
                                    //               width: 5,
                                    //             ),
                                    //             GestureDetector(
                                    //               onTap: () {
                                    //                 Navigator.push(
                                    //                     context,
                                    //                     MaterialPageRoute(
                                    //                         builder: (context) =>
                                    //                             AllProducts()));
                                    //               },
                                    //               child: Text(
                                    //                 'showAll',
                                    //                 style: TextStyle(fontSize: 12),
                                    //               ).tr(),
                                    //             )
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {},
                                    //         child: Text(
                                    //           'similarProducts',
                                    //           style: TextStyle(fontSize: 16),
                                    //         ).tr(),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // loading
                                    //     ? Center(child: Load(150.0))
                                    //     : Container(
                                    //         height: 100,
                                    //         child: len > 0
                                    //             ? Stack(
                                    //                 children: [
                                    //                   ListView.builder(
                                    //                     controller: scrollController,
                                    //                     scrollDirection: Axis.horizontal,
                                    //                     itemBuilder: (BuildContext context,
                                    //                         int index) {
                                    //                       return _productsCard(
                                    //                           context, index);
                                    //                     },
                                    //                     itemCount: len,
                                    //                   ),
                                    //                   loading2
                                    //                       ? Positioned(
                                    //                           right: 10,
                                    //                           child: Container(
                                    //                               height: 100,
                                    //                               child: Center(
                                    //                                   child:
                                    //                                       CupertinoActivityIndicator())),
                                    //                         )
                                    //                       : Container(),
                                    //                 ],
                                    //               )
                                    //             : Container(),
                                    //       )

                                    // ********************DONOT DELETE***********************

                                    /*** Adds ON ***/
                                    Container(
                                        height: _height * .2,
                                        child: Consumer<CartProvider>(
                                            builder: (context, cart, _) {
                                          return Consumer<
                                                  CategoyProductProvider>(
                                              builder: (context, products, _) {
                                            return products.loading
                                                ? Load(100.0)
                                                : products.children.isEmpty
                                                    ? Container(
                                                        child: Center(
                                                          child: Text(
                                                            'noProducts'.tr(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: products
                                                            .filteredProducts
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child: Row(
                                                                  children: [
                                                                    products.filteredProducts[index].length ==
                                                                            0
                                                                        ? Container()
                                                                        : TextResponsive(
                                                                            context.locale == Locale('ar')
                                                                                ? products.filteredProducts[index][0].sectionAr.toString()
                                                                                : products.filteredProducts[index][0].section.toString(),
                                                                            style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 30,
                                                                            )),
                                                                  ],
                                                                ),
                                                              ),
                                                              products
                                                                          .filteredProducts[
                                                                              index]
                                                                          .length ==
                                                                      0
                                                                  ? Container()
                                                                  : SizedBox(
                                                                      height:
                                                                          3),
                                                              products.filteredProducts[index]
                                                                          .length ==
                                                                      0
                                                                  ? Container()
                                                                  : Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              3),
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: Colors.black)),
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child: ListView
                                                                          .builder(
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: products
                                                                            .filteredProducts[index]
                                                                            .length,
                                                                        itemBuilder:
                                                                            (contetx,
                                                                                x) {
                                                                          return Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 10),
                                                                            height:
                                                                                _height * .05,
                                                                            child:
                                                                                Center(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Container(margin: EdgeInsetsResponsive.only(bottom: 10), height: 15, width: 7, decoration: BoxDecoration(color: products.filteredProducts[index][x].isInCart == null || products.filteredProducts[index][x].isInCart == false ? Colors.white : Theme.of(context).primaryColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(5), topRight: Radius.circular(5)))),
                                                                                          SizedBoxResponsive(width: 3),
                                                                                          Text(context.locale == Locale('ar') ? products.filteredProducts[index][x].nameAr.toString() : products.filteredProducts[index][x].name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(width: 5),
                                                                                      TextResponsive(
                                                                                          products.filteredProducts[index][x].isRequired == '1'
                                                                                              ? 'required'.tr()
                                                                                              : products.filteredProducts[index][x].isRequired == '2'
                                                                                                  ? 'chooseOne'.tr()
                                                                                                  : 'Optional'.tr(),
                                                                                          style: TextStyle(fontSize: 20))
                                                                                    ],
                                                                                  ),
                                                                                  Row(children: [
                                                                                    Container(
                                                                                      margin: EdgeInsetsResponsive.only(top: 7),
                                                                                      child: Text(
                                                                                        products.filteredProducts[index][x].price.toStringAsFixed(1) + ' ' + 'sr'.tr(),
                                                                                      ),
                                                                                    ),
                                                                                    Checkbox(
                                                                                      activeColor: Theme.of(context).primaryColor,
                                                                                      value: products.filteredProducts[index][x].isInCart == null ? false : products.filteredProducts[index][x].isInCart,
                                                                                      onChanged: (value) {
                                                                                        if (value) {
                                                                                          if (!sections.contains(products.filteredProducts[index][x].section) || products.filteredProducts[index][x].isRequired != '2') {
                                                                                            setState(() {
                                                                                              products.filteredProducts[index][x].isInCart = true;
                                                                                            });
                                                                                            if (products.filteredProducts[index][x].isRequired == '2') {
                                                                                              sections.add(products.filteredProducts[index][x].section);
                                                                                            }
                                                                                            cartItems.add(CartItem(cart.cartId, products.filteredProducts[index][x], 1, products.filteredProducts[index][x].price * 1.0, '', 0, []));
                                                                                            cart.cartIdPlus();
                                                                                            print(cartItems);
                                                                                          } else {
                                                                                            setState(() {
                                                                                              cartItems.where((c) => sections.contains(c.product.section) && c.product.section == products.filteredProducts[index][x].section && c.product.isRequired == '2').first.product.isInCart = false;
                                                                                              cartItems.removeWhere((c) => sections.contains(c.product.section) && c.product.section == products.filteredProducts[index][x].section && c.product.isRequired == '2');
                                                                                              products.filteredProducts[index][x].isInCart = true;
                                                                                            });
                                                                                            cartItems.add(CartItem(cart.cartId, products.filteredProducts[index][x], 1, products.filteredProducts[index][x].price * 1.0, '', 0, []));
                                                                                            cart.cartIdPlus();
                                                                                            print(cartItems);
                                                                                          }
                                                                                        } else {
                                                                                          setState(() {
                                                                                            products.filteredProducts[index][x].isInCart = false;
                                                                                          });
                                                                                          sections.remove(products.filteredProducts[index][x].section);
                                                                                          cartItems.removeWhere((item) => item.product.id == products.filteredProducts[index][x].id);
                                                                                          print(cartItems);
                                                                                        }
                                                                                      },
                                                                                    ),
                                                                                  ])
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                              SizedBoxResponsive(
                                                                  height: 20)
                                                            ],
                                                          );
                                                        });
                                          });
                                        })),
                                    SizedBox(
                                      height: _height * .025,
                                    ),
                                  ],
                                ),
                              ),
                              /*** Bottom ***/
                              Column(
                                children: [
                                  SizedBoxResponsive(height: 0),
                                  addToCart
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  from == 'main'
                                                      ? print(from)
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CartScreen(
                                                                      provider:
                                                                          provider)));
                                                },
                                                child: ContainerResponsive(
                                                  width: 80,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.black,
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                          Icons.check_circle,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ])
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                              GestureDetector(
                                                onTap: () async {
                                                  if (quantity == 0) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "quantityLess".tr(),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        //timeInSecForIos: 1,
                                                        backgroundColor:
                                                            Colors.redAccent,
                                                        textColor: Colors.white,
                                                        fontSize: 15.0);
                                                    return;
                                                  }

                                                  setState(() {
                                                    posL = 50;
                                                    posR =
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            65;
                                                    posT = 50;
                                                    posB =
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            65;
                                                  });

                                                  _endValue == 48
                                                      ? _endValue = 24
                                                      : _endValue = 48;
                                                  var adds = [];
                                                  cartItems.forEach((p) =>
                                                      adds.add(p.product));
                                                  for (int i = 0;
                                                      i < childs.length;
                                                      i++) {
                                                    if (childs[i].isRequired ==
                                                            '1' &&
                                                        !adds.contains(
                                                            childs[i])) {
                                                      Fluttertoast.showToast(
                                                          msg: 'reqMustBeAdded'
                                                              .tr(),
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white);
                                                      return;
                                                    } else if (childs[i]
                                                                .isRequired ==
                                                            '2' &&
                                                        !sections.contains(
                                                            childs[i]
                                                                .section)) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'sectionMustBeAdded'
                                                                  .tr(),
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white);
                                                      return;
                                                    }
                                                  }
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .handleCartList([
                                                    CartItem(
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .cartId,
                                                        product,
                                                        quantity,
                                                        product.price
                                                                .toDouble() *
                                                            quantity,
                                                        add.text.toString(),
                                                        refrence != null
                                                            ? int.parse(
                                                                    refrence) ??
                                                                0
                                                            : 0,
                                                        cartItems)
                                                  ]);
                                                  if (Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .added) {
                                                    setState(() {
                                                      for (int i = 0;
                                                          i < cartItems.length;
                                                          i++) {
                                                        cartItems[i]
                                                            .product
                                                            .isInCart = false;
                                                      }
                                                      addToCart = true;
                                                    });
                                                    await Future.delayed(
                                                        Duration(
                                                            microseconds: 750));
                                                    if (from != 'main') {
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              'home');
                                                    }
                                                  } else {
                                                    setState(() {
                                                      addToCart = false;
                                                    });
                                                  }
                                                  setState(() {});
                                                },
                                                child: ContainerResponsive(
                                                  width: 600,
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                      child: TextResponsive(
                                                    "Add To Cart".tr(),
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white),
                                                  )),
                                                ),
                                              ),
                                            ]),
                                ],
                              ),
                              SizedBoxResponsive(height: 20)
                            ],
                          ),
                        ],
                      ),
              ));
        });
      }),
    );
  }
}

typedef void RatingChangeCallback(double rating);

class StarRating2 extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating2(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Colors.grey,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Colors.orangeAccent,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Colors.orangeAccent,
      );
    }
    return InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}

typedef void MyFormCallback(double rating);

class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;

  MyForm({this.onSubmit});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Rate this Product"),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: StarRating2(
                rating: rating,
                onRatingChanged: (rating) {
                  setState(() => this.rating = rating);
                  print(rating.toString());
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0, top: 20.0),
              child: FlatButton(
                  child: Text("cancel",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0))
                      .tr(),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context, Answer.CANCEL);
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0, top: 20.0),
              child: MaterialButton(
                elevation: 5.0,
                height: 50.0,
                child: Text("continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0))
                    .tr(),
                color: Colors.green,
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSubmit(rating);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum Answer { OK, CANCEL }
