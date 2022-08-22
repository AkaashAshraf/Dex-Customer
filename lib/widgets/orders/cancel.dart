import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/models/reason.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class Cancel extends StatefulWidget {
  final dynamic order;
  Cancel({this.order});
  @override
  _CancelState createState() => _CancelState(order);
}

ProgressDialog pr;

class _CancelState extends State<Cancel> {
  dynamic order;
  _CancelState(this.order);
// vars //
  bool loading;
  List<PopupMenuEntry<int>> popMenuList;
  List reasons;
  var selectedItem;
// functions //
  Future<void> sendNoti(dataBody, dataTit, notiBody, notiTit) async {
    try {
      var response = await dioClient.get(
          '${APIKeys.Noti_URL}userId&${order.driverInfo.id.toString()}/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
      print(response.data);
    } catch (e) {}
  }

  Future cancelOrder(reason) async {
    try {
      var id = order.orderInfo.id.toString();
      var _reason = reason.toString();
      if (_reason == "null") {
        Fluttertoast.showToast(
            msg: "choseCancelReason".tr(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0);
      } else {
        pr.show();
        var response = await Dio().get(APIKeys.BASE_URL +
            'CancelOrder/orderId&' +
            id +
            'cancellationReasonId&' +
            _reason);
        var data = response.data;
        print('RESPONE IS $data');
        pr.hide();

        if (data['State'] == 'success') {
          Fluttertoast.showToast(
              msg: "successed".tr(),
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.white,
              textColor: Colors.green,
              fontSize: 15.0);
          Navigator.of(context).popUntil(ModalRoute.withName('home'));
          Navigator.pushReplacementNamed(context, 'home');
        }
        if (data['State'] == 'success' && data['Data']['DriverInfo'] != null) {
          var notiTit = ' تحديث من ${order.orderInfo.customerInfo.firstName}';
          var notiBody = "تم الغاء الطلب";
          var dataTit = 'changeState';
          var dataBody = order.id;
          sendNoti(dataBody, dataTit, notiBody, notiTit);
        }
      }
    } on DioError catch (error) {
      pr.hide();
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
      pr.hide();
      throw error;
    }
  }

  Future getReasons() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await Dio().get(APIKeys.BASE_URL + 'CustomerCancellationReasons');
      var data = response.data;
      reasons = data.map<Reason>((json) => Reason.fromJson(json)).toList();
      print(reasons);

      popMenuList = [];
      for (int i = 0; i < reasons.length; i++) {
        popMenuList.add(PopupMenuItem(
          value: i,
          child: PopupMenuItem(
            height: 50,
            value: i,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green[500],
                  borderRadius: BorderRadius.circular(1)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  reasons[i].name,
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ),
        ));
      }
      setState(() {
        loading = false;
      });
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

  @override
  void initState() {
    print(order);
    setState(() {
      loading = false;
    });
    getReasons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(context,
        height: 1560, width: 720, allowFontScaling: true);
    pr = ProgressDialog(context, isDismissible: false);
    pr.style(
        message: '...جاري الارسال',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    var popMenu = ContainerResponsive(
      height: 70,
      width: 400,
      child: PopupMenuButton(
          onSelected: (int value) {
            setState(() {
              selectedItem = value;
            });
          },
          itemBuilder: (context) => popMenuList,
          child: ContainerResponsive(
              padding: EdgeInsetsResponsive.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor, width: 0.5),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.arrow_drop_down),
                  SizedBoxResponsive(width: 30),
                  selectedItem != null
                      ? TextResponsive(reasons[selectedItem].name,
                          style: TextStyle(
                            fontSize: 25,
                          ))
                      : TextResponsive('قم بإختيار سبب الإلغاء',
                          style: TextStyle(
                            fontSize: 25,
                          )),
                ],
              ))),
    );
    return ResponsiveWidgets.builder(
      height: 1560,
      width: 720,
      allowFontScaling: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: TextResponsive('إلغاء الطلب',
              style: TextStyle(
                fontSize: 48,
                color: Colors.black,
              )),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: ConnectivityWidgetWrapper(
            message: 'فشل الإتصال بالإنترنت الرجاء التأكد من اتصالك بالإنترنت',
            child: ContainerResponsive(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/background.png'),
                    fit: BoxFit.fitWidth),
              ),
              child: loading
                  ? Center(child: Load(100.0))
                  : ContainerResponsive(
                      padding: EdgeInsetsResponsive.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ContainerResponsive(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ContainerResponsive(
                                  margin: EdgeInsetsResponsive.symmetric(
                                      horizontal: 35, vertical: 5),
                                  child: TextResponsive(
                                    'سبب الإلغاء',
                                    style: TextStyle(
                                      fontSize: 35,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                SizedBoxResponsive(height: 5),
                                ContainerResponsive(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsetsResponsive.symmetric(
                                      horizontal: 30),
                                  child: popMenu,
                                ),
                              ],
                            ),
                          ),
                          ContainerResponsive(
                              child: ConnectivityWidgetWrapper(
                            stacked: false,
                            offlineWidget: ContainerResponsive(
                                height: 70,
                                margin: EdgeInsetsResponsive.symmetric(
                                    horizontal: 40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[500],
                                ),
                                child: Center(
                                  child: TextResponsive(
                                    'في إنتظار الإنترنت',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                            child: GestureDetector(
                              onTap: () {
                                cancelOrder(selectedItem);
                              },
                              child: ContainerResponsive(
                                  height: 70,
                                  margin: EdgeInsetsResponsive.symmetric(
                                      horizontal: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                    child: TextResponsive(
                                      'تأكيد',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ),
                          )),
                        ],
                      ),
                    ),
            )),
      ),
    );
  }
}
