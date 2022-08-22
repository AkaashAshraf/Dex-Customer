import 'dart:convert';
import 'dart:developer';

import 'package:customers/models/package/package.dart';
import 'package:customers/models/package/package_history.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:customers/repositories/globals.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PackageProvider extends ChangeNotifier {
  List<PackageData> _packages;
  List<PackageData> get packages => _packages;

  String _assignPackageId;
  String get assignPackageId => _assignPackageId;

  int _packageIndex;
  int get packageIndex => _packageIndex;

  setPackageIndex(int value) {
    _packageIndex = value;
    notifyListeners();
  }

  PackageState _state;
  PackageState get state => _state;

  AssignPackageState _assignPackageState;
  AssignPackageState get assignPackageState => _assignPackageState;

  bool _isUpdateStatusSuccess;
  bool get isUpdateStatusSuccess => _isUpdateStatusSuccess;

  Future fetchPackages(String userId) async {
    try {
      _state = PackageState.loading;
      var response = await Dio()
          .post(APIKeys.BASE_URL + 'get-packages', data: {'id': userId});

      final jsonData = json.decode(response.data);
      var data = Map<String, dynamic>.from(jsonData);
      // var categories = data as List;

      // final packageInfo =
      //     categories.map<Package>((json) => Package.fromJson(json)).toList();
      final packagesInfo = Package.fromJson(data);
      log("Package data ${packagesInfo.data[0].packageTitle.toString()}");
      _packages = packagesInfo.data;
      _state = PackageState.loaded;
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          _state = PackageState.error;
          log('package API', error: error);
          // throw error;
          break;
        default:
          _state = PackageState.error;
          log('package API', error: error);
        // throw error;
      }
    } catch (error) {
      _state = PackageState.error;
      log('package API', error: error);
      // throw error;
    }
    notifyListeners();
  }

  Future<bool> assignPackage(int packageId) async {
    try {
      _assignPackageState = AssignPackageState.loading;
      notifyListeners();
      var response = await Dio().post(
          APIKeys.BASE_URL + 'assign-package-to-customer',
          data: {'userid': userId, 'package_id': packageId.toString()});

      final jsonData = json.decode(response.data);
      var data = Map<String, dynamic>.from(jsonData);

      if (data['status'] == 1) {
        final packagesHistory = PackageHistory.fromJson(data);
        _assignPackageId = packagesHistory.data;
        _assignPackageState = AssignPackageState.loaded;
        notifyListeners();
        return true;
      } else {
        _assignPackageState = AssignPackageState.error;
        notifyListeners();
        return false;
      }
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.cancel:
          _assignPackageState = AssignPackageState.error;
          notifyListeners();
          return false;

          break;
        default:
          _assignPackageState = AssignPackageState.error;
          notifyListeners();
          return false;
      }
    } catch (error) {
      _assignPackageState = AssignPackageState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> setPaymentStatus(String paymentStatus) async {
    try {
      _state = PackageState.loading;
      final response =
          await Dio().post(APIKeys.BASE_URL + 'update-package-payment-status',
              data: FormData.fromMap({
                'userid': userId,
                'payment_status': paymentStatus,
              }));
      if (response.data['State'] == 1) {
        _state = PackageState.loaded;
        _isUpdateStatusSuccess = true;
        notifyListeners();
      } else {
        _state = PackageState.loaded;
        _isUpdateStatusSuccess = false;
      }
      notifyListeners();
    } on DioError catch (error) {
      _state = PackageState.loaded;
      _isUpdateStatusSuccess = false;
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
      _state = PackageState.loaded;
      _isUpdateStatusSuccess = false;
      notifyListeners();
      throw error;
    }
  }
}

enum PackageState { loading, loaded, error }
enum AssignPackageState { loading, loaded, error }
