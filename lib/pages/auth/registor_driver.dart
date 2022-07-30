import 'package:customers/providers/shop/city_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class RegistorDriver extends StatefulWidget {
  const RegistorDriver({Key key}) : super(key: key);

  @override
  _RegistorDriverState createState() => _RegistorDriverState();
}

class _RegistorDriverState extends State<RegistorDriver> {
  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var date = TextEditingController();
  var notes = TextEditingController();
  var phoneIsoCode = '';

  Widget test() {
    return DropdownButton<String>(
      items: <String>[
        '+968',
        '+249',
        '‎+966',
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: TextResponsive(
            value,
            style: TextStyle(
                color: Colors.black,
                fontFamily: "CoconNextArabic",
                fontSize: (24)),
          ),
        );
      }).toList(),
      underline: ContainerResponsive(
        decoration: BoxDecoration(
          border: null,
        ),
      ),
      hint: TextResponsive(
        phoneIsoCode == null ? '+249' : phoneIsoCode,
        style: TextStyle(
            color: Colors.black, fontFamily: "CoconNextArabic", fontSize: (24)),
      ),
      onChanged: (v) {
        phoneIsoCode = v;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    phoneIsoCode = '+968';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: TextResponsive('registorAsDriver'.tr(),
              style: TextStyle(fontSize: 30, color: Colors.black)),
        ),
        body: Consumer<CityProvider>(builder: (context, cityProvider, _) {
          return ListView(
            children: [
              SizedBoxResponsive(height: 250),
              ContainerResponsive(
                margin: EdgeInsetsResponsive.only(left: 25, right: 25),
                height: 75,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 7,
                          offset: Offset.fromDirection(1.5, 5))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsetsResponsive.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black),
                        hintText: 'userName'.tr()),
                  ),
                ),
              ),
              SizedBoxResponsive(height: 40),
              ContainerResponsive(
                  height: 75,
                  margin: EdgeInsetsResponsive.only(left: 25, right: 25),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200],
                            blurRadius: 7,
                            offset: Offset.fromDirection(1.5, 5))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: context.locale == Locale('en')
                      ? Row(children: [
                          Padding(
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 12.0),
                            child: test(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 8.0),
                              child: TextField(
                                controller: phone,
                                maxLength: phoneIsoCode == '+968' ? 8 : 9,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.black),
                                  hintText: 'phoneNumber'.tr(),
                                ),
                              ),
                            ),
                          ),
                        ])
                      : Row(children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsResponsive.symmetric(
                                  horizontal: 8.0),
                              child: TextField(
                                controller: phone,
                                maxLength: phoneIsoCode == '+968' ? 8 : 9,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.black),
                                  hintText: 'phoneNumber'.tr(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsResponsive.symmetric(
                                horizontal: 12.0),
                            child: test(),
                          ),
                        ])),
              SizedBoxResponsive(height: 40),
              ContainerResponsive(
                margin: EdgeInsetsResponsive.only(left: 25, right: 25),
                heightResponsive: true,
                widthResponsive: true,
                height: 75,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 7,
                          offset: Offset.fromDirection(1.5, 5))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsetsResponsive.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.black),
                        hintText: 'userEmail'.tr()),
                  ),
                ),
              ),
              SizedBoxResponsive(height: 50),
              ContainerResponsive(
                padding: EdgeInsetsResponsive.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ContainerResponsive(
                      padding: EdgeInsetsResponsive.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).secondaryHeaderColor)),
                      width: 310,
                      child: Row(
                        children: [
                          ContainerResponsive(
                            width: 210,
                            child: TextResponsive(
                                "${'from'.tr()} : ${cityProvider.city1name}",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                          PopupMenuButton<int>(
                            onSelected: (value) {
                              cityProvider.selectCity1(value + 3);
                            },
                            itemBuilder: (context) =>
                                cityProvider.citiesPopMenuList,
                          ),
                        ],
                      ),
                    ),
                    SizedBoxResponsive(width: 10),
                    ContainerResponsive(
                      padding: EdgeInsetsResponsive.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).secondaryHeaderColor)),
                      width: 310,
                      child: Row(
                        children: [
                          ContainerResponsive(
                              width: 210,
                              child: TextResponsive(
                                  "${'to'.tr()} : ${cityProvider.city2name}",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ))),
                          PopupMenuButton<int>(
                            onSelected: (value) {
                              cityProvider.selectCity2(value + 3);
                            },
                            itemBuilder: (context) =>
                                cityProvider.citiesPopMenuList,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBoxResponsive(height: 40),
              Padding(
                padding: EdgeInsetsResponsive.symmetric(horizontal: 35),
                child: TextResponsive('pickDate'.tr(),
                    style: TextStyle(fontSize: 25)),
              ),
              SizedBoxResponsive(height: 10),
              GestureDetector(
                onTap: () async {
                  cityProvider.pickDate(context: context);
                },
                child: ContainerResponsive(
                    height: 75,
                    margin: EdgeInsetsResponsive.symmetric(horizontal: 30),
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).secondaryHeaderColor)),
                    child: Center(
                      child: Row(
                        children: [
                          TextResponsive(
                              cityProvider.datePicked
                                  ? cityProvider.selectedDate
                                  : 'pickDate'.tr(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black)),
                        ],
                      ),
                    )),
              ),
              SizedBoxResponsive(height: 20),
              Padding(
                padding: EdgeInsetsResponsive.symmetric(
                    horizontal: 35, vertical: 10),
                child: TextResponsive('notes'.tr(),
                    style: TextStyle(fontSize: 25)),
              ),
              ContainerResponsive(
                margin: EdgeInsetsResponsive.only(left: 25, right: 25),
                padding: EdgeInsetsResponsive.only(left: 25, right: 25),
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).secondaryHeaderColor),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: notes,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
                      hintText: 'userNotes'.tr()),
                ),
              ),
              SizedBoxResponsive(height: 150),
              ContainerResponsive(
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 50),
                  height: 75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).secondaryHeaderColor),
                  child: Center(
                    child: TextResponsive('confirm'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                  ))
            ],
          );
        }));
  }
}
