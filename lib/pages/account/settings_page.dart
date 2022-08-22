import 'package:cached_network_image/cached_network_image.dart';
import 'package:customers/main.dart';
import 'package:customers/models/user.dart';
import 'package:customers/pages/account/fav.dart';
import 'package:customers/pages/account/profile.dart';
import 'package:customers/pages/account/rules_page.dart';
import 'package:customers/pages/account/wallet.dart';
import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/pages/chat/chat_list_page.dart';
import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/pages/orders/payment.dart';
import 'package:customers/pages/orders/withdraw.dart';
import 'package:customers/providers/account/user_info_provider.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/providers/services/notifications.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/repositories/shop_keys.dart';
import 'package:customers/widgets/general/place_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences prefs;

  showShowcase() async {
    var pref = await SharedPreferences.getInstance();
    bool tft = pref.getBool('tft');
    if (tft != false) {
      ShowCaseWidget.of(context).startShowCase([ShopKeys.showcaseSix]);
      showcase = 3;
      pref.setBool('tft', false);
    }
  }

  Locale _locale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAppInfo(context);
    });
    showShowcase();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin == null) {
      return Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        body: Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBoxResponsive(height: 80),
              Center(
                  child: ContainerResponsive(
                height: 200,
                width: 200,
                child: Image(image: AssetImage('assets/images/logodex.png')),
              )),
              SizedBoxResponsive(height: 30),
              Center(
                child: TextResponsive(
                  'enterMembersCenter'.tr(),
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: TextResponsive(
                    'createNewAccount'.tr(),
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).secondaryHeaderColor),
                  ),
                ),
              ),
              SizedBoxResponsive(height: 400),
              GestureDetector(
                onTap: () {
                  context.locale =
                      Localizations.localeOf(context).languageCode == 'en'
                          ? Locale('ar')
                          : Locale('en');
                  _locale = context.locale;
                  MyApp.setLocale(context, _locale);
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.translate,
                            size: 16, color: Colors.grey[600]),
                        SizedBoxResponsive(width: 30),
                        TextResponsive('changeLang'.tr(),
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            )),
                      ]),
                ),
              ),
              SizedBoxResponsive(height: 30),
              GestureDetector(
                onTap: () async {
                  await FlutterShare.share(
                      title: 'DEX',
                      text: 'check out my website www.dexoman.com',
                      linkUrl: link,
                      chooserTitle: 'DEX');
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.share, size: 16, color: Colors.grey[600]),
                        SizedBoxResponsive(width: 30),
                        TextResponsive('shareApp'.tr(),
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            )),
                      ]),
                ),
              ),
              SizedBoxResponsive(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios,
                          size: 16, color: Colors.grey[600]),
                      SizedBoxResponsive(width: 30),
                      TextResponsive('login'.tr(),
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
      );
    }
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    return ResponsiveWidgets.builder(
        height: 1560,
        width: 720,
        allowFontScaling: true,
        child: Consumer<UserInfoProvider>(builder: (context, value, _) {
          if (value.loading == false && value.user != null) {
            return Scaffold(
              body: ListView(
                children: [
                  Stack(
                    children: [
                      ContainerResponsive(
                        width: 720,
                        height: 500,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/path383.png'),
                          fit: BoxFit.fill,
                        )),
                      ),
                      ContainerResponsive(
                        width: 720,
                        height: 540,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Provider.of<NotiProvider>(context,
                                //         listen: false)
                                //     .sendNoti(
                                //         id: '508',
                                //         dataBody: "data body",
                                //         dataTit: "data title",
                                //         notiBody: 'noti body',
                                //         notiTit: 'noti title');
                              },
                              child: ContainerResponsive(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: value.user == null
                                        ? AssetImage('images/loading.gif')
                                        : CachedNetworkImageProvider(
                                            APIKeys.ONLINE_IMAGE_BASE_URL +
                                                value.user.image,
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      width: 1.5, color: Color(0xffED8437)),
                                  borderRadius: BorderRadius.circular(360),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBoxResponsive(height: 30),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextResponsive(
                          value.user.firstName.toString(),
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                        SizedBoxResponsive(height: 10),
                        TextResponsive(
                          value.user.loginPhone.toString(),
                          style: TextStyle(
                              letterSpacing: .5,
                              fontSize: 30,
                              color: Colors.grey[500]),
                        )
                      ],
                    ),
                  ),
                  SizedBoxResponsive(
                    height: 100,
                  ),
                  ContainerResponsive(
                    margin: EdgeInsetsResponsive.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile(value.user)));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'images/personal.svg',
                                fit: BoxFit.fill,
                              ),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('personalData'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Wallet(user: value.user)));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'images/async.svg',
                                fit: BoxFit.fill,
                              ),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('wallet'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                (MaterialPageRoute(
                                    builder: (context) => ChatListPage())));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'images/chat.svg',
                                fit: BoxFit.fill,
                              ),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('chat'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                (MaterialPageRoute(
                                    builder: (context) =>
                                        FavoritePage(user: value.user))));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('fav'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            if (isLogin == null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NotificationPage(id: value.user.id)));
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'images/bellring.svg',
                                fit: BoxFit.fill,
                              ),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('notifications'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Place()));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_location,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('editLocation'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        // GestureDetector(
                        //   onTap: () {
                        //     if (isLogin == null) {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => LoginScreen()));
                        //     } else {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => PaymentMethod(2)));
                        //     }
                        //   },
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Icon(Icons.money,
                        //           size: 16, color: Colors.grey[600]),
                        //       SizedBoxResponsive(width: 30),
                        //       TextResponsive('online'.tr(),
                        //           style: TextStyle(
                        //             fontSize: 30,
                        //             color: Colors.black,
                        //           ))
                        //     ],
                        //   ),
                        // ),
                        // SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            context.locale =
                                Localizations.localeOf(context).languageCode ==
                                        'en'
                                    ? Locale('ar')
                                    : Locale('en');
                            _locale = context.locale;
                            MyApp.setLocale(context, _locale);
                            setState(() {});
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.translate,
                                    size: 16, color: Colors.grey[600]),
                                SizedBoxResponsive(width: 30),
                                TextResponsive('changeLang'.tr(),
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                    )),
                              ]),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            if (isLogin == null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RulesPage()));
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_turned_in,
                                  size: 16, color: Colors.grey[600]),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('termsOfUse'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () async {
                            await FlutterShare.share(
                                title: 'DEX',
                                text: 'check out my website www.dexoman.com',
                                linkUrl: link,
                                chooserTitle: 'DEX');
                          },
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.share,
                                    size: 16, color: Colors.grey[600]),
                                SizedBoxResponsive(width: 30),
                                TextResponsive('shareApp'.tr(),
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                    )),
                              ]),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: ListTile(
                                  title: Text(
                                    "logout",
                                  ),
                                  subtitle: Text(
                                    "sureToLogout",
                                  ).tr(),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    color: Colors.grey[200],
                                    child: Text(
                                      'no',
                                      style: TextStyle(color: Colors.black),
                                    ).tr(),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  FlatButton(
                                    color: Colors.black,
                                    child: Text(
                                      'yes',
                                      style: TextStyle(color: Colors.white),
                                    ).tr(),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .clearCart();
                                      value.prefs.clear();
                                      Navigator.of(context).pop();
                                      bottomSelectedIndex = 0;
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_ios,
                                  size: 16, color: Colors.grey[600]),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('logout'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                        SizedBoxResponsive(height: 30),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: ListTile(
                                  title: Text(
                                    "deactivateAccount".tr(),
                                  ),
                                  subtitle: Text(
                                    "sureToDeactivate",
                                  ).tr(),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    color: Colors.black,
                                    child: Text(
                                      'no',
                                      style: TextStyle(color: Colors.white),
                                    ).tr(),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  FlatButton(
                                    color: Colors.grey[200],
                                    child: Text(
                                      'yes',
                                      style: TextStyle(color: Colors.black),
                                    ).tr(),
                                    onPressed: () async {
                                      final isSuccess =
                                          await value.deactiveAccount();
                                      if (isSuccess) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .clearCart();
                                        value.prefs.clear();
                                        Navigator.of(context).pop();
                                        bottomSelectedIndex = 0;
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      } else {
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: "serverErrorPleaseTryAgain"
                                                .tr(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.white,
                                            textColor:
                                                Theme.of(context).accentColor,
                                            fontSize: 15.0);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_back_ios,
                                  size: 16, color: Colors.grey[600]),
                              SizedBoxResponsive(width: 30),
                              TextResponsive('deactivateAccount'.tr(),
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBoxResponsive(height: 200),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        }));
  }
}
