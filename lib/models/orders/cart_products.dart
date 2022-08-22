class CartProdcuts {
  dynamic id;
  dynamic ordersId;
  dynamic productsId;
  dynamic productName;
  dynamic productNameAr;
  dynamic description;
  dynamic descriptionAr;
  dynamic price;
  dynamic quantity;
  dynamic total;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  dynamic prodcutsUnit;
  dynamic shopname;
  dynamic shopnameAr;
  dynamic parent;
  String section;
  String sectionAr;

  CartProdcuts(
      {this.id,
      this.ordersId,
      this.prodcutsUnit,
      this.productsId,
      this.productName,
      this.productNameAr,
      this.price,
      this.quantity,
      this.total,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.shopname,
      this.shopnameAr,
      this.parent,
      this.section,
      this.sectionAr,
      this.description,
      this.descriptionAr});

  CartProdcuts.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    ordersId = json['Orders_id'];
    prodcutsUnit = json['ProdcutsUnit'];
    productsId = json['Products_id'];
    productName =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['name'] : '';
    productNameAr =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['name_ar'] : '';
    price = json['price'];
    quantity = json['quantity'];
    total = json['total'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    shopname =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['ShopName'] : '';
    shopnameAr = json['ProdcutInfo'] != null
        ? json['ProdcutInfo']['ShopName_ar'].toString()
        : '';
    parent = json['ProdcutInfo'] != null ? json['ProdcutInfo']['parent'] : 0;
    section = json['ProdcutInfo'] != null ? json['ProdcutInfo']['section'] : '';
    sectionAr =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['section_ar'] : '';
    description =
        json['ProdcutInfo'] != null ? json['ProdcutInfo']['description'] : '';
    descriptionAr = json['ProdcutInfo'] != null
        ? json['ProdcutInfo']['description_ar']
        : '';
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['ProdcutsUnit'] = this.prodcutsUnit;
    data['Orders_id'] = this.ordersId;
    data['Products_id'] = this.productsId;
    data['product_name'] = this.productName;
    data['product_name_ar'] = this.productNameAr;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['Shopname'] = this.shopname;
    data['parent'] = this.parent;
    data['section'] = this.section;
    data['section_at'] = this.sectionAr;
    return data;
  }
}
