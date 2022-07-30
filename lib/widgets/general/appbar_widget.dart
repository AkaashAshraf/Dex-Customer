import 'package:auto_size_text/auto_size_text.dart';
import 'package:customers/pages/auth/login_page.dart';
import 'package:customers/pages/general/notification_page.dart';
import 'package:customers/pages/orders/cart_page.dart';
import 'package:customers/providers/orders/cart_proivder.dart';
import 'package:customers/repositories/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:community_material_icon/community_material_icon.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final bool backButton;

  CommonAppBar({this.title, this.backButton});

  @override
  Widget build(BuildContext context) {
    if (title == null && backButton == null) return Container();
    return SizedBoxResponsive(
      height: 80,
      child: ContainerResponsive(
        width: 720,
        child: ContainerResponsive(
          padding: EdgeInsetsResponsive.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    backButton
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back,
                                size: ScreenUtil().setSp(50)),
                          )
                        : Container(),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            title,
                            style: TextStyle(
                                // fontSize: title.length > 20 ? 25 : 30,
                                fontWeight: FontWeight.w300),
                            // maxFontSize: 30,
                            // minFontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    // ContainerResponsive(
                    //   child: Text(
                    //     title,
                    //     style: TextStyle(
                    //         fontSize: title.length > 20 ? 25 : 30,
                    //         fontWeight: FontWeight.w300),
                    //   ),
                    // ),
                    // SizedBoxResponsive(width: 20),
                  ],
                ),
              ),
              Row(children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                  child: Stack(
                    children: <Widget>[
                      Icon(CommunityMaterialIcons.cart_outline,
                          color: Theme.of(context).secondaryHeaderColor),
                      ContainerResponsive(
                        margin:
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? EdgeInsetsResponsive.only(right: 30)
                                : EdgeInsetsResponsive.only(left: 30),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(39),
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        child: Center(child: Consumer<CartProvider>(
                          builder: (context, cartProvider, _) {
                            if (cartProvider.cartItems != null) {
                              return TextResponsive(
                                cartProvider.cartCounter.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              );
                            }
                            return Container();
                          },
                        )),
                      )
                    ],
                  ),
                ),
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
                              builder: (context) => NotificationPage()));
                    }
                  },
                  child: ContainerResponsive(
                      width: 95,
                      height: 95,
                      child: FlatButton(
                          onPressed: null,
                          child: Icon(
                            CommunityMaterialIcons.bell_outline,
                            color: Theme.of(context).secondaryHeaderColor,
                          ))),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
