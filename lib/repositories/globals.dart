import 'dart:async';
import 'dart:io';
import 'package:customers/models/categories/categories.dart';
import 'package:customers/models/cities.dart';
import 'package:customers/models/general/app_info.dart';
import 'package:customers/models/shop/near_shop.dart';
import 'package:customers/models/shops.dart';
import 'package:customers/models/special_offer.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import '../models/product.dart';

dynamic detailsFrom;

// String baseURL = 'http://www.dexoman.com/api/';
// String baseNotificationURL = 'http://www.dexoman.com/api/fire/';
Dio dioClient = Dio();
String link;
int showcase = 1;

const vat = 0.05;

class Keys {
  static final showcaseOne = const Key('1');
  static final showcaseTwo = const Key('2');
  static final showcaseThree = const Key('3');
  static final showcaseFour = const Key('4');
  static final showcaseFive = const Key('5');
  static final showcaseSix = const Key('6');
  static final showcaseSeven = const Key('7');
}

AppInfo appInfo;
var permissionStatus;
// load at splash variables
bool fromMain;
List<Shop> shopList;
List<Category> categoryList;
List<Product> newestProduct;
Shop specialShop;
List<SpecialOffer> specialOffer;
List<PopupMenuEntry<int>> popMenuList;
List<City> cities;
List imgList;
// =======================
List<Product> newProduct;
dynamic nextPage;
dynamic nextShops;
double nearShopLat;
double nearShopLong;
String lastTitle;
int bottomSelectedIndex = 0;
dynamic pagnation;
int regionId;
int selectedCity;

var userId;
var userToken;
var userPhone;
var userImage;
var userName;
var userEmail;
var isLogin;
var visitor = false;

class MessageNotification extends StatelessWidget {
  final VoidCallback onReplay;
  String message;
  String title;
  dynamic notiColor = Colors.green[50];
  MessageNotification({Key key, this.onReplay, this.message, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notiColor,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(child: Image.asset('images/logo.png'))),
          title: Text(title),
          subtitle: Text(message),
          trailing: IconButton(
              icon: Icon(Icons.reply),
              onPressed: () {
                if (onReplay != null) onReplay();
              }),
        ),
      ),
    );
  }
}

// int mapType=0;
class Comment {
  final dynamic id;
  final dynamic product_Id;
  final dynamic Customer_id;
  final dynamic comment;
  final dynamic created_at;

  Comment(
      {this.id,
      this.product_Id,
      this.Customer_id,
      this.comment,
      this.created_at});
  factory Comment.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Comment(
      id: parsedJson['id'],
      product_Id: parsedJson['product_Id'],
      Customer_id: parsedJson['Customer_id'],
      comment: parsedJson['comment'],
      created_at: parsedJson['created_at'],
    );
  }
}

List nearListName = [''];
List nearListIcon = [''];
dynamic selectedShopId = '0';
dynamic orderBy_products = 'name';

class Item {
  final dynamic itemname;
  final dynamic imagename;
  final dynamic description;
  final dynamic stock;
  final dynamic rate;
  final dynamic categories;
  var itmprice;
  final dynamic id;
  final dynamic unit;
  List<Comment> comments;
  // final Cityinfo userCity;
  Item(
      {this.itemname,
      this.imagename,
      this.comments,
      this.itmprice,
      this.id,
      this.description,
      this.stock,
      this.rate,
      this.categories,
      this.unit});
  factory Item.fromJson(Map<dynamic, dynamic> json) {
    var list = json['ProdcutsComments'] as List;
    List<Comment> commentsList;
    if (list != null) {
      print(list.runtimeType);
      commentsList = list.map((i) => Comment.fromJson(i)).toList();
    }
    return Item(
      itemname: json['name'],
      itmprice: json['price'],
      unit: json['unit'],
      imagename: json['image'],
      description: json['description'],
      stock: json['stock'],
      rate: json['rate'],
      categories: json['categories'],
      comments: commentsList,
      id: json['id'],
    );
  }
}

class Cityinfo {
  final dynamic id;
  final dynamic name;

  Cityinfo({this.id, this.name});
  factory Cityinfo.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Cityinfo(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}

class NearByShop {
  final dynamic ProductCount;
  final dynamic name;
  final dynamic image;
  final dynamic description;
  final dynamic Phone;
  final dynamic email;
  final dynamic website;
  final dynamic address;
  final dynamic is_On;
  final dynamic id;
  final dynamic rate;
  final dynamic raters_count;
  final dynamic sold_count;
  final dynamic longitude;
  final dynamic user_distances;
  final dynamic Latitude;
  final Cityinfo ShopCity;
  final dynamic Dealer;

  NearByShop(
      {this.name,
      this.image,
      this.user_distances,
      this.description,
      this.Phone,
      this.email,
      this.website,
      this.address,
      this.is_On,
      this.rate,
      this.raters_count,
      this.sold_count,
      this.longitude,
      this.Latitude,
      this.ShopCity,
      this.Dealer,
      this.id,
      this.ProductCount});
  factory NearByShop.fromJson(Map<dynamic, dynamic> json) {
    dynamic myCity;
    dynamic myDist;
    // try{

    //   Cityinfo city = Cityinfo.fromJson(json['ShopCity']);
    // myCity = city ;
    // }catch (e) {

    // }
    // try{

    // }catch (e) {

    // }
    if (json != null) {
      if (json['distance'] == null) {
        myDist = 0;
      } else {
        myDist = json['distance'];
      }
    } else {
      myDist = 0;
    }
    try {
      return NearByShop(
        user_distances: myDist,
        ProductCount: json['ProductCount'],
        name: json['name'],
        image: json['image'],
        description: json['description'],
        Phone: json['Phone'],
        email: json['email'],
        website: json['website'],
        address: json['address'],
        is_On: json['is_On'],
        rate: json['rate'],
        id: json['id'],
        raters_count: json['raters_count'],
        sold_count: json['sold_count'],
        longitude: json['longitude'],
        //  ShopCity:myCity,
        // ShopCity: json['ShopCity'],
        Dealer: json['Dealer'],
        Latitude: json['Latitude'],
      );
    } catch (_) {
      return null;
    }
  }
}

NearShop nearShopClass;

Future getAppInfo(context) async {
  try {
    var response = await dioClient.get(APIKeys.BASE_URL + 'AppInfo/1');
    var data = response.data;
    link = response.data['googlePlayUrl'];
    appInfo = AppInfo.fromJson(data);
    var packageInfo = await PackageInfo.fromPlatform();
    var buildNumber = packageInfo.buildNumber;
    var buildnum = int.tryParse(buildNumber);
    var minNumber = response.data['minbuildNumber'] != null
        ? response.data['minbuildNumber']
        : 0;
    var alertNumber = response.data['alertBuildNumber'] != null
        ? response.data['alertBuildNumber']
        : 0;
    if (buildnum <= minNumber) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                content: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Your App Needs Updating',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                actions: [
                  FlatButton(
                    color: Colors.black,
                    onPressed: () => exit(0),
                    child: Center(
                        child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )),
                  ),
                  FlatButton(
                    onPressed: () {
                      LaunchReview.launch(
                          androidAppId: response.data['googlePlayUrl'],
                          iOSAppId: response.data['appStoreUrl']);
                    },
                    color: Colors.green[200],
                    child: Center(
                        child: Text(
                      'Update',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )),
                  ),
                ],
              ));
    } else if (buildnum <= alertNumber) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                content: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Install New Updates To Get New Features',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.black,
                    child: Center(
                        child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )),
                  ),
                  FlatButton(
                    onPressed: () {
                      LaunchReview.launch(
                          androidAppId: response.data['googlePlayUrl'],
                          iOSAppId: response.data['appStoreUrl']);
                    },
                    color: Colors.green[200],
                    child: Center(
                        child: Text(
                      'Update',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )),
                  ),
                ],
              ));
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

enum DialogDemoAction {
  cancel,
  discard,
  disagree,
  agree,
}

void nonetowrk(context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: SizedBox(
          height: 100,
          child: Center(
              child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor))),
    ),
  );
  Future.delayed(const Duration(seconds: 5), () async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        checknetwork(context);
        Navigator.pop(
          context,
        );
      }
    } on SocketException catch (_) {
      checknetwork(context);
      Navigator.pop(
        context,
      );
    }
  });
}

void checknetwork(context) async {
  var context2 = context;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      {
        Future.delayed(const Duration(seconds: 5), () {
          checknetwork(context);
        });
      }
    }
  } on SocketException catch (_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SizedBox(
        height: 80,
        child: AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          content: SizedBox(
            height: 90,
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'noInternet',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: null,
                        fontWeight: FontWeight.normal),
                  ).tr(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
                  child: SizedBox(
                    height: 30,
                    width: 80,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          nonetowrk(context2);
                        },
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey, width: 2)),
                          child: Center(
                            child: Text(
                              'tryAgain',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontFamily: null,
                                  fontWeight: FontWeight.normal),
                            ).tr(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
