import 'dart:core' as prefix0;
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/product.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/models/special_offer.dart';
import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:customers/widgets/shop/provider_products_list_card.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customers/providers/shop/shops_provider.dart';
import 'package:customers/widgets/general/appbar_widget.dart';

class ProviderScreen extends StatefulWidget {
  final Shop provider;
  final SpecialOffer specialOffer;
  final String from;

  ProviderScreen({this.provider, this.specialOffer, this.from});

  @override
  _ProviderScreenState createState() =>
      _ProviderScreenState(provider, specialOffer, from);
}

class _ProviderScreenState extends State<ProviderScreen> {
  Shop provider;
  SpecialOffer specialOffer;
  String from;

  _ProviderScreenState(this.provider, this.specialOffer, this.from);

  var loading = false;
  var loading2 = false;
  var commentLoading = false;
  List<Product> productsList = [];
  List<ShopsComments> comments = [];
  var tabbed = 1;
  var myComment = TextEditingController();
  var nextPage;
  ScrollController scrollController = ScrollController();

  BoxDecoration activeTab = BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xff09C215), width: 3)));

  getMoreProducts() async {
    if (nextPage != null) {
      var response = await Dio().get(nextPage);
      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var _product = data as List;
      var _productsList =
          _product.map<Product>((json) => Product.fromJson(json)).toList();
      _productsList.forEach(
          (product) => product.parent == 0 ? productsList.add(product) : null);
    }
    setState(() {
      loading2 = false;
    });
  }

  Future getProducts(int shopId) async {
    try {
      var response = await dioClient.get(APIKeys.BASE_URL +
          'getProducts/shopId=$shopId&catId&all&OrderBy_vield=id&regionId=$regionId');

      var data = response.data['data'];
      nextPage = response.data['next_page_url'];
      var products = data as List;
      var _productsList =
          products.map<Product>((json) => Product.fromJson(json)).toList();
      _productsList.forEach(
          (product) => product.parent == 0 ? productsList.add(product) : null);
      setState(() {
//        loading += 1;
      });
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

  Future addComment(String myComment) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      commentLoading = true;
      var response = await dioClient.get(APIKeys.BASE_URL +
          'commentShop/UserId&${pref.getString('userId')}/ShopId&${provider.id}/comment&$myComment');
      print(response.data);
      if (response.data['State'] == 'sucess') {
        var data = response.data['Data'];
        var comment = data as List;
        setState(() {
          comments = comment
              .map<ShopsComments>((json) => ShopsComments.fromJson(json))
              .toList();
          commentLoading = false;
        });
        Provider.of<ShopsProvider>(context, listen: false).reducdeRegion();
        Provider.of<ShopsProvider>(context, listen: false).getShopsByRegion();
        Fluttertoast.showToast(
            msg: "commentAdded".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Theme.of(context).accentColor,
            fontSize: 16.0);
      }
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

  getShopDetails(var shopId) async {
    try {
      setState(() {
        loading = true;
      });
      var response = await Dio().post(APIKeys.BASE_URL + 'getShopInfoByShopId',
          data: FormData.fromMap({
            "shopId": shopId,
          }));
      var data = response.data['Data'];
      provider = Shop.fromJson(data);
      getProducts(provider.id);
      setState(() {
        loading = false;
      });
    } on DioError catch (error) {
      setState(() {
        loading = false;
      });
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
      setState(() {
        loading = false;
      });
      throw error;
    }
  }

  ProgressDialog _pr;

  @override
  void initState() {
    _pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    _pr.style(message: "rating".tr());
    super.initState();
    // comments = provider.shopsComments;

    if (from == 'special') {
      getShopDetails(specialOffer.shopId);
    } else {
      getProducts(provider.id);
//      loading += 1;
    }
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
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var mediaQuery;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    if (!loading) {
      return Scaffold(body: _tabView());
    } else {
      return Scaffold(body: Center(child: Load(200.0)));
    }
    // ignore: dead_code
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        if (cartProvider.cartItems != null) {
          return Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            body: loading == true
                ? Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      SizedBoxResponsive(
                        height: 80,
                        child: ContainerResponsive(
                          width: 720,
                          child: ContainerResponsive(
                            padding:
                                EdgeInsetsResponsive.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen()));
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        ContainerResponsive(
                                          width: 60,
                                          height: 60,
                                          child: Image.asset(
                                            'images/crt.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        ContainerResponsive(
                                          margin: EdgeInsetsResponsive.only(
                                              left: Localizations.localeOf(
                                                              context)
                                                          .languageCode ==
                                                      'ar'
                                                  ? 0
                                                  : 30),
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(39),
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          child: Center(
                                              child: TextResponsive(
                                            cartProvider.cartCounter.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationPage()));
                                    },
                                    child: ContainerResponsive(
                                        width: 95,
                                        height: 95,
                                        child: FlatButton(
                                            onPressed: null,
                                            child: Image.asset(
                                              'images/ring.PNG',
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBoxResponsive(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(Icons.arrow_forward,
                                          size: ScreenUtil().setSp(50)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(child: Load(150.0))
                    ],
                  )
                : Stack(
                    children: [
                      CustomScrollView(
                        controller: scrollController,
                        slivers: <Widget>[
                          SliverPadding(
                              padding: EdgeInsets.all(0),
                              sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                /*** Header One ***/
                                SizedBox(
                                  height: 35,
                                ),
                                SizedBoxResponsive(
                                  height: 80,
                                  child: ContainerResponsive(
                                    width: 720,
                                    child: ContainerResponsive(
                                      padding: EdgeInsetsResponsive.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CartScreen()));
                                              },
                                              child: Stack(
                                                children: <Widget>[
                                                  ContainerResponsive(
                                                    width: 60,
                                                    height: 60,
                                                    child: Image.asset(
                                                      'images/crt.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  ContainerResponsive(
                                                    margin: EdgeInsetsResponsive.only(
                                                        left: Localizations.localeOf(
                                                                        context)
                                                                    .languageCode ==
                                                                'ar'
                                                            ? 0
                                                            : 30),
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              39),
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    child: Center(
                                                        child: TextResponsive(
                                                      cartProvider.cartCounter
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NotificationPage()));
                                              },
                                              child: ContainerResponsive(
                                                  width: 95,
                                                  height: 95,
                                                  child: FlatButton(
                                                      onPressed: null,
                                                      child: Image.asset(
                                                        'images/ring.PNG',
                                                        fit: BoxFit.cover,
                                                      ))),
                                            ),
                                          ]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ContainerResponsive(
                                                child: Text(
                                                  provider.name,
                                                  style: TextStyle(
                                                      fontSize: provider
                                                                  .name.length >
                                                              25
                                                          ? 20
                                                          : provider.name
                                                                      .length >
                                                                  20
                                                              ? 25
                                                              : 30,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              SizedBoxResponsive(width: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Icon(Icons.arrow_forward,
                                                    size:
                                                        ScreenUtil().setSp(50)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]))),
                        ],
                      ),
                      loading2
                          ? Positioned(
                              bottom: 10,
                              child: ContainerResponsive(
                                  width: 720,
                                  child: Center(
                                      child: CupertinoActivityIndicator())),
                            )
                          : Container(),
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

  TabController _tabController;

  Widget _tabView() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        CommonAppBar(
          title: '',
          backButton: true,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            width: mediaQuery.width,
            height: mediaQuery.height / 4,
            imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL + provider.image,
            fit: BoxFit.cover,
            placeholder: (context, url) => ImageLoad(130.0),
            errorWidget: (context, url, error) => Image.asset(
              'images/image404.png',
              width: mediaQuery.width,
              height: mediaQuery.height / 4,
            ),
          ),
        ),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: Container(
                  width: mediaQuery.width,
                  height: mediaQuery.height / 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        provider.name,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                provider.rate == null
                                    ? '0'
                                    : provider.rate.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                          Text(
                            'rate'.tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                elevation: 0.0,
                bottom: TabBar(tabs: [
                  Text(
                    "shopMenu".tr(),
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    "shopOffers".tr(),
                    style: TextStyle(color: Colors.black),
                  ),
                ]),
              ),
              body: TabBarView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) => ProviderProductsListCard(
                      product: productsList[index],
                      shop: provider,
                    ),
                    itemCount: productsList.length,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) => ProviderProductsListCard(
                      product: productsList[index],
                      shop: provider,
                    ),
                    itemCount: productsList.length,
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
