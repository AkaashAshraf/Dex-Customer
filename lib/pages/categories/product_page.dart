import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/categories/categories.dart';
import 'package:customers/models/product.dart';
import 'package:customers/pages/categories/categories_page.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class ProductHome extends StatefulWidget {
  Category category;

  ProductHome({this.category});

  @override
  _ProductHomeState createState() => _ProductHomeState(category);
}

class _ProductHomeState extends State<ProductHome> {
  Category category;

  _ProductHomeState(this.category);

  var boxOn = true;
  var listOn = false;
  var nearOn = false;
  var selectedMenu = 1;
  var loading = false;
  var loading2 = false;
  var nextProducts;
  List<Product> productList = [];
  ScrollController scrollController = ScrollController();

  Future getProducts() async {
    try {
      loading = true;
      var response = await dioClient.get(APIKeys.BASE_URL +
          'getProducts/shopId=all&catId&${category.id}&OrderBy_vield=id&regionId=$regionId');

      var data = response.data['data'];
      var products = data as List;
      productList =
          products.map<Product>((json) => Product.fromJson(json)).toList();
      nextProducts = response.data['next_page_url'];
      setState(() {
        loading = false;
      });

      print(productList.length);
      print(productList[0].name);
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

  ProductLoad() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        CommonAppBar(
          title: category.name,
          backButton: true,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 100 * 85,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Color(0xffF9F9F9),
                        borderRadius: BorderRadius.circular(2)),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'searchProduct'.tr(),
                        contentPadding: EdgeInsets.only(right: 10, top: 8),
                        hintStyle: TextStyle(fontSize: 15),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Center(child: Load(150.0))
      ],
    );
  }

  getMoreProducts() async {
    if (nextProducts != null) {
      var response = await Dio().get(nextProducts);
      var data = response.data['data'];
      var newproducts = data as List;
      var _newproducts =
          newproducts.map<Product>((json) => Product.fromJson(json)).toList();
      productList = productList + _newproducts;
      nextProducts = response.data['next_page_url'];
    }
    setState(() {
      loading2 = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          loading2 != true) {
        print('end');
        setState(() {
          loading2 = true;
        });
        getMoreProducts();
      }
    });
  }

  _productsCardGrid(int index) {
    return GestureDetector(
      onTap: () async {
        void function = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryHome(
                      product: productList[index],
                    )));
        setState(() {});
      },
      child: Center(
        child: Container(
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 26, right: 25),
                  child: CachedNetworkImage(
                    width: 68,
                    height: 65,
                    imageUrl: APIKeys.ONLINE_IMAGE_BASE_URL +
                        productList[index].image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => ImageLoad(75.0),
                    errorWidget: (context, url, error) => Image.asset(
                      'images/image404.png',
                      width: 78,
                      height: 65,
                    ),
                  ),
                ),
                Container(
                    margin:
                        EdgeInsets.only(left: 26, right: 25, top: 5, bottom: 0),
                    child: Image.asset(
                      'images/shadow.png',
                      width: 100,
                      height: 8,
                      fit: BoxFit.contain,
                    )),
                Center(
                    child: Text(
                  productList[index].name != null
                      ? productList[index].name
                      : 'empty',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      child: ConnectivityWidgetWrapper(
        message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: loading
                ? ProductLoad()
                : Stack(children: <Widget>[
                    CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        /*** Header One ***/
                        SliverPadding(
                          padding: EdgeInsets.all(0.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SizedBox(
                                  height: 40,
                                ),
                                CommonAppBar(
                                  title: category.name,
                                  backButton: true,
                                )
                              ],
                            ),
                          ),
                        ),

                        ///*** Header Two ***/
                        SliverPadding(
                          padding: EdgeInsets.all(0.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                100 *
                                                85,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).hintColor,
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'searchProduct'.tr(),
                                                contentPadding: EdgeInsets.only(
                                                    right: 10, top: 8),
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  size: 20,
                                                ),
                                              ),
                                              textAlign: TextAlign.right,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        productList.isNotEmpty
                            ? SliverGrid(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) =>
                                      _productsCardGrid(index),
                                  childCount: productList.length,
                                ),
                              )
                            : SliverPadding(
                                padding: EdgeInsets.all(0.0),
                                sliver: SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      SizedBoxResponsive(
                                        height: 250,
                                      ),
                                      Center(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            width: 200,
                                            height: 150,
                                            imageUrl:
                                                APIKeys.ONLINE_IMAGE_BASE_URL +
                                                    category.image,
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                                ImageLoad(80.0),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        'images/image404.png'),
                                          ),
                                          Image.asset(
                                            'images/shadow.png',
                                            width: 150,
                                            fit: BoxFit.contain,
                                          ),
                                          SizedBoxResponsive(height: 20),
                                          TextResponsive('... قريباً',
                                              style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                              )),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              ),

                        SliverPadding(
                          padding: EdgeInsets.all(0.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    loading2
                        ? Positioned(
                            bottom: 10,
                            child: ContainerResponsive(
                                width: 720,
                                child: Center(
                                    child: CupertinoActivityIndicator())),
                          )
                        : Container(),
                  ])),
      ),
    );
  }
}
