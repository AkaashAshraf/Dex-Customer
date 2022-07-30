import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/widgets/general/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:customers/models/notifications.dart';
import 'package:customers/models/tranz.dart';
import 'package:customers/models/user.dart';
import 'package:easy_localization/easy_localization.dart';

class WithdrawScreen extends StatefulWidget {
  final User user;

  const WithdrawScreen({Key key, this.user}) : super(key: key);
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  List<Notifications> notifications;
  var loading = false;
  var amount = TextEditingController();

  getList() async {
    try {
      setState(() {
        loading = true;
      });
      var response = await Dio().get(
          APIKeys.BASE_URL + 'getTransactions/CustomerId&${widget.user.id}');
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
          msg: 'حاول لاحقاً',
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
          msg: 'حاول لاحقاً',
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
    getList();
  }

  var _values;
  String visa = "VISA";
  String mastercard = 'Mastercard';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ConnectivityWidgetWrapper(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Color(0xff575757),
                                size: 28,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          Text(
                            'withdraw'.tr(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                loading
                    ? Load(200.0)
                    : Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => index == 0
                              ? Container(
                                  padding: tranzList?.isNotEmpty ?? false
                                      ? EdgeInsets.zero
                                      : EdgeInsets.only(top: 100),
                                  height: 100,
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        !loading
                                            ? tranzList?.isNotEmpty ?? false
                                                ? Icons.archive
                                                : Icons.delete
                                            : Icons.archive,
                                        color: Theme.of(context).primaryColor,
                                        size: !loading
                                            ? tranzList?.isNotEmpty ?? false
                                                ? 46
                                                : 70
                                            : 46,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'credit'.tr(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                widget.user != null
                                                    ? widget.user.credit
                                                            ?.toString() ??
                                                        '0'
                                                    : '0',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              Text(
                                                " " + 'S.R'.tr(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : tranzList?.isNotEmpty ?? false
                                  ? tranzRow(size, index - 1)
                                  : Center(
                                      child: Container(
                                          padding: EdgeInsets.only(top: 200),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'لا يوجد معاملات سابقة',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: null,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                          itemCount: tranzList?.isNotEmpty ?? false
                              ? tranzList.length + 1
                              : 2,
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding tranzRow(size, index) {
    dynamic myColor;
    dynamic myState =
        tranzList[index].state != null ? tranzList[index].state : 'false';
    dynamic myNote =
        tranzList[index].note != null ? tranzList[index].note : 'false';
    if (myNote == 'Created' && myState == 'true') {
      myColor = Colors.yellowAccent;
    } else if (myState == 'true' || myNote != 'Created') {
      myColor = Colors.greenAccent;
    } else if (myState == 'waiting') {
      myColor = Colors.yellowAccent;
    } else {
      myColor = Colors.redAccent;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          valuesMap(index, tranzList);
          print(_values);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => WithDarwRecipt(_values)));
        },
        child: Container(
          color: myColor,
          child: Card(
            child: Container(
              width: size.width - 20,
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'processNumber'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        customText(tranzList[index].id),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'status2'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        customText(tranzList[index].state),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'reason'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        customText(tranzList[index].paymentCuse),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'amount3'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        customText(tranzList[index].amount.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'date'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        customText(tranzList[index].createdAt.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'lastModified'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        customText(tranzList[index].updatedAt.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'note2'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        tranzList[index].note != null
                            ? customText(tranzList[index].note.toString())
                            : customText('notFound'.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dynamic customText(txt) {
    try {
      return Text(
        txt != null ? txt.toString() : 'unkown'.tr,
        overflow: TextOverflow.clip,
        maxLines: 5,
        style: TextStyle(
            fontSize: 13, color: Colors.black, fontWeight: FontWeight.w900),
        textAlign: TextAlign.right,
      );
    } catch (e) {
      return Image.asset(
        'images/image404.png',
        width: 70,
        height: 70,
      );
    }
  }

  Map valuesMap(int index, List<TranzList> tranzList) {
    var values = {
      'id': tranzList[index].id,
      'state': tranzList[index].state,
      'cause': tranzList[index].paymentCuse,
      'amount': tranzList[index].amount,
      'date': tranzList[index].createdAt,
      'lastDate': tranzList[index].updatedAt,
      'note': tranzList[index].note,
    };
    _values = values;
    return _values;
  }
}
