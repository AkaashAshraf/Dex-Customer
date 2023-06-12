import 'package:customers/models/orders/cart_products.dart';
import 'customer_info.dart';
import 'shops.dart';

class OrderInfo {
  int id;
  dynamic totalValue;
  String createdAt;
  String updatedAt;
  String state;
  String note;
  String time;
  int payment;
  CustomerInfo customerInfo;
  Shop shopInfo;
  List<CartProdcuts> cartProdcuts;

  OrderInfo(
      {this.id,
      this.totalValue,
      this.time,
      this.createdAt,
      this.updatedAt,
      this.state,
      this.note,
      this.customerInfo,
      this.shopInfo,
      this.cartProdcuts,
      this.payment});

  OrderInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    totalValue = json['total_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    state = json['state'];
    note = json['note'];
    payment = json['paymentMethod'];
    customerInfo = json['CustomerInfo'] != null
        ? CustomerInfo.fromJson(json['CustomerInfo'])
        : null;
    shopInfo =
        json['ShopInfo'] != null ? Shop.fromJson(json['ShopInfo']) : null;
    if (json['cartProdcuts'] != null) {
      cartProdcuts = List<CartProdcuts>();
      json['cartProdcuts'].forEach((v) {
        cartProdcuts.add(CartProdcuts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['time'] = this.time;
    data['total_value'] = this.totalValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['state'] = this.state;
    data['note'] = this.note;
    data['paymentMethod'] = this.payment;
    if (this.customerInfo != null) {
      data['CustomerInfo'] = this.customerInfo.toJson();
    }
//    if (this.shopInfo != null) {
//      data['ShopInfo'] = this.shopInfo.toJson();
//    }
    if (this.cartProdcuts != null) {
      data['cartProdcuts'] = this.cartProdcuts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
