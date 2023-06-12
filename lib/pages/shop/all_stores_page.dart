import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/models/story/shop_story.dart';
import 'package:customers/pages/shop/provider_page.dart';
import 'package:customers/pages/story/new_story.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/shop/city_provider.dart';
import 'package:customers/providers/shop/shops_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllStores extends StatefulWidget {
  const AllStores({Key key, this.section, this.stories}) : super(key: key);

  final String section;
  final List<Story> stories;

  @override
  _State createState() => _State();
}

ScrollController controller = ScrollController();

class _State extends State<AllStores> {
  String currentTag = 'all';
  List<Shop> list = [];
  TextEditingController textctrl = TextEditingController();
  List<Shop> viewed = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ShopsProvider>(context, listen: false).startLoad();
      await Provider.of<ShopsProvider>(context, listen: false)
          .getTags(type: widget.section == 'store' ? 'store' : 'restaurant');
      filterShops(
          shops: widget.section == 'store'
              ? Provider.of<ShopsProvider>(context, listen: false).shopsByRegion
              : Provider.of<ShopsProvider>(context, listen: false).resByRegion,
          tag: 'all');
    });
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          Provider.of<ShopsProvider>(context, listen: false).loading == false) {
        print('end');
        widget.section == 'store'
            ? Provider.of<ShopsProvider>(context, listen: false)
                .getMoreShopsByRegion(allshops: false)
            : Provider.of<ShopsProvider>(context, listen: false)
                .getMoreResByRegion(allshops: false);
      }
    });
  }

  void filterViewed(String text) {
    if (text == '') {
      viewed = list;
      setState(() {});
      return;
    }
    var tlist = list;
    log('list4: $list');
    viewed = [];
    for (int i = 0; i < tlist.length; i++) {
      if (tlist[i].name.toLowerCase().contains(text.toLowerCase())) {
        viewed.add(tlist[i]);
      }
    }
    setState(() {});
  }

  void filterShops({String tag, List<Shop> shops}) {
    log('tag: $tag');
    log('tag: $shops');
    viewed = [];
    if (tag != 'all') {
      for (int i = 0; i < shops.length; i++) {
        if (shops[i].tag == tag) {
          viewed.add(shops[i]);
          list.add(shops[i]);
        }
      }
    } else if (tag == 'all') {
      viewed = shops;
      list = shops;
    }
    print(viewed);
    setState(() {});
  }

  ImageProvider image(String url) {
    try {
      log('story_image_url' + APIKeys.ONLINE_IMAGE_BASE_URL + url);
      return CachedNetworkImageProvider(
        APIKeys.ONLINE_IMAGE_BASE_URL + url,
      );
    } catch (e) {
      return AssetImage('marid.png');
    }
  }

  String rate(int rate) {
    String _rate = '';
    if (rate == 5) {
      _rate = 'excellent'.tr();
    } else if (rate == 4) {
      _rate = 'veryGood'.tr();
    } else if (rate == 3) {
      _rate = 'good'.tr();
    } else if (rate == 2) {
      _rate = 'notBad'.tr();
    } else if (rate == 1) {
      _rate = 'bad'.tr();
    } else {
      _rate = 'notRated'.tr();
    }
    return _rate;
  }

  Widget store({List<Shop> list, BuildContext context}) {
    return list.isNotEmpty
        ? ContainerResponsive(
            margin: EdgeInsetsResponsive.symmetric(vertical: 10),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ContainerResponsive(
                    // height: MediaQuery.of(context).size.height *.3,
                    margin: EdgeInsetsResponsive.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProviderScreen(provider: list[index])));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  widget.stories
                                              .where((story) =>
                                                  list[index].id ==
                                                  story.targetedShopId)
                                              .length !=
                                          0
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => StoryScreen(
                                                  user: list[index],
                                                  story: widget.stories
                                                      .where((story) =>
                                                          list[index].id ==
                                                          story.targetedShopId)
                                                      .toList())))
                                      : Fluttertoast.showToast(
                                          msg: 'nostory'.tr(),
                                          textColor: Colors.white,
                                          backgroundColor: Colors.red,
                                          gravity: ToastGravity.BOTTOM);
                                },
                                child: ContainerResponsive(
                                    width: 150,
                                    height: 150,
                                    padding: EdgeInsetsResponsive.all(2),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: image(
                                                list[index].image.toString())),
                                        border: Border.all(
                                            width: 3,
                                            color: widget.stories
                                                        .where((story) =>
                                                            list[index].id ==
                                                            story
                                                                .targetedShopId)
                                                        .length !=
                                                    0
                                                ? Theme.of(context)
                                                    .secondaryHeaderColor
                                                : Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        color: Colors.white),
                                    margin: EdgeInsetsResponsive.symmetric(
                                        horizontal: 15)),
                              ),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 10, vertical: 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextResponsive(
                                        context.locale == Locale('ar')
                                            ? list[index].nameAr.toString()
                                            : list[index].name,
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    ContainerResponsive(
                                      width: 270,
                                      child: AutoSizeText(
                                          context.locale == Locale('ar')
                                              ? list[index]
                                                  .descriptionAr
                                                  .toString()
                                              : list[index].description,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[600]
                                                  .withOpacity(0.8))),
                                    ),
                                    SizedBoxResponsive(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.tag_faces_outlined,
                                          size: ScreenUtil().setSp(25),
                                          color: Colors.grey[500],
                                        ),
                                        SizedBoxResponsive(width: 5),
                                        TextResponsive(
                                            rate(list[index].rate ?? 0),
                                            style: TextStyle(
                                              fontSize: 23,
                                            )),
                                      ],
                                    ),
                                    SizedBoxResponsive(height: 5),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsResponsive.only(
                                              bottom: 5),
                                          child: Icon(
                                            Icons.alarm,
                                            size: ScreenUtil().setSp(25),
                                            color: Colors.grey[600]
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        SizedBoxResponsive(width: 5),
                                        AutoSizeText(list[index].doorStartAt,
                                            style: TextStyle(
                                                color: Colors.grey[600]
                                                    .withOpacity(0.8))),
                                        Container(
                                          margin: EdgeInsets.all(3),
                                          width: 1,
                                          height: 10,
                                          color:
                                              Colors.grey[600].withOpacity(0.8),
                                        ),
                                        AutoSizeText(list[index].doorCloseAt,
                                            style: TextStyle(
                                                color: Colors.grey[600]
                                                    .withOpacity(0.8))),
                                        SizedBoxResponsive(width: 15),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsetsResponsive.only(
                                                      bottom: 5),
                                              child: Icon(
                                                Icons.motorcycle_rounded,
                                                size: ScreenUtil().setSp(25),
                                                color: Colors.grey[600]
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            SizedBoxResponsive(width: 10),
                                            AutoSizeText(
                                              '${(list[index].rate ?? 0).toStringAsFixed(1)}' +
                                                  ' ' +
                                                  'sr'.tr(),
                                              style: TextStyle(
                                                  color: Colors.grey[600]
                                                      .withOpacity(0.8)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }))
        : Column(
            children: [
              SizedBoxResponsive(height: 500),
              Center(
                  child: TextResponsive('noStores'.tr(),
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ))),
            ],
          );
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
                    color: Theme.of(context).secondaryHeaderColor,
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

      var _regionId = region;
      pref.setInt('regionId', _regionId);
      Provider.of<ShopsProvider>(context, listen: false).startLoad();
      await Provider.of<ShopsProvider>(context, listen: false)
          .getShopsByRegion(alone: true);
      filterShops(
          shops:
              Provider.of<ShopsProvider>(context, listen: false).shopsByRegion,
          tag: 'all');
    } else {
      // do nothing
    }
  }

  _palecesCard(Shop shop) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProviderScreen(provider: shop)));
      },
      child: Center(
        child: Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[100],
            ),
            margin: EdgeInsets.all(5),
            child: ListView(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 50,
                  child: CachedNetworkImage(
                    imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL + shop.image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => ImageLoad(150.0),
                    errorWidget: (context, url, error) =>
                        Image.asset('images/image404.png'),
                  ),
                ),
                SizedBoxResponsive(height: 5),
                Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Text(
                      shop.name,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    )),
                SizedBoxResponsive(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 100,
                        child: Text(
                          shop.description == null ? '' : shop.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Icon(
                        Icons.description,
                        size: 15,
                        color: Color(0xffFBB746),
                      )
                    ],
                  ),
                ),
                SizedBoxResponsive(height: 5),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Column(
            children: [
              TextResponsive('deliverTo'.tr(),
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  )),
              Consumer<CityProvider>(builder: (context, value, _) {
                if (value.cities.isNotEmpty) {
                  return PopupMenuButton<int>(
                    initialValue: value.selectedCity,
                    onSelected: (value) async {
                      changeReigon(context, value);
                    },
                    itemBuilder: (context) => value.citiesPopMenuList,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              value.selectedCity == null
                                  ? 'chooseCity'.tr()
                                  : "${context.locale == Locale('ar') ? value.cities[value.selectedCity].nameAr.toString() : value.cities[value.selectedCity].name.toString()}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).secondaryHeaderColor,
                              )),
                          Icon(Icons.keyboard_arrow_down,
                              size: ScreenUtil().setSp(40),
                              color: Theme.of(context).secondaryHeaderColor)
                        ]),
                    offset: Offset(10, 100),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              })
            ],
          ),
        ),
        body: Consumer<ShopsProvider>(
          builder: (context, shopsProvider, _) {
            return ListView(
              controller: controller,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: ContainerResponsive(
                                width: 200,
                                child: LayoutBuilder(
                                  builder: (context, cons) {
                                    var _h = cons.maxHeight;
                                    var _w = cons.maxWidth;
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: shopsProvider.tags.length,
                                        itemBuilder: (context, index) {
                                          var tags = shopsProvider.tags;
                                          return ContainerResponsive(
                                            height: 100,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ContainerResponsive(
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .symmetric(
                                                      vertical: _h * 0,
                                                    ),
                                                    child: TextResponsive(
                                                        context.locale ==
                                                                Locale('en')
                                                            ? tags[index]
                                                                .name
                                                                .toString()
                                                            : tags[index]
                                                                .nameAR
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  Checkbox(
                                                      activeColor: Theme.of(
                                                              context)
                                                          .secondaryHeaderColor,
                                                      value: currentTag ==
                                                              tags[index].name
                                                          ? true
                                                          : false,
                                                      onChanged: (value) {
                                                        if (value == true) {
                                                          setState(() {
                                                            currentTag =
                                                                tags[index]
                                                                    .name;
                                                          });
                                                          filterShops(
                                                              tag: tags[index]
                                                                  .name,
                                                              shops: widget
                                                                          .section ==
                                                                      'store'
                                                                  ? shopsProvider
                                                                      .shopsByRegion
                                                                  : shopsProvider
                                                                      .resByRegion);
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      })
                                                ]),
                                          );
                                        });
                                  },
                                ),
                              ));
                            });
                      },
                      child: ContainerResponsive(
                          padding:
                              EdgeInsetsResponsive.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.menu,
                                  size: 25, color: Colors.grey[400]),
                              SizedBoxResponsive(width: 10),
                              TextResponsive('filter'.tr(),
                                  style: TextStyle(
                                      fontSize: 32, color: Colors.black)),
                            ],
                          )),
                    ),
                    Expanded(
                        child: ContainerResponsive(
                      padding: EdgeInsetsResponsive.symmetric(horizontal: 20),
                      child: TextField(
                        onChanged: (text) {
                          // if (text != '') {
                          filterViewed(text);
                          // } else {
                          //   // filterShops(
                          //   //     shops: shopsProvider.shopsByRegion, tag: 'all');
                          // }
                        },
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            hintText: 'search'.tr(),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.grey[500]),
                            border: InputBorder.none),
                        controller: textctrl,
                      ),
                    ))
                  ],
                ),
                SizedBoxResponsive(height: 15),
                Container(
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 20),
                    child: AutoSizeText(
                      widget.section == 'res'
                          ? 'dexRes'.tr()
                          : 'dexStores'.tr(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                SizedBoxResponsive(height: 30),
                shopsProvider.load < 1
                    ? Column(
                        children: [
                          SizedBoxResponsive(height: 500),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          store(context: context, list: viewed),
                        ],
                      )
              ],
            );
          },
        ));
  }
}
