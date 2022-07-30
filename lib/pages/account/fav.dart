import 'dart:developer';

import 'package:customers/models/product.dart';
import 'package:customers/models/user.dart';
import 'package:customers/providers/services/fav_provider.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:customers/widgets/general/favCard.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class FavoritePage extends StatefulWidget {
  final User user;

  FavoritePage({this.user});

  @override
  _FavoritePageState createState() => _FavoritePageState(user);
}

class _FavoritePageState extends State<FavoritePage> {
  User user;

  _FavoritePageState(user);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Favorite>(context, listen: false).getFav();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Favorite>(builder: (context, fav, _) {
      return SafeArea(
        child: Scaffold(
            body: ListView(
          shrinkWrap: true,
          children: [
            CommonAppBar(
              title: "fav".tr(),
              backButton: true,
            ),
            SizedBoxResponsive(
              height: 20,
              child: fav.loading == true
                  ? CupertinoActivityIndicator()
                  : Container(),
            ),
            fav.loading2
                ? Column(
                    children: [
                      SizedBoxResponsive(height: 400),
                      Center(
                        child: Load(200.0),
                      ),
                    ],
                  )
                : fav.favorite.isNotEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: ContainerResponsive(
                          height: 400,
                          child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: .9,
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index){
                                  return FavCard(
                                      product: fav.favorite[index].productinfo
                                              .isNotEmpty
                                          ? fav.favorite[index].productinfo[0]
                                          : Product(
                                              id: fav
                                                  .favorite[index].proudctID));},
                              itemCount: fav.favorite.length),
                        ),
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBoxResponsive(height: 400),
                            Image.asset('images/emptycart.PNG'),
                            Text(
                              'noFav',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).accentColor,
                              ),
                            ).tr(),
                          ],
                        ),
                      ),
          ],
        )),
      );
    });
  }
}
