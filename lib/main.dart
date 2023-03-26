import 'dart:async';
import 'dart:developer';
import 'dart:io';
// this is new update
import 'package:customers/providers/api/api_provider.dart';
import 'package:customers/providers/package/package_provider.dart';
import 'package:customers/providers/payment_provider/online_payment_provider.dart';
import 'package:customers/widgets/suspended_account_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/app.dart';
import 'package:customers/models/product.dart';
import 'package:customers/pages/categories/categories_products_page.dart';
import 'package:customers/pages/general/intro/intro.dart';
import 'package:customers/pages/general/splash_page.dart';
import 'package:customers/providers/account/user_info_provider.dart';
import 'package:customers/providers/account/wallet_provider.dart';
import 'package:customers/providers/categories/categories_provider.dart';
import 'package:customers/providers/categories/get_products_by_categories.dart';
import 'package:customers/providers/chat/chat_provider.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/orders/noti_provider.dart';
import 'package:customers/providers/orders/order_details_provider.dart';
import 'package:customers/providers/orders/order_providors.dart';
import 'package:customers/providers/orders/send_order_provider.dart';
import 'package:customers/providers/services/last_position_provider.dart';
import 'package:customers/providers/services/link_provider.dart';
import 'package:customers/providers/services/long_lat_provider.dart';
import 'package:customers/providers/services/notifications.dart';
import 'package:customers/providers/shop/all_product_provider.dart';
import 'package:customers/providers/shop/city_provider.dart';
import 'package:customers/providers/shop/near_shops_provider.dart';
import 'package:customers/providers/shop/search_product_provider.dart';
import 'package:customers/providers/shop/shop_product_provider.dart';
import 'package:customers/providers/shop/shop_story_provider.dart';
import 'package:customers/providers/shop/shops_provider.dart';
import 'package:customers/providers/shop/special_offers_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/theme.dart';
import 'package:customers/utils/permission_status.dart';
import 'package:customers/utils/show_notification.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart' as location;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/orders/rate_provider.dart';
import 'providers/services/fav_provider.dart';
import 'providers/services/location.dart';
import 'repositories/globals.dart';
import 'package:device_preview/device_preview.dart';

Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) async {
  await Firebase.initializeApp();
  print("_backgroundMessageHandler");
  // globals.showNotification('title', 'body');
  showNotification("notification['title']", "notification['body']");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("_backgroundMessageHandler data: $data");
    showNotification(data['title'], data['body']);
  }
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("_backgroundMessageHandler notification: $notification");
    showNotification(notification['title'], notification['body']);
  }
  return Future<void>.value();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, statusBarBrightness: Brightness.light));
  runApp(
    // DevicePreview(
    //     enabled: true,
    //     builder: (context) =>

    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<OrderCRUDProvider>(
          create: (_) => OrderCRUDProvider(),
        ),
        ChangeNotifierProvider<LastPositionProvider>(
          create: (_) => LastPositionProvider(),
        ),
        ChangeNotifierProvider<LongLatProvider>(
          create: (_) => LongLatProvider(),
        ),
        ChangeNotifierProvider<SearchProductProvider>(
          create: (_) => SearchProductProvider(),
        ),
        ChangeNotifierProvider<ShopProductProvider>(
          create: (_) => ShopProductProvider(),
        ),
        ChangeNotifierProvider<ShopsProvider>(
          create: (_) => ShopsProvider(),
        ),
        ChangeNotifierProvider<CategoriesProvider>(
          create: (_) => CategoriesProvider(),
        ),
        ChangeNotifierProvider<AllProductProvider>(
          create: (_) => AllProductProvider(),
        ),
        ChangeNotifierProvider<CityProvider>(
          create: (_) => CityProvider(),
        ),
        ChangeNotifierProvider<SpecialOffersPorvider>(
          create: (_) => SpecialOffersPorvider(),
        ),
        ChangeNotifierProvider<UserInfoProvider>(
          create: (_) => UserInfoProvider(),
        ),
        ChangeNotifierProvider<OrdersProvider>(
          create: (_) => OrdersProvider(),
        ),
        ChangeNotifierProvider<OrderDetailsProvider>(
          create: (_) => OrderDetailsProvider(),
        ),
        ChangeNotifierProvider<NearShopProvider>(
          create: (_) => NearShopProvider(),
        ),
        ChangeNotifierProvider<PermissionsProvider>(
          create: (_) => PermissionsProvider(),
        ),
        ChangeNotifierProvider<CategoyProductProvider>(
          create: (_) => CategoyProductProvider(),
        ),
        ChangeNotifierProvider<Favorite>(
          create: (_) => Favorite(),
        ),
        ChangeNotifierProvider<RateProvider>(
          create: (_) => RateProvider(),
        ),
        ChangeNotifierProvider<ShopStoryProvider>(
          create: (_) => ShopStoryProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider<LinkProvider>(
          create: (_) => LinkProvider(),
        ),
        ChangeNotifierProvider<NotiProvider>(
          create: (_) => NotiProvider(),
        ),
        ChangeNotifierProvider<WalletProvider>(
          create: (_) => WalletProvider(),
        ),
        ChangeNotifierProvider<PackageProvider>(
          create: (_) => PackageProvider(),
        ),
        ChangeNotifierProvider<ApiProvider>(create: (_) => ApiProvider()),
        ChangeNotifierProvider<OnlinePaymentProvider>(
          create: (_) => OnlinePaymentProvider(),
        )
      ],
      child: EasyLocalization(
        supportedLocales: [Locale('ar'), Locale('en')],
        path: 'translations',
        fallbackLocale: Locale('ar'),
        child: MyApp(),
      ),
    ),
    // ),
  );
}

class PaddedRaisedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PaddedRaisedButton({
    @required this.buttonText,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: RaisedButton(child: Text(buttonText), onPressed: onPressed),
    );
  }
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeLanguage(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  changeLanguage(Locale locale) {
    setState(() {
      context.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    return ConnectivityAppWrapper(
      app: MaterialApp(
        routes: {
          'home': (context) => Home(),
        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'DEX',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MediaQueryData queryData;

  dynamic _timer;
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  // ignore: cancel_subscriptions
  StreamSubscription iosSubscription;

  Future<void> getFromSF() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userId = pref.getString('userId');
      userToken = pref.getString('userToken');
      userImage = pref.getString('userImage');
      userPhone = pref.getString('userPhone');
      userName = pref.getString('userName');
      userEmail = pref.getString('userEmail');
      isLogin = pref.getString('IS_LOGIN');
      regionId = pref.getInt('regionId') != null ? pref.getInt('regionId') : 0;
      regionId += 3;
    });
    if (userId != 'null' && userId != null) {
      sendToken(userId);
    }
  }

  bool main;
  String productId;
  String id;
  String name;

  int times = 0;

  void emptyCashe() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt('times') != null ? times = pref.getInt('times') : times = times;
    if (times >= 10) {
      DefaultCacheManager().emptyCache();
      pref.setInt('times', 0);
    } else {
      times++;
      pref.setInt('times', times);
    }
  }

  Future<void> getProduct(var _productId) async {
    print('produuuuuct id \n$_productId');
    try {
      var response = await Dio()
          .get(APIKeys.BASE_URL + 'getProduct/ProdcutId&$_productId');
      var data = response.data['Data'][0];
      print(data);
      var product = Product.fromJson(data);
      await navigateToProduct(id: id, name: name, product: product);
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

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      log('dynamicLink: $deepLink');
      if (deepLink != null) {
        setState(() {
          main = true;
          productId = deepLink.queryParameters['product'];
          id = deepLink.queryParameters['refrenced'];
          name = deepLink.queryParameters['name'];
          print('dynamicLink' + "$deepLink $id | $productId | $name");
        });
      } else {
        setState(() {
          main = false;
        });
      }
    }, onError: (OnLinkErrorException e) async {
      log('dynamicLink' + e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      setState(() {
        main = true;
        productId = deepLink.queryParameters['product'];
        id = deepLink.queryParameters['refrence'];
        name = deepLink.queryParameters['name'];
        log('dynamicLink' + " $deepLink $id | $productId | $name");
      });
    } else {
      setState(() {
        main = false;
      });
    }
  }

  Future _getLocation(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    var token = await FirebaseMessaging.instance.getToken();

    print('TOKEN $token');
  }

  void checkStatus() async {
    var status = Permission.location;
    switch (await status.status) {
      case permission.PermissionStatus.denied:
        // do something
        // print(PermissionStatus.denied);

        break;
      case permission.PermissionStatus.granted:
        // do something;
        // print(PermissionStatus.granted);

        break;
      case permission.PermissionStatus.permanentlyDenied:
        // do something
        // print(PermissionStatus.disabled);

        break;
      case permission.PermissionStatus.restricted:
        // do something
        // print(PermissionStatus.restricted);

        break;

        break;
      default:
    }
    Future.delayed(const Duration(seconds: 5), () {
      checkStatus();
    });
  }

  _startUp() async {
    await getAppInfo(context);
    var pref = await SharedPreferences.getInstance();
    var _location = pref.getBool('locSelected') ?? false;
    Location loc = Location();
    _timer = Timer(
        const Duration(
          milliseconds: 1,
        ), () async {
      if (isLogin != null) {
        await initDynamicLinks();
        if (main == true) {
          await getProduct(productId);
        } else {
          print('main is $main');
          if (_location) {
            navigateToHome();
          } else {
            if (await loc.hasPermission() ==
                location.PermissionStatus.granted) {
              navigateToLoc();
            } else {
              await loc.requestPermission();
              navigateToLoc();
            }
          }
        }
      } else {
        navigateToLogin();
      }
    });
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    // if (payload != null) {
    //   debugPrint('notification payload: ' + payload);
    // }
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _showNotification(title, body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      ledColor: const Color.fromARGB(255, 0, 255, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, '$title', '$body', platformChannelSpecifics,
        payload: 'item x');
  }

  void noti() {
    FirebaseMessaging.onMessage.listen((message) async {
      print('on message $message ');
      dynamic notification = message.notification;
      dynamic data = message.data;
      dynamic datatitle = data['text'];
      dynamic notificationtitle = notification['title'].toString();
      dynamic notificationbody = notification['body'].toString();
      if (notification['title'] != null) {
        await _showNotification(notificationtitle, notificationbody);
      }
    });
  }

  int timer = 0;
  startTimer() async {
    await Future.delayed(Duration(seconds: 1));
    timer++;
    if (timer < 7) {
      startTimer();
    } else {
      return;
    }
  }

  Future sendToken(var usrId) async {
    try {
      var token = await FirebaseMessaging.instance.getToken();

      print('TOKEN $token');

      var response = await dioClient.get(
          APIKeys.BASE_URL + 'sendToken/Userid=$usrId&token=$token&appId=1');

      print('TOKEN RESPONSE $response');
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
  void initState() {
    timer = 0;
    startTimer();
    emptyCashe();
    super.initState();
    fromMain = true;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    noti();
    getFromSF();
    // checkStatus();
    _startUp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocation(context);
    });
  }

  navigateToLogin() async {
    if (timer >= 4) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroScreen()));
    } else {
      await Future.delayed(Duration(seconds: 1));
      navigateToLogin();
    }
  }

  navigateToProduct({var id, var product, var name}) async {
    if (timer >= 4) {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryProductHome(
                from: 'main',
                refrence: id,
                product: product,
                refName: name.toString(),
              )));
    } else {
      await Future.delayed(Duration(seconds: 1));
      navigateToProduct(id: id, name: name, product: product);
    }
  }

  navigateToLoc() async {
    if (timer >= 4) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProductLocation(from: 'main')));
    } else {
      await Future.delayed(Duration(seconds: 1));
      navigateToLoc();
    }
  }

  navigateToHome() async {
    if (timer >= 4) {
      Navigator.of(context).pushReplacementNamed('home');
    } else {
      await Future.delayed(Duration(seconds: 1));
      navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191b17),
      body: ConnectivityWidgetWrapper(
        message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
        child: SplashPage(),
      ),
    );
  }
}
