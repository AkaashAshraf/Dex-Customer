import 'dart:developer';

import 'package:customers/models/special_offer.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecialOffersPorvider extends ChangeNotifier {
  List<SpecialOffer> _offers = [];
  List<SpecialOffer> get offers => _offers;

  List<String> _offerImages = [];
  List<String> get offerImages => _offerImages;

  Future getSpecialOffers() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      print('SPECIAL OFFER START');
      log('SPECIAL OFFER START' +
          APIKeys.BASE_URL +
          'getSpecialOffersUserId&${pref.getString('userId')}');
      var response = await Dio().get(APIKeys.BASE_URL +
          'getSpecialOffersUserId&${pref.getString('userId')}');

      var data = response.data;
      var offers = data as List;
      _offers = offers
          .map<SpecialOffer>((json) => SpecialOffer.fromJson(json))
          .toList();

      _offerImages = List<String>();

      for (int i = 0; i < _offers.length; i++) {
        _offerImages.add(_offers[i].image);
      }
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
    notifyListeners();
  }
}
