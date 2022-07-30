import 'dart:developer';

import 'package:customers/models/story/shop_story.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopStoryProvider extends ChangeNotifier {
  List<Story> _shopStories = [];
  List<Story> get shopStories => _shopStories;

  List<Story> _allShopStories = [];
  List<Story> get allShopStories => _allShopStories;

  Future getShopStories() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var userId = prefs.getString('userId');
      notifyListeners();
      var response =
          await Dio().get(APIKeys.BASE_URL + 'getUserStories&userId=$userId');
      log('storyUrl_________${APIKeys.BASE_URL + 'getUserStories&userId=$userId'}');
      var data = response.data['data'];
      var offers = data as List;
      _shopStories = [];
      _allShopStories =
          offers.map<Story>((json) => Story.fromJson(json)).toList();
      _allShopStories.forEach((s) {
        if (s.isOn == 1) {
          _shopStories.add(s);
        }
      });
      print('done');
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
    } 
    catch (error) {
      log('shop_story_error: '+error.toString());
      throw error;
    }
    notifyListeners();
  }
}
