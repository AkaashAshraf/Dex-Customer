import 'dart:developer';

import 'package:customers/models/user.dart';
import 'package:customers/pages/account/packagedetail.dart';
import 'package:customers/providers/account/wallet_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:customers/widgets/general/wallet_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Wallet extends StatefulWidget {
  final User user;
  const Wallet({Key key, this.user}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  void initState() {
    var wlt = Provider.of<WalletProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wlt.startLoad();
       wlt.calculate(widget.user.minPoints * 1.0, widget.user.maxPoints * 1.0,
           widget.user.points != null ? widget.user.points * 1.0 : 0.0);
      // wlt.calculate(157.0 * 1.0, 200.0 * 1.0,
      //     widget.user.points != null ? widget.user.points * 1.0 : 0.0);
      wlt.getSharedProducts(id: widget.user.id.toString());
      wlt.getPoints(id: widget.user.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(builder: (context, wallet, _) {
      return SafeArea(
        child: Scaffold(
          body: wallet.load < 3
              ? Center(child: Load(250.0))
              : ListView(
                  shrinkWrap: false,
                  children: [
                    ContainerResponsive(
                      padding: EdgeInsetsResponsive.only(bottom: 20),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400],
                                blurRadius: 7,
                                offset: Offset.fromDirection(1.5, 5))
                          ],
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )),
                      child: Column(
                        children: [
                          SizedBoxResponsive(height: 65),
                          Padding(
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 20.0),
                            child: Row(
                              children: [
                                TextResponsive(
                                  '${widget.user.firstName}',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBoxResponsive(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextResponsive(
                                        'Totalpts'.tr() +
                                            ' : ' +
                                            '${widget.user.points.toStringAsFixed(2)}' +
                                            ' ' +
                                            'pts'.tr(),
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      SizedBoxResponsive(height: 20),
                                      TextResponsive(
                                        'Totalcash'.tr() +
                                            ' : ' +
                                            '${widget.user.credit.toStringAsFixed(1)}' +
                                            ' ' +
                                            'sr'.tr(),
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      SizedBoxResponsive(height: 20),
                                      TextResponsive(
                                        'Currentlevel'.tr() +
                                            ' : ' +
                                            ' ' +
                                            "${context.locale == Locale('ar') ? widget.user.dexLevelAr.toString() : widget.user.dexLevel.toString()}",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      SizedBoxResponsive(height: 20),
                                      TextResponsive(
                                        'PointsPshare'.tr() +
                                            ' : ' +
                                            ' ${widget.user.gainPoints} ' +
                                            ' ' +
                                            'pts'.tr(),
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                      SizedBoxResponsive(height: 20),
                                      TextResponsive(
                                        'Points%'.tr() +
                                            ' : ' +
                                            ' ${widget.user.gainPercentage}' +
                                            ' ' +
                                            '%',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ]),
                              ),
                              // Padding(
                              //     padding: EdgeInsetsResponsive.symmetric(
                              //         horizontal: 30),
                              //     child: CachedNetworkImage(
                              //       imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                              //           widget.user.levelImg.toString(),
                              //       width: 100,
                              //       height: 100,
                              //     ))

                              ContainerResponsive(
                                  padding: EdgeInsetsResponsive.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Packagepage(
                                                userId:
                                                    widget.user.id.toString())),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.local_offer,
                                            color: Colors.grey[200]),
                                        SizedBoxResponsive(
                                          width: 5,
                                        ),
                                        wallet.loadingCredit
                                            ? CupertinoActivityIndicator()
                                            : TextResponsive('packageUpgrade'.tr(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ))
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBoxResponsive(height: 15),
                    Padding(
                      padding: EdgeInsetsResponsive.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextResponsive(
                                'progress'.tr(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              TextResponsive(
                                '${wallet.precentage.toStringAsFixed(3)}%',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBoxResponsive(
                            height: 10,
                          ),
                          ContainerResponsive(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                border:
                                    Border.all(width: 1, color: Colors.black)),
                            child: LinearProgressIndicator(
                                minHeight: 13,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).secondaryHeaderColor,
                                ),
                                backgroundColor: Colors.white,
                                value: wallet.precentage / 100),
                          ),
                          SizedBoxResponsive(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextResponsive(
                                '${widget.user.dexLevel}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              TextResponsive(
                                '',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBoxResponsive(height: 5),
                    Stack(
                      children: [
                        ContainerResponsive(
                          height: 350,
                          width: 720,
                          margin: EdgeInsetsResponsive.symmetric(
                              vertical: 20, horizontal: 20),
                          padding: EdgeInsetsResponsive.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 6,
                                  offset: Offset.fromDirection(1.5, 5))
                            ],
                          ),
                          child: charts.TimeSeriesChart(
                            wallet.createSampleData(wallet.spot),
                            primaryMeasureAxis: charts.NumericAxisSpec(
                                tickProviderSpec:
                                    charts.BasicNumericTickProviderSpec(
                                        dataIsInWholeNumbers: false),
                                renderSpec: charts.SmallTickRendererSpec(
                                  labelStyle: charts.TextStyleSpec(
                                    fontSize: 10,
                                    color: charts.MaterialPalette.white,
                                  ),
                                )),
                            domainAxis: charts.DateTimeAxisSpec(
                                tickProviderSpec:
                                    charts.StaticDateTimeTickProviderSpec(
                                  wallet.spec(wallet.spot),
                                ),
                                tickFormatterSpec:
                                    charts.AutoDateTimeTickFormatterSpec(
                                  day: charts.TimeFormatterSpec(
                                    format: 'dd MMM',
                                    transitionFormat: 'dd MMM',
                                  ),
                                ),
                                renderSpec: charts.SmallTickRendererSpec(
                                  labelStyle: charts.TextStyleSpec(
                                    fontSize: 10,
                                    color: charts.MaterialPalette.white,
                                  ),
                                )),
                            animate: false,
                            behaviors: [
                              charts.SlidingViewport(),
                              charts.PanAndZoomBehavior(),
                            ],
                            dateTimeFactory:
                                const charts.LocalDateTimeFactory(),
                            defaultRenderer: charts.LineRendererConfig(
                              includePoints: true,
                            ),
                          ),
                        ),
                        Positioned(
                          right: context.locale == Locale('en') ? 40 : null,
                          left: context.locale == Locale('en') ? null : 40,
                          bottom: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: Colors.white)),
                                child: TextResponsive(
                                  'credit'.tr() +
                                      ' : ' +
                                      ' ${widget.user.credit.toStringAsFixed(1)}' +
                                      ' ' +
                                      'sr'.tr(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                              SizedBoxResponsive(
                                height: 20,
                              ),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: Colors.white)),
                                child: TextResponsive(
                                  'Totalpts'.tr() +
                                      ' : ' +
                                      ' ${widget.user.points}' +
                                      ' ' +
                                      'pts'.tr(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBoxResponsive(height: 30),
                    Padding(
                      padding: EdgeInsetsResponsive.symmetric(horizontal: 20.0),
                      child: TextResponsive(
                        'TransactionHistory'.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBoxResponsive(height: 20),
                    wallet.sharedProducts.isEmpty
                        ? Column(
                            children: [
                              SizedBoxResponsive(
                                  height: 400,
                                  child: Center(
                                      child: TextResponsive('NoProducts'.tr(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black)))),
                            ],
                          )
                        : ContainerResponsive(
                            height: 400,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: wallet.sharedProducts.length,
                              itemBuilder: (context, index) => WalletCard(
                                  sharedProduct: wallet.sharedProducts[index]),
                            ),
                          ),
                    SizedBoxResponsive(height: 30),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ContainerResponsive(
                              width: 100,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .secondaryHeaderColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: wallet.amount,
                                maxLines: 1,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsetsResponsive.only(
                                            top: 10, left: 5, right: 5),
                                    counterText: '',
                                    border: InputBorder.none),
                              )),
                          SizedBoxResponsive(width: 10),
                          GestureDetector(
                            onTap: () async {
                              if (!wallet.loadingCredit) {
                                if (wallet.amount.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: 'enterAmount2'.tr(),
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }
                                if (double.parse(widget.user.pointsMinLevel
                                        .toString()) >
                                    double.parse(
                                        widget.user.points.toString())) {
                                  Fluttertoast.showToast(
                                    msg: 'ptsMin'.tr(),
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }
                                if (double.parse(
                                        wallet.amount.text.toString()) >
                                    double.parse(
                                        widget.user.points.toString())) {
                                  Fluttertoast.showToast(
                                    msg: 'amountGreaterThanPoints'.tr(),
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }
                                if (double.parse(widget.user.withdrawalLimt) <
                                    double.parse(
                                        wallet.amount.text.toString())) {
                                  Fluttertoast.showToast(
                                    msg: 'limitExceded'.tr(),
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }
                                wallet.pointToCredit(
                                    id: widget.user.id.toString(),
                                    amount: wallet.amount.text);
                                wallet.emptyAmount(1);
                              }
                            },
                            child: ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context)
                                      .secondaryHeaderColor,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.money,
                                        color: Colors.grey[200]),
                                    SizedBoxResponsive(
                                      width: 5,
                                    ),
                                    wallet.loadingCredit
                                        ? CupertinoActivityIndicator()
                                        : TextResponsive(
                                            'pointsToCredit'.tr(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ))
                                  ],
                                )),
                          ),
                          ContainerResponsive(
                              margin:
                                  EdgeInsetsResponsive.symmetric(horizontal: 20),
                              width: 2,
                              height: 100,
                              color: Colors.grey[300]),
                          ContainerResponsive(
                              width: 100,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .secondaryHeaderColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: wallet.amount2,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsetsResponsive.only(
                                            top: 10, left: 5, right: 5),
                                    counterText: '',
                                    border: InputBorder.none),
                              )),
                          SizedBoxResponsive(width: 10),
                          GestureDetector(
                            onTap: () async {
                              if (!wallet.loadingCash) {
                                if (wallet.amount2.text.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: 'enterAmount2'.tr(),
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }
                                if (int.parse(
                                        wallet.amount2.text.toString()) >
                                    int.parse(
                                        widget.user.credit.toString())) {
                                  Fluttertoast.showToast(
                                    msg: 'amountGreaterThanCredit'.tr(),
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }
                                wallet.creditToCash(
                                    id: widget.user.id.toString(),
                                    amount: wallet.amount2.text);
                                wallet.emptyAmount(2);
                              }
                            },
                            child: ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context)
                                      .secondaryHeaderColor,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.money,
                                        color: Colors.grey[200]),
                                    SizedBoxResponsive(
                                      width: 5,
                                    ),
                                    wallet.loadingCash
                                        ? CupertinoActivityIndicator()
                                        : TextResponsive(
                                            'creditToCash'.tr(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ))
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      );
    });
  }
}
