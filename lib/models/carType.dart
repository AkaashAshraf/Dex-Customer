class CarType {
  int id;
  double price;
  String createdAt;
  String updatedAt;
  String name;
  String nameAr;
  String slang;
  String description;

  CarType(
      {this.id,
      this.price,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.nameAr,
      this.slang,
      this.description});

  CarType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    nameAr = json['name_ar'];
    slang = json['slang'];
    description = json['description'];
    price = json['price'] * 1.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['name_ar'] = this.nameAr;
    data['slang'] = this.slang;
    data['description'] = this.description;
    return data;
  }
}
