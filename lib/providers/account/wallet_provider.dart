import 'dart:developer';

import 'package:charts_flutter/flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:customers/models/shared_product.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fluttertoast/fluttertoast.dart';

class Spot {
  final DateTime time;
  final int points;

  Spot(this.time, this.points);
}

class WalletProvider extends ChangeNotifier {
  TextEditingController _amount = TextEditingController();
  TextEditingController get amount => _amount;

  TextEditingController _amount2 = TextEditingController();
  TextEditingController get amount2 => _amount2;

  List<SharedProduct> _sharedProducts = [];
  List<SharedProduct> get sharedProducts => _sharedProducts;

  int _load = 0;
  int get load => _load;

  List<FlSpot> _spots = [];
  List<FlSpot> get spots => _spots;

  double _maxX = 0.0;
  double get maxX => _maxX;

  List<Spot> _spot = [];
  List<Spot> get spot => _spot;

  double _maxY = 0.0;
  double get maxY => _maxY;

  double _precentage = 0;
  double get precentage => _precentage;

  bool _loadingCredit = false;
  bool get loadingCredit => _loadingCredit;

  bool _loadingCash = false;
  bool get loadingCash => _loadingCash;

  void calculate(double min, double max, var points) {
    var length = max - min;
    _precentage = (points / length) * 100;
    _load++;
    notifyListeners();
  }

  void emptyAmount(int number) {
    if (number == 1) {
      _amount.text = '';
    } else {
      _amount2.text = '';
    }
    notifyListeners();
  }

  void startLoad() {
    _load = 0;
    notifyListeners();
  }

  List<charts.Series<Spot, DateTime>> createSampleData(List<Spot> data) {
    return [
      charts.Series<Spot, DateTime>(
        id: 'time',
        seriesColor: charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (Spot dot, _) => dot.time,
        measureFn: (Spot dot, _) => dot.points,
        data: data,
      )
    ];
  }

  List<charts.TickSpec<DateTime>> spec(List<Spot> spots) {
    List<charts.TickSpec<DateTime>> list = [];
    if (spots.isNotEmpty) {
      spots.forEach((spot) => list.add(TickSpec<DateTime>(
          DateTime(spot.time.year, spot.time.month, spot.time.day))));
      var day = spots[spots.length - 1].time.day == 30 ||
              spots[spots.length - 1].time.day == 31
          ? 1
          : spots[spots.length - 1].time.day + 1;
      var month = (spots[spots.length - 1].time.day == 30 ||
                  spots[spots.length - 1].time.day == 31) &&
              spots[spots.length - 1].time.month != 12
          ? spots[spots.length - 1].time.month + 1
          : (spots[spots.length - 1].time.day == 30 ||
                      spots[spots.length - 1].time.day == 31) &&
                  spots[spots.length - 1].time.month == 12
              ? 1
              : spots[spots.length - 1].time.month;
      var year = (spots[spots.length - 1].time.day == 30 ||
                  spots[spots.length - 1].time.day == 31) &&
              spots[spots.length - 1].time.month == 12
          ? spots[spots.length - 1].time.year + 1
          : spots[spots.length - 1].time.year;
      list.insert(list.length, TickSpec<DateTime>(DateTime(year, month, day)));
    }
    return list;
  }

  Future pointToCredit({String id, String amount}) async {
    try {
      _loadingCredit = true;
      notifyListeners();
      var response = await Dio().get(
          APIKeys.BASE_URL + 'withdrawDexPointscustomer=$id&amount=$amount');
      var data = response.data;
      if (data['state'] == true) {
        Fluttertoast.showToast(
          msg: 'doneSuccefully'.tr(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: data['message'].tr(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      _loadingCredit = false;
      notifyListeners();
    } on DioError catch (error) {
      _loadingCredit = false;
      notifyListeners();
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
      _loadingCredit = false;
      notifyListeners();
      log('point_to_credit_error ' + error);
      throw error;
    }
  }

  Future creditToCash({String id, String amount}) async {
    try {
      _loadingCash = true;
      notifyListeners();
      var response = await Dio()
          .get(APIKeys.BASE_URL + 'withdrawCredit&Customer=$id&amount=$amount');
      log('withdrawCreditURL:  ' +
          APIKeys.BASE_URL +
          'withdrawCredit&Customer=$id&amount=$amount');
      var data = response.data;
      if (data['state'] == true) {
        Fluttertoast.showToast(
          msg: 'doneSuccefullyCredit'.tr(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: data['message'].tr(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      _loadingCash = false;
      notifyListeners();
    } on DioError catch (error) {
      _loadingCash = false;
      notifyListeners();
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
      _loadingCash = false;
      notifyListeners();
      throw error;
    }
  }

  Future getSharedProducts({String id}) async {
    log('Transaction history URL: ' +
        APIKeys.BASE_URL +
        'getDexPoints/owner=$id');
    try {
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getDexPoints/owner=$id');
      log('api ${APIKeys.BASE_URL + 'getDexPoints/owner=$id'}');
      var data = response.data['data'];
      _sharedProducts = data
          .map<SharedProduct>((json) => SharedProduct.fromJson(json))
          .toList();
      _load++;
      notifyListeners();
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

  Future getPoints({String id}) async {
    try {
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getDexPointsChart/owner=$id');
      var data = response.data;
      _spot = [];
      data.forEach((dot) => _spot.add(Spot(DateTime.parse(dot['date']),
          int.parse(double.parse(dot['point']).round().toString()))));
      _load++;
      notifyListeners();
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
}
