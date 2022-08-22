import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/models/special_offer.dart';
import 'package:customers/models/story/shop_story.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/pages/shop/all_stores_page.dart';
import 'package:customers/pages/shop/provider_page.dart';
import 'package:customers/pages/story/new_story.dart';
import 'package:customers/providers/account/user_info_provider.dart';
import 'package:customers/providers/shop/shop_details.dart';
import 'package:customers/widgets/general/full_page_loading.dart';
import 'package:customers/widgets/shop/special_order.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:customers/providers/categories/categories_provider.dart';
import 'package:customers/providers/categories/get_products_by_categories.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/shop/all_product_provider.dart';
import 'package:customers/providers/shop/city_provider.dart';
import 'package:customers/providers/shop/shop_story_provider.dart';
import 'package:customers/providers/shop/shops_provider.dart';
import 'package:customers/providers/shop/special_offers_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/categories/category_card.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:customers/widgets/shop/product_card.dart';
import 'package:customers/widgets/shop/shop_card.dart';
import 'package:customers/widgets/story/story_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customers/repositories/globals.dart';
import '../../providers/shop/shops_provider.dart';
import 'package:customers/models/product.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  ScrollController scrollController1 = ScrollController();
  int selected = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  //after new structure
  TextEditingController search = TextEditingController();
  int _regionId;
  bool isLoadingStory = false;

  var loading = false;
  var loading2 = false;
  var nextProducts;
  List<Product> desertCategoryProducts = [];

  Future getProducts() async {
    int desertCategoryId =
        Provider.of<CategoriesProvider>(context, listen: false)
            .categories[2]
            .id;

    try {
      loading = true;
      print('desertCategoryId \n $desertCategoryId \n regionId : \n $regionId');
      final url = APIKeys.BASE_URL +
          'getProducts/shopId=all&catId&$desertCategoryId&OrderBy_vield=id&regionId=$regionId';
      // log('home page url: $url');
      var response = await dioClient.get(url);

      var data = response.data['data'];
      var products = data as List;
      if (products.length != 0) {
        desertCategoryProducts =
            products.map<Product>((json) => Product.fromJson(json)).toList();
        nextProducts = response.data['next_page_url'];
        setState(() {
          loading = false;
        });
      }
    } on DioError catch (error) {
      log('error: $error');
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

  changeReigon(BuildContext context, int region) async {
    var agreement = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.grey[200],
            actions: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: TextResponsive('إلغاء',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ))),
              GestureDetector(
                onTap: () async {
                  Provider.of<CityProvider>(context, listen: false)
                      .updateSelectedCity(newCity: region);
                  Navigator.of(context).pop(true);
                },
                child: ContainerResponsive(
                    color: Colors.green,
                    width: 100,
                    height: 100,
                    child: Center(
                      child: TextResponsive('موافق',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          )),
                    )),
              ),
            ],
            content: ContainerResponsive(
              child: Wrap(
                children: [
                  Center(
                      child: TextResponsive(
                          'عند تغيير حلقة الخضار سيتم حذف منتجات السلة',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )))
                ],
              ),
            )));
    if (agreement == true) {
      Provider.of<CartProvider>(context, listen: false).clearCart();
      var pref = await SharedPreferences.getInstance();
      regionId = region + 3;

      _regionId = region;
      pref.setInt('regionId', _regionId);
      Provider.of<ShopsProvider>(context, listen: false).getShopsByRegion();
    } else {
      // do nothing
    }
  }

  int _current = 0;
  List<String> splitStr;

  strList(Story story) {
    List<dynamic> str =
        story.textList.length >= 2 ? story.textList : story.textList[0];
    List<TextSpan> list = [];
    if (str[0] != null) {
      list.add(TextSpan(
          text: str[0],
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          )));
    }
    if (story.mentionedName != null && story.mentionedName != '') {
      list.add(TextSpan(
          text: " @${story.mentionedName} ",
          recognizer: TapGestureRecognizer()
            ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProviderScreen(
                      from: 'special',
                      specialOffer: SpecialOffer(shopId: story.mentionedId),
                    ))),
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 15,
              decoration: TextDecoration.underline)));
    }
    if (str[1] != null) {
      list.add(TextSpan(
          text: str[1],
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          )));
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Provider.of<AllProductProvider>(context, listen: false)
            .getMoreProducts();
      }
    });
    scrollController1.addListener(() {
      if (scrollController1.position.pixels ==
          scrollController1.position.maxScrollExtent) {
        Provider.of<ShopsProvider>(context, listen: false)
            .getMoreShopsByRegion();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ShopsProvider>(context, listen: false).initRegion();
      _regionId = Provider.of<ShopsProvider>(context, listen: false).region;
      Provider.of<AllProductProvider>(context, listen: false)
          .fetchAllProdcucts();
      Provider.of<ShopsProvider>(context, listen: false)
          .getResByRegion(alone: false);
      Provider.of<CityProvider>(context, listen: false)
          .updateSelectedCity(newCity: _regionId);
      Provider.of<CategoyProductProvider>(context, listen: false)
          .getProducts('newest', regionId);
      Provider.of<CityProvider>(context, listen: false).fetchCities(context);
      Provider.of<SpecialOffersPorvider>(context, listen: false)
          .getSpecialOffers();
      Provider.of<ShopStoryProvider>(context, listen: false).getShopStories();
      Provider.of<UserInfoProvider>(context, listen: false).getUserInfo();
      await Provider.of<CategoriesProvider>(context, listen: false)
          .fetchCategory();
      getProducts();
    });
  }

  TextEditingController cont = TextEditingController();
  var mediaQuery;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    return Stack(children: [
      Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          var carItems = Provider.of<CartProvider>(context).cartItems;
          if (cartProvider.cartItems != null) {
            return Consumer<CategoyProductProvider>(
              builder: (context, allProductProvider, child) {
                if (allProductProvider.productsList != null) {
                  return ResponsiveWidgets.builder(
                    height: 1560,
                    width: 720,
                    allowFontScaling: true,
                    child: SafeArea(
                      child: Scaffold(
                          backgroundColor: Colors.white,
                          resizeToAvoidBottomInset: false,
                          body: Stack(children: <Widget>[
                            CustomScrollView(
                              controller: scrollController,
                              slivers: <Widget>[
                                SliverPadding(
                                    padding: EdgeInsets.all(0),
                                    sliver: SliverList(
                                        delegate: SliverChildListDelegate([
                                      /* STORIES */
                                      Stack(
                                        children: [
                                          ContainerResponsive(
                                            height: 460,
                                            margin:
                                                EdgeInsetsResponsive.symmetric(
                                                    horizontal: 0),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[400],
                                                      blurRadius: 5,
                                                      offset:
                                                          Offset.fromDirection(
                                                              1.5, 5))
                                                ],
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                ),
                                                color: Colors.black),
                                          ),
                                          Column(children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 7,
                                                      right: 7,
                                                      child:
                                                          ContainerResponsive(
                                                        width: 35,
                                                        height: 20,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffED8437),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Center(
                                                            child: TextResponsive(
                                                                cartProvider
                                                                    .cartCounter
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white))),
                                                      ),
                                                    ),
                                                    ContainerResponsive(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0x30ED8437),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                      ),
                                                      margin:
                                                          EdgeInsetsResponsive
                                                              .all(20),
                                                      child: Center(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            CartScreen()));
                                                          },
                                                          icon: Icon(
                                                              CommunityMaterialIcons
                                                                  .cart_outline,
                                                              size: ScreenUtil()
                                                                  .setSp(30),
                                                              color: Color(
                                                                  0xffED8437)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    TextResponsive(
                                                        'deliverTo'.tr(),
                                                        style: TextStyle(
                                                          fontSize: 35,
                                                          color: Colors.white,
                                                        )),
                                                    Consumer<CityProvider>(
                                                        builder: (context,
                                                            value, _) {
                                                      if (value
                                                          .cities.isNotEmpty) {
                                                        return PopupMenuButton<
                                                            int>(
                                                          initialValue: value
                                                              .selectedCity,
                                                          onSelected:
                                                              (value) async {
                                                            changeReigon(
                                                                context, value);
                                                          },
                                                          itemBuilder:
                                                              (context) => value
                                                                  .citiesPopMenuList,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    value.selectedCity ==
                                                                            null
                                                                        ? 'chooseCity'
                                                                            .tr()
                                                                        : "${context.locale == Locale('ar') ? value.cities[value.selectedCity].nameAr.toString() : value.cities[value.selectedCity].name.toString()}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .secondaryHeaderColor,
                                                                    )),
                                                                Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down,
                                                                    size: ScreenUtil()
                                                                        .setSp(
                                                                            40),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .secondaryHeaderColor)
                                                              ]),
                                                          offset:
                                                              Offset(10, 100),
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    })
                                                  ],
                                                ),
                                                Container(width: 50),
                                              ],
                                            ),
                                            SizedBoxResponsive(height: 20),
                                            ContainerResponsive(
                                              height: 190,
                                              margin: EdgeInsetsResponsive
                                                  .symmetric(horizontal: 0),
                                              child:
                                                  Consumer<ShopStoryProvider>(
                                                builder:
                                                    (context, provider, child) {
                                                  if (provider.shopStories !=
                                                      null) {
                                                    List<int> storesId = [];
                                                    List<Story> singleStory =
                                                        [];
                                                    for (var i = 0;
                                                        i <
                                                            provider.shopStories
                                                                .length;
                                                        i++) {
                                                      if (!storesId.contains(
                                                          provider
                                                              .shopStories[i]
                                                              .targetedShopId)) {
                                                        storesId.add(provider
                                                            .shopStories[i]
                                                            .targetedShopId);
                                                        singleStory.add(provider
                                                            .shopStories[i]);
                                                      }
                                                    }

                                                    return ListView.builder(
                                                        itemCount:
                                                            storesId.length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index) {
                                                          log('story_url' +
                                                              APIKeys
                                                                  .ONLINE_IMAGE_BASE_URL +
                                                              singleStory[index]
                                                                  .purplisherImage
                                                                  .toString());
                                                          return ContainerResponsive(
                                                            margin:
                                                                EdgeInsetsResponsive
                                                                    .fromLTRB(
                                                                        15,
                                                                        5,
                                                                        15,
                                                                        20),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                setState(() {
                                                                  isLoadingStory =
                                                                      true;
                                                                });
                                                                Shop shop = await getShopDetails(
                                                                    shopId: storesId[index] !=
                                                                            null
                                                                        ? storesId[index]
                                                                            .toString()
                                                                        : '0');
                                                                setState(() {
                                                                  isLoadingStory =
                                                                      false;
                                                                });
                                                                var stories = provider
                                                                    .shopStories
                                                                    .where((s) =>
                                                                        storesId[
                                                                            index] ==
                                                                        s.targetedShopId)
                                                                    .toList();
                                                                log('stories length: ' +
                                                                    stories
                                                                        .toString() +
                                                                    ' and index: $index');
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => StoryScreen(
                                                                              story: stories,
                                                                              user: shop,
                                                                            )));
                                                              },
                                                              /*
                                                                setState(() {
                                                                  isLoadingStory =
                                                                      true;
                                                                });
                                                                final shop = await getShopDetails(
                                                                    shopId: storesId[index] !=
                                                                            null
                                                                        ? storesId[index]
                                                                            .toString()
                                                                        : '0');
                                                                setState(() {
                                                                  isLoadingStory =
                                                                      false;
                                                                });
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) {
                                                                  List<StoryItem>
                                                                      stories(
                                                                          List<Story>
                                                                              list) {
                                                                    List<StoryItem>
                                                                        s = [];
                                                                    list.forEach(
                                                                        (i) {
                                                                      if (i.storyVid ==
                                                                          null) {
                                                                        s.add(
                                                                          StoryItem
                                                                              .inlineImage(
                                                                            imageFit:
                                                                                BoxFit.contain,
                                                                            caption: index == 0
                                                                                ? Text('')
                                                                                : Text("${i.textList[0]} ${i.textList[1]}", style: TextStyle(fontSize: 20, color: Colors.white)),
                                                                            duration:
                                                                                Duration(seconds: 10),
                                                                            url:
                                                                                APIKeys.ONLINE_IMAGE_BASE_URL + i.storyImage.toString(),
                                                                            controller:
                                                                                storyController,
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        s.add(vidStory(
                                                                            i,
                                                                            index));
                                                                      }
                                                                    });
                                                                    print(s);
                                                                    return s;
                                                                  }

                                                                  List<Story>
                                                                      lst = [];
                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          provider
                                                                              .shopStories
                                                                              .length;
                                                                      i++) {
                                                                    lst = provider
                                                                        .shopStories
                                                                        .where((s) =>
                                                                            storesId[index] ==
                                                                            s.targetedShopId)
                                                                        .toList();
                                                                  }
                                                                  return Scaffold(
                                                                      body:
                                                                          Stack(
                                                                    children: [
                                                                      StoryView(
                                                                          controller:
                                                                              storyController,
                                                                          storyItems: stories(
                                                                              lst),
                                                                          onComplete:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          onVerticalSwipeComplete:
                                                                              (direction) {
                                                                            if (direction ==
                                                                                Direction.down) {
                                                                              Navigator.pop(context);
                                                                            }
                                                                          }),
                                                                      index == 0
                                                                          ? Positioned(
                                                                              bottom: 20,
                                                                              left: 20,
                                                                              child: Row(
                                                                                children: [
                                                                                  Opacity(opacity: 1, child: RichText(maxLines: 1, text: TextSpan(children: strList(lst[index])))),
                                                                                ],
                                                                              ))
                                                                          : Container(),
                                                                    ],
                                                                  ));
                                                                }));
                                                                var response = await Dio()
                                                                    .get(APIKeys
                                                                            .BASE_URL +
                                                                        'getStory&storyId=${singleStory[index].id}');
                                                                print(response);
                                                              },*/
                                                              child: index == 0
                                                                  ? Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          ContainerResponsive(
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.black,
                                                                                borderRadius: BorderRadius.circular(360),
                                                                                border: Border.all(width: 2, color: Theme.of(context).secondaryHeaderColor)),
                                                                            child:
                                                                                ContainerResponsive(
                                                                              margin: EdgeInsetsResponsive.all(5),
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(
                                                                                  width: 1,
                                                                                  color: Theme.of(context).secondaryHeaderColor,
                                                                                ),
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(360),
                                                                                image: DecorationImage(
                                                                                    image: singleStory[index].purplisherImage.toString() != null && singleStory[index].purplisherImage.toString() != ''
                                                                                        ? CachedNetworkImageProvider(
                                                                                            APIKeys.ONLINE_IMAGE_BASE_URL + singleStory[index].purplisherImage.toString(),
                                                                                          )
                                                                                        : AssetImage('assets/images/Dex.png')),
                                                                              ),
                                                                              height: 105,
                                                                              width: 100,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(context.locale == Locale('ar') ? singleStory[index].purplisherNameAr.toString() : singleStory[index].purplisherName.toString(), style: TextStyle(color: Colors.white)),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          ContainerResponsive(
                                                                            height:
                                                                                120,
                                                                            width:
                                                                                120,
                                                                            child:
                                                                                StoryHeader(
                                                                              imageLink: singleStory[index].storyImage != null ? APIKeys.ONLINE_IMAGE_BASE_URL + singleStory[index].storyImage.toString() : APIKeys.ONLINE_IMAGE_BASE_URL + singleStory[index].purplisherImage.toString(),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Expanded(
                                                                              child: Text(context.locale == Locale('ar') ? singleStory[index].purplisherNameAr.toString() : singleStory[index].purplisherName.toString(), style: TextStyle(color: Colors.white)))
                                                                        ],
                                                                      ),
                                                                    ),
                                                            ),
                                                          );
                                                        });
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBoxResponsive(height: 25),
                                            ContainerResponsive(
                                              height: 100.0,
                                              child: Center(
                                                child: Consumer<
                                                        CategoriesProvider>(
                                                    builder: (context,
                                                        catgoriesProvider, _) {
                                                  if (catgoriesProvider
                                                          .sections !=
                                                      null) {
                                                    return Center(
                                                        child: ListView.builder(
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          catgoriesProvider
                                                              .sections.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              selected = index;
                                                            });
                                                            if (index == 1) {
                                                              await Provider.of<
                                                                          ShopsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getShopsByRegion(
                                                                      alone:
                                                                          false);
                                                            } else if (index ==
                                                                0) {
                                                              await Provider.of<
                                                                          ShopsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getResByRegion(
                                                                      alone:
                                                                          false);
                                                            }
                                                          },
                                                          child: CategoryCard(
                                                              selecetd:
                                                                  selected ==
                                                                          index
                                                                      ? true
                                                                      : false,
                                                              category:
                                                                  catgoriesProvider
                                                                          .sections[
                                                                      index]),
                                                        );
                                                      },
                                                    ));
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            backgroundColor: Theme
                                                                    .of(context)
                                                                .primaryColor),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ]),
                                        ],
                                      )
                                    ]))),
                                /*** Header Slider ***/
                                SliverPadding(
                                  padding: EdgeInsets.only(),
                                  sliver: SliverList(
                                    delegate: SliverChildListDelegate([
                                      if (carItems.length > 0)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: ContainerResponsive(
                                            color: Colors.grey[200],
                                            child: Consumer<CartProvider>(
                                                builder:
                                                    (context, cartProvider, _) {
                                              return Container(
                                                  width: 250,
                                                  child: ExpansionTile(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    initiallyExpanded: false,
                                                    trailing: Icon(Icons
                                                        .keyboard_arrow_down),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('orderSummary'
                                                                .tr() +
                                                            ' : '),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Spacer(
                                                              flex: 7,
                                                            ),
                                                            Text('quantity'
                                                                    .tr() +
                                                                ' : ' +
                                                                '${cartProvider.cartCounter.toString()}'),
                                                            Spacer(
                                                              flex: 3,
                                                            ),
                                                            Text('total'.tr() +
                                                                ' : ' +
                                                                '${cartProvider.totalCost.toStringAsFixed(2)} ' +
                                                                'sr'.tr()),
                                                            Spacer(
                                                              flex: 3,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: cartProvider
                                                            .cartItems.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            title: Text(cartProvider
                                                                    .cartItems[
                                                                        index]
                                                                    .product
                                                                    .name +
                                                                ' x ' +
                                                                cartProvider
                                                                    .cartItems[
                                                                        index]
                                                                    .quantity
                                                                    .toString()),
                                                            trailing: Text(cartProvider
                                                                    .cartItems[
                                                                        index]
                                                                    .total
                                                                    .toString() +
                                                                ' ' +
                                                                'sr'.tr()),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ));
                                            }),
                                          ),
                                        ),
                                      SizedBoxResponsive(height: 30),
                                      selected == 2
                                          ? Container()
                                          : ContainerResponsive(
                                              padding: EdgeInsetsResponsive
                                                  .symmetric(horizontal: 20),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Scaffold(
                                                                        body: BetterPlayer.network(
                                                                            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"),
                                                                      )));
                                                    },
                                                    child: TextResponsive(
                                                      'whatOrder'.tr(),
                                                      style: TextStyle(
                                                        fontSize: 35,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      SizedBoxResponsive(height: 10),
                                    ]),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.all(0.0),
                                  sliver: SliverList(
                                    delegate: SliverChildListDelegate(
                                      [
                                        selected == 2
                                            ? Container()
                                            : ContainerResponsive(
                                                heightResponsive: true,
                                                widthResponsive: true,
                                                child: Consumer<
                                                    SpecialOffersPorvider>(
                                                  builder:
                                                      (context, value, child) {
                                                    if (value.offers != null) {
                                                      if (value.offers.length <
                                                          1)
                                                        return SizedBox
                                                            .shrink();
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          CarouselSlider(
                                                            options:
                                                                CarouselOptions(
                                                                    height: 170,
                                                                    initialPage:
                                                                        0,
                                                                    enlargeCenterPage:
                                                                        true,
                                                                    autoPlayInterval:
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                    autoPlayAnimationDuration:
                                                                        Duration(
                                                                            seconds:
                                                                                2),
                                                                    autoPlay:
                                                                        true,
                                                                    reverse:
                                                                        false,
                                                                    enableInfiniteScroll:
                                                                        true,
                                                                    pauseAutoPlayInFiniteScroll:
                                                                        true,
                                                                    pauseAutoPlayOnTouch:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    onPageChanged:
                                                                        (index,
                                                                            _) {
                                                                      setState(
                                                                          () {
                                                                        _current =
                                                                            index;
                                                                      });
                                                                    }),
                                                            items: value
                                                                    .offerImages
                                                                    .isNotEmpty
                                                                ? value
                                                                    .offerImages
                                                                    .map(
                                                                        (imgUrl) {
                                                                    log('imageURL_________' +
                                                                        APIKeys
                                                                            .ONLINE_IMAGE_BASE_URL +
                                                                        imgUrl);
                                                                    return Builder(
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            var index =
                                                                                value.offerImages.indexOf(imgUrl);
                                                                            print(index);
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => ProviderScreen(
                                                                                          from: 'special',
                                                                                          specialOffer: value.offers[index],
                                                                                        )));
                                                                          },
                                                                          child:
                                                                              ContainerResponsive(
                                                                            width:
                                                                                700,
                                                                            widthResponsive:
                                                                                true,
                                                                            heightResponsive:
                                                                                true,
                                                                            margin:
                                                                                EdgeInsetsResponsive.symmetric(horizontal: 10.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child: imgUrl != null && imgUrl != ''
                                                                                ? CachedNetworkImage(
                                                                                    imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL + imgUrl,
                                                                                    fit: BoxFit.fill,
                                                                                    placeholder: (context, url) => ImageLoad(200.0),
                                                                                    errorWidget: (context, url, error) => Image.asset(
                                                                                      'images/image404.png',
                                                                                      width: 100,
                                                                                      height: 100,
                                                                                    ),
                                                                                  )
                                                                                : Image.asset('images/image404.png'),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  }).toList()
                                                                : [Container()],
                                                          ),
                                                          SizedBoxResponsive(
                                                              height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: map<
                                                                    Widget>(
                                                                value
                                                                    .offerImages,
                                                                (index, url) {
                                                              return ContainerResponsive(
                                                                heightResponsive:
                                                                    true,
                                                                widthResponsive:
                                                                    true,
                                                                width:
                                                                    _current ==
                                                                            index
                                                                        ? 13.0
                                                                        : 10,
                                                                height:
                                                                    _current ==
                                                                            index
                                                                        ? 13.0
                                                                        : 10,
                                                                margin: EdgeInsetsResponsive
                                                                    .symmetric(
                                                                        vertical:
                                                                            10.0,
                                                                        horizontal:
                                                                            10.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: _current == index
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .primaryColor),
                                                    );
                                                  },
                                                )),
                                      ],
                                    ),
                                  ),
                                ),
                                selected == 2
                                    ? SliverToBoxAdapter(
                                        child: SpicalOrder(),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                selected == 0 || selected == 1
                                    ? SliverPadding(
                                        padding: EdgeInsetsResponsive.all(0.0),
                                        sliver: SliverList(
                                          delegate: SliverChildListDelegate(
                                            [
                                              SizedBoxResponsive(height: 40),
                                              ContainerResponsive(
                                                padding: EdgeInsetsResponsive
                                                    .symmetric(horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    TextResponsive(
                                                      selected == 0
                                                          ? 'dexRes'.tr()
                                                          : 'dexStores'.tr(),
                                                      style: TextStyle(
                                                        fontSize: 35,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBoxResponsive(height: 5),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                selected == 0 || selected == 1
                                    ? SliverToBoxAdapter(child:
                                        Consumer<ShopsProvider>(
                                            builder: (context, value, child) {
                                        if (value.loading == true) {
                                          return ContainerResponsive(
                                            height: 350,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor),
                                            ),
                                          );
                                        } else if (value.shopsByRegion !=
                                            null) {
                                          return Stack(children: <Widget>[
                                            value.resByRegion.isNotEmpty
                                                ? ContainerResponsive(
                                                    height: 370.0,
                                                    child: Center(
                                                        child: ListView.builder(
                                                      controller:
                                                          scrollController1,
                                                      primary: false,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: value
                                                          .resByRegion.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ShopCard(
                                                            shop: value
                                                                    .resByRegion[
                                                                index]);
                                                      },
                                                    )))
                                                : ContainerResponsive(
                                                    height: 370.0,
                                                    child: Center(
                                                        child: TextResponsive(
                                                            'noNearbyShops'
                                                                .tr(),
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey[900],
                                                            )))),
                                          ]);
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor),
                                        );
                                      }))
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),

                                /*** ***/
                                selected == 0 || selected == 1
                                    ? allProductProvider.productsList.isEmpty
                                        ? SliverPadding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            sliver: SliverList(
                                              delegate: SliverChildListDelegate(
                                                [
                                                  Center(
                                                      child: TextResponsive(
                                                          'noProducts'.tr(),
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                          )))
                                                ],
                                              ),
                                            ),
                                          )
                                        : SliverPadding(
                                            padding: EdgeInsets.only(),
                                            sliver: SliverList(
                                              delegate:
                                                  SliverChildListDelegate([
                                                SizedBoxResponsive(height: 70),
                                                Padding(
                                                  padding: EdgeInsetsResponsive
                                                      .symmetric(
                                                          horizontal: 20),
                                                  child: Consumer<
                                                          CategoriesProvider>(
                                                      builder: (context,
                                                          catgoriesProvider,
                                                          _) {
                                                    if (catgoriesProvider
                                                            .categories !=
                                                        null) {
                                                      return Localizations
                                                                      .localeOf(
                                                                          context)
                                                                  .languageCode ==
                                                              'ar'
                                                          ? TextResponsive(
                                                              catgoriesProvider
                                                                  .categories[2]
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontSize: 35,
                                                                  color: Colors
                                                                      .black))
                                                          : TextResponsive(
                                                              catgoriesProvider
                                                                  .categories[2]
                                                                  .slug,
                                                              style: TextStyle(
                                                                  fontSize: 35,
                                                                  color: Colors
                                                                      .black));
                                                    }
                                                    return Text('');
                                                  }),
                                                ),
                                                desertCategoryProducts
                                                        .isNotEmpty
                                                    ? ContainerResponsive(
                                                        height: 350,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return ProductCard(
                                                              product:
                                                                  desertCategoryProducts[
                                                                      index],
                                                            );
                                                          },
                                                          itemCount:
                                                              desertCategoryProducts
                                                                  .length,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 80,
                                                        child: Center(
                                                            child: TextResponsive(
                                                                'noProducts'
                                                                    .tr(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 25,
                                                                  color: Colors
                                                                      .black,
                                                                ))),
                                                      )
                                              ]),
                                            ))
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                selected == 0 || selected == 1
                                    ? SliverPadding(
                                        padding: EdgeInsetsResponsive.all(0.0),
                                        sliver: SliverList(
                                          delegate: SliverChildListDelegate(
                                            [
                                              SizedBoxResponsive(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                /*** ***/
                                selected == 0 || selected == 1
                                    ? allProductProvider.productsList.isEmpty
                                        ? SliverPadding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20.0),
                                            sliver: SliverList(
                                              delegate: SliverChildListDelegate(
                                                [
                                                  Center(
                                                      child: TextResponsive(
                                                          'noProducts'.tr(),
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.black,
                                                          )))
                                                ],
                                              ),
                                            ),
                                          )
                                        : SliverPadding(
                                            padding: EdgeInsets.only(),
                                            sliver: SliverList(
                                              delegate:
                                                  SliverChildListDelegate([
                                                Padding(
                                                  padding: EdgeInsetsResponsive
                                                      .symmetric(
                                                          horizontal: 20),
                                                  child: TextResponsive(
                                                      'freeDelivery'.tr(),
                                                      style: TextStyle(
                                                          fontSize: 35,
                                                          color: Colors.black)),
                                                ),
                                                ContainerResponsive(
                                                  height: 350,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            ProductCard(
                                                      product:
                                                          allProductProvider
                                                                  .productsList[
                                                              index],
                                                    ),
                                                    itemCount:
                                                        allProductProvider
                                                            .productsList
                                                            .length,
                                                  ),
                                                )
                                              ]),
                                            ))
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                selected == 0 || selected == 1
                                    ? SliverPadding(
                                        padding: EdgeInsetsResponsive.all(0.0),
                                        sliver: SliverList(
                                          delegate: SliverChildListDelegate(
                                            [
                                              SizedBoxResponsive(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                selected == 0 || selected == 1
                                    ? SliverPadding(
                                        padding: EdgeInsetsResponsive.all(0.0),
                                        sliver: SliverList(
                                          delegate: SliverChildListDelegate(
                                            [
                                              Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => AllStores(
                                                            stories: Provider.of<
                                                                        ShopStoryProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .allShopStories,
                                                            section: selected ==
                                                                    0
                                                                ? 'res'
                                                                : 'store')));
                                                  },
                                                  child: ContainerResponsive(
                                                      height: 70,
                                                      width: 650,
                                                      margin:
                                                          EdgeInsetsResponsive
                                                              .symmetric(
                                                                  horizontal:
                                                                      30),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Center(
                                                        child: TextResponsive(
                                                          selected == 0
                                                              ? 'ShowAllRestaurants'
                                                                  .tr()
                                                              : 'showAllStores'
                                                                  .tr(),
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              SizedBoxResponsive(height: 30),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                              ],
                            ),
                          ])),
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
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor),
          );
        },
      ),
      isLoadingStory ? FullLoadingPage() : Container()
    ]);
  }
}
//
