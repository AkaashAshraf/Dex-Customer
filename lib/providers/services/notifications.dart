import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class NotiProvider extends ChangeNotifier {
  Future<void> sendNoti(
      {String id,
      String notiTit,
      String dataTit,
      String notiBody,
      String dataBody}) async {
    try {
      print(APIKeys.Noti_URL +
          'userId&$id/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
      var response = await Dio().get(APIKeys.Noti_URL +
          'userId&$id/title&$notiTit/body&${notiBody}datatitle&$dataTit/databody&$dataBody');
      
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
