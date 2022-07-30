import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:customers/models/package/package.dart';
import 'package:customers/models/user.dart';
import 'package:customers/providers/api/api_provider.dart';
import 'package:customers/providers/package/package_provider.dart';
import 'package:customers/providers/payment_provider/online_payment_provider.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Packagepage extends StatefulWidget {
  final String userId;

  const Packagepage({Key key, this.userId}) : super(key: key);

  @override
  _PackagepageState createState() => _PackagepageState();
}

class _PackagepageState extends State<Packagepage> {
  
  productJson(PackageData package) {
    log('package price ${package.packagePrice * 1000}');
    return [
      {
        'name': package.packageTitle,
        'quantity': 1,
        'unit_amount': (package.packagePrice * 1000).roundToDouble(),
      }
    ];
  }

  bool isOnlinePayment = false;

  @override
  void initState() {
    var package = Provider.of<PackageProvider>(context, listen: false);
    log('UserId: $userId');
    package.fetchPackages(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PackageProvider>(builder: (context, model, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: model.state == PackageState.loading
            ? Center(child: Load(250.0))
            : model.state == PackageState.error
                ? Center(child: Text('something wrong please try again!'))
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SafeArea(
                            child: CommonAppBar(
                              backButton: true,
                              title: 'ourPackages'.tr(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListView.separated(
                                itemCount: model.packages.length,
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 10,
                                    ),
                                itemBuilder: (context, index) {
                                  final package = model.packages[index];
                                  //  <Widget>[
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // CommonAppBar(
                                  //   backButton: true,
                                  //   title: 'Our Packages',
                                  // ),
                                  return _buildPackage(context, index, model);
                                  // return Container();
                                }),
                          ),
                          Image.asset(
                            'images/bottom_town.png',
                            height: 100,
                          )
                        ],
                      ),
                    ),
                  ),
      );
    });
  }

  Container _buildPackage(
      BuildContext context, int index, PackageProvider packageProvider) {
    PackageData package = packageProvider.packages[index];
    String jsonstring = jsonEncode(productJson(package));
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:
              Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).secondaryHeaderColor,
          ], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(package.packageTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'pointLeft'.tr() + ': ' + package.packagePoints.toStringAsFixed(3),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'price'.tr() +
                          ': ' +
                          package.packagePrice.toStringAsFixed(3) + ' '+
                          'sr'.tr(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            if (package.packagePrice < 0.1) {
                              Fluttertoast.showToast(
                                    msg: 'thisPackageNotProvide'.tr(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                            }  else {
                              _buildBottomSheet(
                                    jsonstring, packageProvider, index, package);
                            //   packageProvider
                                // .assignPackage(package.id)
                            //     .then((success) {
                            //   if (success) {
                                
                            //     Fluttertoast.showToast(
                            //         msg: 'PackageAssigned'.tr(),
                            //         toastLength: Toast.LENGTH_SHORT,
                            //         gravity: ToastGravity.BOTTOM,
                            //         backgroundColor: Colors.green,
                            //         textColor: Colors.white,
                            //         fontSize: 16.0);
                            //   } else {
                                
                            //   }
                            // });
                            }
                            
                            packageProvider.setPackageIndex(index);
                            if (packageProvider.assignPackageState ==
                                AssignPackageState.loaded) {
                              log('show bottom sheet');
                            }
                            // _buildBottomSheet(
                            //     jsonstring, packageProvider, index);
                          },
                          child: ContainerResponsive(
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.local_offer,
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                SizedBoxResponsive(
                                  width: 30,
                                ),
                                packageProvider.packageIndex == index &&
                                        packageProvider.assignPackageState ==
                                            AssignPackageState.loading
                                    ? Center(
                                        child: CupertinoActivityIndicator(),
                                      )
                                    : TextResponsive('buy'.tr(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          fontSize: 20,
                                        ))
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomSheet(
      String jsonString, PackageProvider provider, int index, PackageData package) async {
        
    SharedPreferences pref = await SharedPreferences.getInstance();
    final userId = pref.getString('userId');


    log('package Id: ' +package.id.toString() + 'user id: $userId');

    Provider.of<OnlinePaymentProvider>(context, listen: false).webStarted();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      isScrollControlled: true,
      builder: (context) => Consumer<ApiProvider>(
        builder: (context1, api, _) => SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: 550,
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Consumer<OnlinePaymentProvider>(
                  builder: (_, paymentWebView, __) => Expanded(
                    child: Stack(children: [
                      Positioned.fill(
                        // child: WebView(
                        //   javascriptMode: JavascriptMode.unrestricted,
                        //   initialUrl:
                        //       'http://165.227.116.15/mishwar/api/v1/payment/thawani?data=' +
                        //           jsonString +
                        //           '&order_id=' +
                        //           provider.assignPackageId +
                        //           '&total_amount=' +
                        //           provider.packages[index].toString() ,
                        //   onPageFinished: (v) {
                        //     if (v.contains('/thawani/cancel')) {
                        //       provider.setPaymentStatus('fail');
                        //       Navigator.of(context).pop();
                        //     } else if (v.contains('/thawani/success')) {
                        //       provider.setPaymentStatus('success');
                        //       if (!provider.isUpdateStatusSuccess) {
                        //         provider.setPaymentStatus('success');
                        //       }
                        //     }
                        //     paymentWebView.webViewSucceed();
                        //   },
                        // ),
                        child: InAppWebView(
                            initialUrlRequest: URLRequest(
                                url: Uri.parse(
                                  APIKeys.THAWANI_URL,
                                ),
                                method: 'POST',
                                body: Uint8List.fromList(utf8.encode(
                                  "products=" +
                                      jsonString +
                                      '&user_id=' +
                                      userId.toString() +
                                      
                                      '&status=Package'+
                                      '&package_id=' +
                                      
                                      package.id.toString(),
                                )),
                                headers: {
                                  'Content-Type':
                                      'application/x-www-form-urlencoded'
                                }),
                            onWebViewCreated: (controller) {},
                            onLoadStop:
                                (InAppWebViewController controller, v) async {
                                  log(v.toString());
                                  log(v.toString());
                              if (v.toString().contains('/thwani/package/cancel')) {
                                
                                // provider.setPaymentStatus('fail');
                                Navigator.of(context).pop();
                              } else if (v
                                  .toString()
                                  .contains('/thawani/package/succuss')) {
                                Fluttertoast.showToast(
                                    msg: 'PackageAssigned'.tr(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                              }
                              paymentWebView.webViewSucceed();
                              
                            }),
                      ),
                      if (!paymentWebView.finished)
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        )
                    ]),
                  ),
                ),
                // TextButton(
                //   child: api.loading
                //       ? CircularProgressIndicator(
                //           color: Colors.white,
                //         )
                //       : Text(
                //           'close'.tr(),
                //           style: TextStyle(color: Colors.white),
                //         ),
                //   style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all(Colors.green)),
                //   onPressed: api.loading
                //       ? null
                //       : () {
                //           // api.request(url:'http://mishwar.thiqatech.com/api/v1/payment/verify_payment',method: HTTP_METHOD.post );
                //           Navigator.of(context).pop();
                //         },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
