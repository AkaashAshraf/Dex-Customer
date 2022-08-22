import 'package:customers/providers/orders/order_providors.dart';
import 'package:customers/repositories/shop_keys.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:customers/widgets/orders/completed_order_row.dart';
import 'package:customers/widgets/orders/doing_order_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:showcaseview/showcase.dart';

class OrdersPage extends StatefulWidget {
  final String from;

  OrdersPage({this.from});

  @override
  _OrdersPageState createState() => _OrdersPageState(from);
}

class _OrdersPageState extends State<OrdersPage> {
  String from;

  _OrdersPageState(this.from);

  Future<void> _loadOrders() async {
    await Provider.of<OrdersProvider>(context, listen: false).getOrders();
  }

  // showShowcase() async {
  //   var pref = await SharedPreferences.getInstance();
  //   bool sft = pref.getBool('sft');
  //   if (sft != false) {
  //     ShowCaseWidget.of(context).startShowCase([ShopKeys.showcaseFive]);
  //     showcase = 2;
  //   }
  // }

  ScrollController controllerDon = ScrollController();
  ScrollController controllerCom = ScrollController();

  @override
  void initState() {
    super.initState();
    // showShowcase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
    controllerDon.addListener(() {
      if (controllerDon.position.pixels ==
              controllerDon.position.maxScrollExtent &&
          Provider.of<OrdersProvider>(context, listen: false).loading ==
              false) {
        Provider.of<OrdersProvider>(context, listen: false).loadMoreDonig();
      }
    });
    controllerCom.addListener(() {
      if (controllerCom.position.pixels ==
              controllerCom.position.maxScrollExtent &&
          Provider.of<OrdersProvider>(context, listen: false).loading ==
              false) {
        Provider.of<OrdersProvider>(context, listen: false).loadMoreComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1560,
      width: 720,
      allowFontScaling: true,
    );
    return Consumer<OrdersProvider>(builder: (context, value, _) {
      return ResponsiveWidgets.builder(
          height: 1560,
          width: 720,
          allowFontScaling: true,
          child: Scaffold(
              appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  leading: from == 'settings'
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ))
                      : Container(),
                  title: TextResponsive(
                    'myOrders'.tr(),
                    style: TextStyle(fontSize: 35, color: Colors.black),
                  )),
              body: value.loading1 == false
                  ? Column(
                      children: [
                        from == 'settings'
                            ? value.completeOrderList.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          CompletedOrderRow(
                                        deliveryHistory:
                                            value.completeOrderList[index],
                                      ),
                                      itemCount: value.completeOrderList.length,
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBoxResponsive(height: 500),
                                        Container(
                                            color: Colors.white,
                                            width: 200,
                                            height: 200,
                                            child: Image.asset(
                                              "images/box_off.PNG",
                                              fit: BoxFit.fill,
                                            )),
                                        Text("noOrders").tr(),
                                      ],
                                    ),
                                  )
                            : value.doingorderList.isNotEmpty ||
                                    value.completeOrderList.isNotEmpty
                                ? Flexible(
                                    child: DefaultTabController(
                                      initialIndex: 0,
                                      length: 2,
                                      child: SizedBox(
                                        child: Column(
                                          children: <Widget>[
                                            TabBar(
                                              indicatorColor: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              indicatorWeight: 2,
                                              tabs: <Widget>[
                                                Tab(
                                                  child: Text(
                                                    'preOrders',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ).tr(),
                                                ),
                                                Tab(
                                                  child: Text(
                                                    'orderHistory',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ).tr(),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100 *
                                                    65.0,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Stack(
                                                  children: <Widget>[
                                                    TabBarView(
                                                      children: <Widget>[
                                                        Consumer<
                                                            OrdersProvider>(
                                                          builder: (context,
                                                              value, child) {
                                                            if (value
                                                                    .loading1 ==
                                                                false) {
                                                              return Showcase(
                                                                key: ShopKeys
                                                                    .showcaseFive,
                                                                overlayOpacity:
                                                                    0.75,
                                                                shapeBorder:
                                                                    CircleBorder(),
                                                                showcaseBackgroundColor:
                                                                    Colors
                                                                        .green,
                                                                overlayColor:
                                                                    Colors.blue[
                                                                        200],
                                                                description:
                                                                    'هنا تظهر طلباتك التي لم تتم بعد',
                                                                disableAnimation:
                                                                    false,
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  child: value.doingorderList
                                                                              .length >
                                                                          0
                                                                      ? RefreshIndicator(
                                                                          onRefresh:
                                                                              _loadOrders,
                                                                          child:
                                                                              ListView.builder(
                                                                            controller:
                                                                                controllerDon,
                                                                            itemBuilder: (context, index) =>
                                                                                DoingOrderRow(order: value.doingorderList[index]),
                                                                            itemCount:
                                                                                value.doingorderList.length,
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                  color: Colors.white,
                                                                                  width: 200,
                                                                                  height: 200,
                                                                                  child: Image.asset(
                                                                                    "images/box_off.PNG",
                                                                                    fit: BoxFit.fill,
                                                                                  )),
                                                                              Text("noOrders").tr(),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                ),
                                                              );
                                                            }
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          },
                                                        ),
                                                        Consumer<
                                                            OrdersProvider>(
                                                          builder: (context,
                                                              value, child) {
                                                            if (value
                                                                    .loading1 ==
                                                                false) {
                                                              return Container(
                                                                height: 190,
                                                                width: 200,
                                                                color: Colors
                                                                    .white,
                                                                child: value.completeOrderList
                                                                            .length >
                                                                        0
                                                                    ? RefreshIndicator(
                                                                        onRefresh:
                                                                            _loadOrders,
                                                                        child: ListView
                                                                            .builder(
                                                                          controller:
                                                                              controllerCom,
                                                                          itemBuilder: (context, index) =>
                                                                              CompletedOrderRow(
                                                                            deliveryHistory:
                                                                                value.completeOrderList[index],
                                                                          ),
                                                                          itemCount: value
                                                                              .completeOrderList
                                                                              .length,
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                                color: Colors.white,
                                                                                width: 200,
                                                                                height: 200,
                                                                                child: Image.asset(
                                                                                  "images/box_off.PNG",
                                                                                  fit: BoxFit.fill,
                                                                                )),
                                                                            Text("noOrders").tr(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                              );
                                                            }
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    value.loading == true
                                                        ? Positioned(
                                                            bottom: 10,
                                                            child: ContainerResponsive(
                                                                width: 720,
                                                                child: Center(
                                                                    child:
                                                                        CupertinoActivityIndicator())))
                                                        : Container()
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBoxResponsive(height: 500),
                                        Container(
                                            color: Colors.white,
                                            width: 200,
                                            height: 200,
                                            child: Image.asset(
                                              "images/box_off.PNG",
                                              fit: BoxFit.fill,
                                            )),
                                        Text("noOrders").tr(),
                                      ],
                                    ),
                                  )
                      ],
                    )
                  : Center(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBoxResponsive(height: 600),
                        CircularProgressIndicator(),
                      ],
                    ))));
    });
  }
}
