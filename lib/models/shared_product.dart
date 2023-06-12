import 'package:customers/models/product.dart';

class SharedProduct {
  int id;
  String createdAt;
  String updatedAt;
  String productId;
  int points;
  int customer;
  int owner;
  Product product;

  SharedProduct(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.points,
      this.customer,
      this.owner,
      this.product});

  SharedProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productId = json['product'];
    points = json['points'];
    customer = json['customer'];
    owner = json['owner'];
    product = json['ProductInfo'] != null
        ? Product.fromJson(json['ProductInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product'] = this.productId;
    data['points'] = this.points;
    data['customer'] = this.customer;
    data['owner'] = this.owner;
    data['ProductInfo'] = this.product;
    return data;
  }
}
