import 'package:customers/app.dart';
import 'package:customers/models/tranz.dart';
import 'package:customers/models/user.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class Charge extends StatefulWidget {
  final dynamic info;
  Charge(this.info);
  @override
  _ChargeState createState() => _ChargeState();
}

class _ChargeState extends State<Charge> {
  bool loading = false;

  getList() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await Dio()
          .get(APIKeys.BASE_URL + 'getTransactions/CustomerId&${user.id}');
      print('RESPONSE ${response.data}');
      if (response.data != null) {
        loading = false;
        setState(() {});
        tranzList = response.data
            .map<TranzList>((json) => TranzList.fromJson(json))
            .toList();
      }
    } on DioError catch (error) {
      await Fluttertoast.showToast(
          msg: 'tryAgain'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loading = false;
      });
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          rethrow;
          break;
        default:
          rethrow;
      }
    } catch (error) {
      await Fluttertoast.showToast(
          msg: 'tryAgain'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.info);
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
      child: Scaffold(
        body: ConnectivityWidgetWrapper(
          child: ContainerResponsive(
              child: ListView(
            children: <Widget>[
              SizedBoxResponsive(height: 150),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Image.asset('images/logo.png',
                            height: ScreenUtil().setHeight(200),
                            width: ScreenUtil().setWidth(350),
                            fit: BoxFit.fitWidth)),
                    TextResponsive('chargeSent'.tr(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: widget.info.state == 'true'
                              ? Theme.of(context).primaryColor
                              : widget.info.state == 'waiting'
                                  ? Colors.yellow[600]
                                  : Colors.redAccent,
                        )),
                    SizedBoxResponsive(height: 5),
                    TextResponsive('',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        )),
                    SizedBoxResponsive(height: 50),
                    ContainerResponsive(
                        height: 600,
                        margin: EdgeInsetsResponsive.symmetric(horizontal: 50),
                        padding: EdgeInsetsResponsive.all(15),
                        child: ContainerResponsive(
                          padding: EdgeInsetsResponsive.symmetric(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 15),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.info.state == 'true'
                                            ? Theme.of(context).primaryColor
                                            : widget.info.state == 'waiting'
                                                ? Colors.yellow[600]
                                                : Colors.redAccent,
                                        width: ScreenUtil().setWidth(.5)),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextResponsive(
                                      'operationNum'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextResponsive(
                                      widget.info.id.toString(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(height: 0),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 15),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.info.state == 'true'
                                            ? Theme.of(context).primaryColor
                                            : widget.info.state == 'waiting'
                                                ? Colors.yellow[600]
                                                : Colors.redAccent,
                                        width: ScreenUtil().setWidth(.5)),
                                    borderRadius: BorderRadius.circular(0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextResponsive(
                                      'status'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextResponsive(
                                      widget.info.state.toString(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(height: 0),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 15),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.info.state == 'true'
                                            ? Theme.of(context).primaryColor
                                            : widget.info.state == 'waiting'
                                                ? Colors.yellow[600]
                                                : Colors.redAccent,
                                        width: ScreenUtil().setWidth(.5)),
                                    borderRadius: BorderRadius.circular(0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextResponsive(
                                      'cause'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextResponsive(
                                      widget.info.paymentCuse.toString(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(height: 0),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 15),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.info.state == 'true'
                                            ? Theme.of(context).primaryColor
                                            : widget.info.state == 'waiting'
                                                ? Colors.yellow[600]
                                                : Colors.redAccent,
                                        width: ScreenUtil().setWidth(.5)),
                                    borderRadius: BorderRadius.circular(0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextResponsive(
                                      'amount'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextResponsive(
                                      widget.info.amount.toString(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(height: 0),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 15),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.info.state == 'true'
                                            ? Theme.of(context).primaryColor
                                            : widget.info.state == 'waiting'
                                                ? Colors.yellow[600]
                                                : Colors.redAccent,
                                        width: ScreenUtil().setWidth(.5)),
                                    borderRadius: BorderRadius.circular(0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextResponsive(
                                      'history'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextResponsive(
                                      widget.info.createdAt.toString(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(height: 0),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 15),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.info.state == 'true'
                                            ? Theme.of(context).primaryColor
                                            : widget.info.state == 'waiting'
                                                ? Colors.yellow[600]
                                                : Colors.redAccent,
                                        width: ScreenUtil().setWidth(.5)),
                                    borderRadius: BorderRadius.circular(0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextResponsive(
                                      'lastUpdate'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextResponsive(
                                      widget.info.updatedAt.toString(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxResponsive(height: 0),
                              ContainerResponsive(
                                padding: EdgeInsetsResponsive.symmetric(
                                    horizontal: 15),
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: widget.info.state == 'true'
                                            ? Theme.of(context).primaryColor
                                            : widget.info.state == 'waiting'
                                                ? Colors.yellow[600]
                                                : Colors.redAccent,
                                        width: ScreenUtil().setWidth(.5)),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    TextResponsive(
                                      'note'.tr(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextResponsive(
                                      "  ${widget.info.note}",
                                      style: TextStyle(
                                        fontSize:
                                            widget.info.note.toString().length >
                                                    30
                                                ? 21
                                                : 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBoxResponsive(height: 70),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: ContainerResponsive(
                            width: 220,
                            height: 70,
                            decoration: BoxDecoration(
                              color: widget.info.state == 'true'
                                  ? Theme.of(context).primaryColor
                                  : widget.info.state == 'waiting'
                                      ? Colors.yellow[600]
                                      : Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: TextResponsive(
                              'Ok'.tr(),
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ))),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
