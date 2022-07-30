class Tag {
  int id;
  String createdAt;
  String updatedAt;
  String name;
  String description;
  int isStore;
  int isRestaurant;
  dynamic isProduct;
  String nameAR;
  String ardescription;

  Tag(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.description,
      this.isStore,
      this.isRestaurant,
      this.isProduct,
      this.nameAR,
      this.ardescription});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    description = json['description'];
    isStore = json['isStore'];
    isRestaurant = json['isRestaurant'];
    isProduct = json['isProduct'];
    nameAR = json['nameAR'];
    ardescription = json['ardescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isStore'] = this.isStore;
    data['isRestaurant'] = this.isRestaurant;
    data['isProduct'] = this.isProduct;
    data['nameAR'] = this.nameAR;
    data['ardescription'] = this.ardescription;
    return data;
  }
}
