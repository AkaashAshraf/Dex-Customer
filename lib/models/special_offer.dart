class SpecialOffer {
  int id;
  String image;
  int shopId;
  String description;
  String name;
  String createdAt;
  String updatedAt;

  SpecialOffer(
      {this.id,
      this.image,
      this.shopId,
      this.description,
      this.name,
      this.createdAt,
      this.updatedAt});

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(
      id: json['id'],
      image: json['image'],
      shopId: json['shop_id'],
      description: json['description'],
      name: json['title'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['shop_id'] = this.shopId;
    data['description'] = this.description;
    data['title'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
