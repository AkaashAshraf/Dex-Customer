import 'package:customers/models/product.dart';

import 'shops.dart';

class FavoriteModel {
  int id;
  String createdAt;
  String updatedAt;
  int userID;
  int proudctID;
  List<Product> productinfo;

  FavoriteModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.userID,
      this.proudctID,
      this.productinfo});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userID = json['userID'];
    proudctID = json['proudctID'];
    if (json['Productinfo'] != null) {
      productinfo = new List<Product>();
      json['Productinfo'].forEach((v) {
        productinfo.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['userID'] = this.userID;
    data['proudctID'] = this.proudctID;
    if (this.productinfo != null) {
      data['Productinfo'] = this.productinfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productinfo {
  int id;
  String name;
  String categories;
  String image;
  int price;
  String shop;
  String createdAt;
  String updatedAt;
  String description;
  Null stock;
  String unit;
  int soldCount;
  int rate;
  int ratersCount;
  String weight;
  int views;
  String tags;
  String isSpecialOffer;
  String isFreeDelivery;
  List<ShopsComments> prodcutsComments;
  List<ProdcutsUnit> prodcutsUnit;
  String shopName;
  dynamic shopId;
  String shopCityId;

  Productinfo(
      {this.id,
      this.name,
      this.categories,
      this.image,
      this.price,
      this.shop,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.stock,
      this.unit,
      this.soldCount,
      this.rate,
      this.ratersCount,
      this.weight,
      this.views,
      this.tags,
      this.isSpecialOffer,
      this.isFreeDelivery,
      this.prodcutsComments,
      this.prodcutsUnit,
      this.shopName,
      this.shopId,
      this.shopCityId});

  Productinfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categories = json['categories'];
    image = json['image'];
    price = json['price'];
    shop = json['shop'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    stock = json['stock'];
    unit = json['unit'];
    soldCount = json['sold_count'];
    rate = json['rate'];
    ratersCount = json['raters_count'];
    weight = json['weight'];
    views = json['views'];
    tags = json['tags'];
    isSpecialOffer = json['isSpecialOffer'];
    isFreeDelivery = json['isFreeDelivery'];
    if (json['ProdcutsComments'] != null) {
      prodcutsComments = new List<ShopsComments>();
      json['ProdcutsComments'].forEach((v) {
        prodcutsComments.add(new ShopsComments.fromJson(v));
      });
    }
    if (json['ProdcutsUnit'] != null) {
      prodcutsUnit = new List<ProdcutsUnit>();
      json['ProdcutsUnit'].forEach((v) {
        prodcutsUnit.add(new ProdcutsUnit.fromJson(v));
      });
    }
    shopName = json['ShopName'];
    shopId = json['ShopId'];
    shopCityId = json['ShopCityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['categories'] = this.categories;
    data['image'] = this.image;
    data['price'] = this.price;
    data['shop'] = this.shop;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['stock'] = this.stock;
    data['unit'] = this.unit;
    data['sold_count'] = this.soldCount;
    data['rate'] = this.rate;
    data['raters_count'] = this.ratersCount;
    data['weight'] = this.weight;
    data['views'] = this.views;
    data['tags'] = this.tags;
    data['isSpecialOffer'] = this.isSpecialOffer;
    data['isFreeDelivery'] = this.isFreeDelivery;
    if (this.prodcutsComments != null) {
      data['ProdcutsComments'] =
          this.prodcutsComments.map((v) => v.toJson()).toList();
    }
    if (this.prodcutsUnit != null) {
      data['ProdcutsUnit'] = this.prodcutsUnit.map((v) => v.toJson()).toList();
    }
    data['ShopName'] = this.shopName;
    data['ShopId'] = this.shopId;
    data['ShopCityId'] = this.shopCityId;
    return data;
  }
}

class ProdcutsUnit {
  int id;
  String createdAt;
  String updatedAt;
  String name;
  String slag;
  Null image;
  int order;

  ProdcutsUnit(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.slag,
      this.image,
      this.order});

  ProdcutsUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    slag = json['slag'];
    image = json['image'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['slag'] = this.slag;
    data['image'] = this.image;
    data['order'] = this.order;
    return data;
  }
}
