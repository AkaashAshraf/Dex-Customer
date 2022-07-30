class City {
  dynamic id;
  String name;
  String nameAr;
  String createdAt;
  String updatedAt;
  dynamic longitude;
  dynamic latitude;

  City(
      {this.id,
      this.name,
      this.nameAr,
      this.createdAt,
      this.updatedAt,
      this.longitude,
      this.latitude});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      longitude: double.parse(json['longitude'].toString()),
      latitude: double.parse(json['latitude'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ar'] = this.nameAr;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}
