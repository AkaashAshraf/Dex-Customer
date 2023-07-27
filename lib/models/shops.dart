import 'dart:developer';

import 'package:customers/models/user.dart';

class Shop {
  dynamic id;
  String name;
  String nameAr;
  String image;
  String description;
  String descriptionAr;
  String Phone;
  String email;
  String website;
  String address;
  dynamic is_On;
  dynamic rate;
  dynamic raters_count;
  dynamic sold_count;
  dynamic longitude;
  dynamic user_distances;
  dynamic Latitude;
  ShopCity shopCity;
  dynamic Dealer;
  dynamic ProductCount;
  List sections;
  List<ShopsComments> shopsComments;
  String doorCloseAt;
  String doorStartAt;
  String tag;
  double taxOne;
  String taxOneName;
  String taxOneNameAr;
  double taxTwo;
  String taxTwoName;
  String taxTwoNameAr;

  Shop(
      {this.name,
      this.nameAr,
      this.image,
      this.user_distances,
      this.description,
      this.descriptionAr,
      this.Phone,
      this.email,
      this.website,
      this.address,
      this.is_On,
      this.rate,
      this.raters_count,
      this.sold_count,
      this.longitude,
      this.Latitude,
      this.shopCity,
      this.Dealer,
      this.id,
      this.ProductCount,
      this.shopsComments,
      this.doorCloseAt,
      this.doorStartAt,
      this.sections,
      this.tag,
      this.taxOne,
      this.taxOneName,
      this.taxOneNameAr,
      this.taxTwo,
      this.taxTwoName,
      this.taxTwoNameAr});
  factory Shop.fromJson(Map<String, dynamic> json) {
    ShopCity myCity;
    dynamic myDist;
    var comments;
    if (json == null) {
      return null;
    }
    if (json['ShopCity'] != null) {
      myCity = ShopCity.fromJson(json['ShopCity']);
    } else {
      myCity = null;
    }
    myCity = null;
    if (json['distance'] == null) {
      myDist = 0;
    } else {
      myDist = json['distance'];
    }

    if (json['ShopsComments'] != null) {
      comments = List<ShopsComments>();
      json['ShopsComments'].forEach((v) {
        comments.add(ShopsComments.fromJson(v));
      });
    }
    return Shop(
      user_distances: myDist,
      ProductCount: json['ProductCount'],
      name: json['name'],
      nameAr: json['name_ar'],
      image: json['image'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      Phone: json['Phone'],
      email: json['email'],
      website: json['website'],
      address: json['address'],
      is_On: json['is_On'],
      rate: json['rate'],
      id: json['id'],
      raters_count: json['raters_count'],
      sold_count: json['sold_count'],
      longitude: json['longitude'],
      Latitude: json['Latitude'],
      shopCity: myCity,
      Dealer: json['Dealer'],
      shopsComments: comments,
      doorStartAt: json['doorStartAt'],
      doorCloseAt: json['doorCloseAt'],
      tag: json['tags'],
      sections: json['sections'],
      taxOne: json['TaxOne_value'] != null
          ? double.parse(json['TaxOne_value']) * 1.0
          : 0.0,
      taxOneName: json['TaxOne_name'].toString(),
      taxOneNameAr: json['TaxOne_name_ar'].toString(),
      taxTwo: json['TaxTwo_value'] != null
          ? double.parse(json['TaxTwo_value']) * 1.0
          : 0.0,
      taxTwoName: json['TaxTwo_name'].toString(),
      taxTwoNameAr: json['TaxTwo_name_ar'].toString(),
    );
  }
}

class ShopsComments {
  int id;
  int productId;
  int customerId;
  String comment;
  String createdAt;
  String updatedAt;
  int shopId;
  String username;
  String userimage;
  User userInfo;
  ShopsComments({
    this.id,
    this.productId,
    this.customerId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.shopId,
    this.username,
    this.userInfo,
    this.userimage,
  });

  factory ShopsComments.fromJson(Map<String, dynamic> json) {
    return ShopsComments(
      id: json['id'],
      userInfo: json['UserInfo'] != 0 ? User.fromJson(json['UserInfo']) : null,
      productId: json['product_Id'],
      customerId: json['Customer_id'],
      comment: json['comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      shopId: json['shop_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['product_Id'] = this.productId;
    data['Customer_id'] = this.customerId;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['shop_id'] = this.shopId;
    data['UserInfo'] = this.username;
    data['UserInfo'] = this.username;
    return data;
  }
}

class ShopCity {
  final int id;
  final String name;

  ShopCity({this.id, this.name});

  factory ShopCity.fromJson(Map<String, dynamic> parsedJson) {
    return ShopCity(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}
