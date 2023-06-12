import 'driver_info.dart';
import 'order_info.dart';

class DeliveryHistory {
  int id;
  String address;
  dynamic state;
  dynamic deliveryPrice;
  dynamic stageStartedAt;
  dynamic startLatitude;
  dynamic startLongtude;
  dynamic endLatitude;
  dynamic endLongitude;
  dynamic nearByShopName;
  dynamic nearByShopImg;
  dynamic nearbyorder;
  dynamic shopLatitude;
  dynamic shopLongitude;
  dynamic logsticTripId;
  dynamic logsticTripImg;
  dynamic logsticTripFromCity;
  dynamic logsticTripToCity;
  dynamic logsticTripCar;
  dynamic logsticTripCarAr;
  dynamic logsticTripDate;

  String createdAt;
  String updatedAt;
  DriverInfo driverInfo;
  OrderInfo orderInfo;

  DeliveryHistory(
      {this.id,
      this.nearbyorder,
      this.nearByShopName,
      this.shopLatitude,
      this.shopLongitude,
      this.address,
      this.state,
      this.deliveryPrice,
      this.stageStartedAt,
      this.startLatitude,
      this.startLongtude,
      this.endLatitude,
      this.endLongitude,
      this.createdAt,
      this.updatedAt,
      this.logsticTripId,
      this.logsticTripImg,
      this.logsticTripFromCity,
      this.logsticTripToCity,
      this.logsticTripCar,
      this.logsticTripCarAr,
      this.logsticTripDate,
      this.driverInfo,
      this.orderInfo});

  DeliveryHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    nearByShopImg = json['nearByShopImg'];
    nearByShopName = json['nearByShopName'];
    shopLongitude = json['shopLongitude'];
    shopLatitude = json['shopLatitude'];
    nearbyorder = json['nearbyorder'];
    state = json['state'];
    deliveryPrice = json['delivery_price'];
    stageStartedAt = json['stage_started_at'];
    startLatitude = json['start_latitude'];
    startLongtude = json['start_longtude'];
    endLatitude = json['end_latitude'];
    endLongitude = json['end_longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['logistticTripInfo'] != null) {
      logsticTripId = json['logistticTripInfo']['id'];
      logsticTripFromCity = json['logistticTripInfo']['fromCity'];
      logsticTripToCity = json['logistticTripInfo']['toCity'];
      logsticTripCar = json['LogistictripCar']['name'];
      logsticTripCarAr = json['LogistictripCar']['name_ar'];
      logsticTripDate = json['Logistictripdate']['date'];
    }
    driverInfo = json['DriverInfo'] != null
        ? DriverInfo.fromJson(json['DriverInfo'])
        : null;
    orderInfo = json['OrderInfo'] != null
        ? OrderInfo.fromJson(json['OrderInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nearByShopImg'] = this.nearByShopImg;
    data['nearByShopName'] = this.nearByShopName;
    data['shopLongitude'] = this.shopLongitude;
    data['shopLatitude'] = this.shopLatitude;
    data['nearbyorder'] = this.nearbyorder;
    data['address'] = this.address;
    data['state'] = this.state;
    data['delivery_price'] = this.deliveryPrice;
    data['stage_started_at'] = this.stageStartedAt;
    data['start_latitude'] = this.startLatitude;
    data['start_longtude'] = this.startLongtude;
    data['end_latitude'] = this.endLatitude;
    data['end_longitude'] = this.endLongitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.driverInfo != null) {
      data['DriverInfo'] = this.driverInfo.toJson();
    }
    if (this.orderInfo != null) {
      data['OrderInfo'] = this.orderInfo.toJson();
    }
    return data;
  }
}
