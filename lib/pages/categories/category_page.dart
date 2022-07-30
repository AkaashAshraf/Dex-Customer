import 'package:customers/models/categories/categories.dart';
import 'package:customers/providers/categories/categories_provider.dart';
// import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/categories/home_category_card.dart';
import 'package:customers/widgets/general/appbar_widget.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool searching = false;
  List<Category> searchCategories = [];
  List<Category> categoryList = [];

  TextEditingController search = TextEditingController();
  void searchingCat(String value) {
    setState(() {
      searching = true;
    });
    searchCategories = categoryList;
    List<Category> list = searchCategories
        .where((i) => i.name.toString().contains(value))
        .toList();
    searchCategories = list;
  }

  void notSearchingCat() {
    setState(() {
      searching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoriesProvider>(context, listen: false).fetchCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: CustomScrollView(
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
                    title: "categories".tr(),
                    backButton: false,
                  )
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
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width:
                                  MediaQuery.of(context).size.width / 100 * 85,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor,
                                  borderRadius: BorderRadius.circular(2)),
                              child: TextField(
                                controller: search,
                                onChanged: (value) {
                                  if (search.text != '') {
                                    searchingCat(value);
                                  } else if (search.text == '') {
                                    notSearchingCat();
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'searchCategory'.tr(),
                                  contentPadding:
                                      EdgeInsets.only(right: 10, top: 8),
                                  hintStyle: TextStyle(fontSize: 15),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 20,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
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
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Consumer<CategoriesProvider>(
            builder: (context, value, child) {
              if (value.categories != null) {
                if (value.categories.length > 0) {
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) =>

                          HomeCategoryCard(
                        category: searching
                            ? searchCategories[index]
                            : value.categories[index],
                      ),
                      childCount: searching
                          ? searchCategories.length
                          : value.categories.length,
                    ),
                  );
                }
                return SliverPadding(
                  padding: EdgeInsets.all(0.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Center(
                            child: TextResponsive('لا توجد أقسام',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                )))
                      ],
                    ),
                  ),
                );
              }
              return
                SliverPadding(
                    padding: EdgeInsets.all(0.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                      Expanded(
                        child: Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor),
                ),
                      )
                        ],
                      ),
                    ));

            },
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
              ))
        ],
      ),
    );
  }
}
