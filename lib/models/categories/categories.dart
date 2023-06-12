class Category {
  int id;
  int parentId;
  int order;
  String name;
  String nameAr;
  String slug;
  String createdAt;
  String updatedAt;
  String description;
  String image;

  Category(
      {this.id,
      this.parentId,
      this.order,
      this.name,
      this.nameAr,
      this.slug,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
      order: json['order'],
      name: json['name'],
      nameAr: json['name_ar'],
      slug: json['slug'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['order'] = this.order;
    data['name'] = this.name;
    data['name_ar'] = this.nameAr;
    data['slug'] = this.slug;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}
