import 'package:customers/models/shops.dart';
import 'package:customers/repositories/api_keys.dart';
import 'package:dio/dio.dart';

Future<Shop> getShopDetails({String shopId}) async {
  try {
    var response = await Dio().post(APIKeys.BASE_URL + 'getShopInfoByShopId',
        data: FormData.fromMap({
          'shopId': shopId,
        }));
    var data = response.data['Data'];
    return Shop.fromJson(data);
  } catch (error) {
    return null;
  }
}
