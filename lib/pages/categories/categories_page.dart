import 'dart:core' as prefix0;
import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/providers/services/fav_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import '../../models/product.dart';
import '../../providers/categories/get_products_by_categories.dart';
import '../../repositories/api_keys.dart';
import '../../widgets/categories/product_card_grid.dart';
import '../../widgets/general/appbar_widget.dart';
import '../../widgets/general/loading.dart';
import '../../widgets/general/prodcut_load.dart';

class CategoryHome extends StatefulWidget {
  final Product product;

  CategoryHome({this.product});

  @override
  _CategoryHomeState createState() => _CategoryHomeState(product);
}

class _CategoryHomeState extends State<CategoryHome> {
  Product product;

  _CategoryHomeState(this.product);

  var boxOn = true;
  var isFav = false;
  var listOn = false;
  var nearOn = false;
  var selectedMenu = 1;
  var loading2 = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
//    Provider.of<Favorite>(context, listen: false).getFav();

//    Fluttertoast.showToast(msg: 'null');
    selectedMenu = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoyProductProvider>(context, listen: false)
          .getProductsByCategories(
              productName: product.name,
              orderBy: selectedMenu,
              context: context);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Provider.of<CategoyProductProvider>(context, listen: false)
                  .isLoadingNextPage !=
              true) {
        Provider.of<CategoyProductProvider>(context, listen: false)
            .getMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var popMenu = Theme(
      data: Theme.of(context).copyWith(
          cardColor: Colors.transparent, backgroundColor: Colors.black),
      child: PopupMenuButton<int>(
        color: Colors.white,
        onSelected: (value) {
          setState(() {
            selectedMenu = value;
            Provider.of<CategoyProductProvider>(context, listen: false)
                .getProductsByCategories(
                    context: context,
                    productName: product.name,
                    orderBy: value);
          });
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            height: 50,
            value: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'recent',
                style: TextStyle(
                    fontSize: 12,
                    color: selectedMenu == 1
                        ? Theme.of(context).accentColor
                        : Theme.of(context).accentColor),
              ).tr()),
            ),
          ),
          PopupMenuItem(
            height: 50,
            value: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'topRated',
                style: TextStyle(
                    fontSize: 12,
                    color: selectedMenu == 2
                        ? Theme.of(context).accentColor
                        : Theme.of(context).accentColor),
              ).tr()),
            ),
          ),
          PopupMenuItem(
            height: 50,
            value: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'leastPrice',
                style: TextStyle(
                    fontSize: 12,
                    color: selectedMenu == 3
                        ? Theme.of(context).accentColor
                        : Theme.of(context).accentColor),
              ).tr()),
            ),
          ),
        ],
        child: Container(
            width: 110,
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).accentColor, width: 0.5),
                borderRadius: BorderRadius.circular(5),
                color: Color(0xffF9F9F9)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.arrow_drop_down,
                      color: Color(
                        0xff575757,
                      )),
                  Center(
                    child: Text(
                      selectedMenu == 1
                          ? 'recent'.tr()
                          : selectedMenu == 2
                              ? 'topRated'.tr()
                              : selectedMenu == 3
                                  ? 'leastPrice'.tr()
                                  : '',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 13),
                    ),
                  )
                ])),
      ),
    );

    return Consumer<Favorite>(builder: (context, fav, _) {
      return ConnectivityWidgetWrapper(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  /*** Header One ***/
                  SliverPadding(
                    padding: EdgeInsets.all(0.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 40,
                          ),
                          CommonAppBar(
                            backButton: true,
                            title: context.locale == Locale('en')
                                ? product.name.toString()
                                : product.nameAr.toString(),
                          )
                        ],
                      ),
                    ),
                  ),

                  ///*** Header Two ***/
                  SliverPadding(
                    padding: EdgeInsets.all(0.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 20,
                            child: fav.loading == true
                                ? CupertinoActivityIndicator()
                                : Container(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          100 *
                                          85,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Color(0xffF9F9F9),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'searchProduct'.tr(),
                                          contentPadding: EdgeInsets.only(
                                              right: 10, top: 8),
                                          hintStyle: TextStyle(fontSize: 15),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 20,
                                          ),
                                        ),
                                        textAlign: TextAlign.right,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///*** Header Three ***/
                  SliverPadding(
                    padding: EdgeInsets.all(0.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'filter',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 14),
                                  ).tr(),
                                ),
                                Container(
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          nearOn
                                              ? nearOn = false
                                              : nearOn = true;
                                        });
                                        print(nearOn);
                                      },
                                      child: popMenu),
                                ),
                                // IconButton(
                                //     onPressed: () {
                                //       setState(() {
                                //         if (!isFav) {
                                //           isFav = true;
                                //           boxOn = false;
                                //           listOn = false;
                                //         }
                                //       });
                                //     },
                                //     icon: isFav
                                //         ? Icon(Icons.favorite,
                                //         color: Theme.of(context)
                                //             .primaryColor)
                                //         : Icon(Icons.favorite_border,
                                //         color: Theme.of(context)
                                //             .accentColor)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (!boxOn) {
                                          boxOn = true;
                                          listOn = false;
                                          isFav = false;
                                        }
                                      });
                                    },
                                    icon: boxOn
                                        ? Icon(
                                            CommunityMaterialIcons
                                                .view_grid_outline,
                                            color:
                                                Theme.of(context).primaryColor)
                                        : Icon(
                                            CommunityMaterialIcons
                                                .view_grid_outline,
                                            color:
                                                Theme.of(context).accentColor)),
                                IconButton(
                                    icon: listOn
                                        ? Icon(CommunityMaterialIcons.view_list,
                                            color:
                                                Theme.of(context).primaryColor)
                                        : Icon(CommunityMaterialIcons.view_list,
                                            color:
                                                Theme.of(context).accentColor),
                                    onPressed: () {
                                      setState(() {
                                        if (!listOn) {
                                          listOn = true;
                                          boxOn = false;
                                          isFav = false;
                                        }
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Consumer<CategoyProductProvider>(
                    builder: (context, provider, child) {
                      if (provider.loading == false) {
                        if (provider.products.isEmpty) {
                          return SliverPadding(
                            padding: EdgeInsets.all(0.0),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Column(
                                    children: [
                                      SizedBoxResponsive(height: 200),
                                      Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              width: 200,
                                              height: 150,
                                              imageUrl: APIKeys
                                                      .ONLINE_IMAGE_BASE_URL +
                                                  product.image.toString(),
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  ImageLoad(80.0),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'images/image404.png'),
                                            ),
                                            Image.asset(
                                              'images/shadow.png',
                                              width: 150,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBoxResponsive(height: 20),
                                            TextResponsive('لا توجد منتجات',
                                                style: TextStyle(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (boxOn) {
                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) =>
                                    ProductCardGrid(
                                      product: provider.products[index],
                                      boxOn: boxOn,
                                    ),
                                childCount: provider.products.length),
                          );
                        } else {
                          if (isFav) {
                            return Consumer<Favorite>(
                              builder: (context, value, child) {
                                return SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) =>
                                          ProductCardGrid(
                                            product: value.favorite[index],
                                          ),
                                      childCount: value.favorite.length),
                                );
                              },
                            );
                          } else
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) =>
                                      ProductCardGrid(
                                        product: provider.products[index],
                                        boxOn: boxOn,
                                      ),
                                  childCount: provider.products.length),
                            );
                        }
                      }
                      return SliverPadding(
                        padding: EdgeInsets.all(0.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [Center(child: Load(150.0))],
                          ),
                        ),
                      );
                    },
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(0.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<CategoyProductProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoadingNextPage) {
                    return Positioned(
                      bottom: 10,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(child: CupertinoActivityIndicator())),
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
