class Product {
  int id;
  String name;
  String nameAr;
  String categories;
  String image;
  dynamic price;
  String shop;
  String shopName;
  String nearByShopName;
  String createdAt;
  String updatedAt;
  String description;
  String descriptionAr;
  dynamic stock;
  String unit;
  String unitAr;
  dynamic soldCount;
  dynamic rate;
  dynamic ratersCount;
  dynamic weight;
  dynamic tags;
  dynamic tagsAr;
  List<Product> childProducts;
  int parent;
  String isRequired;
  String section;
  String sectionAr;
  bool isInCart = false;
  bool fav = false;

  Product(
      {this.id,
      this.name,
      this.nameAr,
      this.categories,
      this.image,
      this.price,
      this.shopName,
      this.shop,
      this.nearByShopName,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.descriptionAr,
      this.stock,
      this.unit,
      this.unitAr,
      this.soldCount,
      this.rate,
      this.weight,
      this.ratersCount,
      this.tags,
      this.tagsAr,
      this.fav,
      this.childProducts,
      this.parent,
      this.section,
      this.sectionAr,
      this.isRequired});

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Product> children = [];
    if (json['childProducts'] != null) {
      json['childProducts']
          .forEach((product) => children.add(Product.fromJson(product)));
    }
    return Product(
        id: json['id'],
        name: json['name'],
        nameAr: json['name_ar'],
        categories: json['categories'],
        image: json['image'],
        price: json['price'],
        shop: json['shop'],
        nearByShopName: json['nearByShopName'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        description: json['description'],
        descriptionAr: json['description_ar'],
        stock: json['stock'],
        unit: json['shop'] == null
            ? json['unit']
            : json['ProdcutsUnit'].length == 0 
                ? "غير محدد"
                : json['ProdcutsUnit'][0]["name"],
        unitAr: json['shop'] == null
            ? json['unit']
            : json['ProdcutsUnit'].length == 0 
                ? "غير محدد"
                : json['ProdcutsUnit'][0]["name_ar"],
        soldCount: json['sold_count'],
        rate: json['rate'],
        shopName: json['ShopName'],
        weight: json['weight'],
        ratersCount: json['raters_count'],
        tags: json['tags'],
        tagsAr: json['tags_ar'],
        parent: json["parent"] ?? 0,
        isRequired: json['isRequired'].toString(),
        section: json['section'],
        sectionAr: json['section_ar'],
        childProducts: children);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ShopName'] = this.shopName;
    data['categories'] = this.categories;
    data['image'] = this.image;
    data['price'] = this.price;
    data['shop'] = this.shop;
    data['nearByShopName'] = this.nearByShopName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['stock'] = this.stock;
    data['unit'] = this.unit;
    data['sold_count'] = this.soldCount;
    data['rate'] = this.rate;
    data['raters_count'] = this.ratersCount;
    data['weight'] = this.weight;
    data['tags'] = this.tags;
    data['childProducts'] = this.childProducts;
    data['parent'] = this.parent;
    return data;
  }
}
