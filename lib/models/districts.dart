List<Districts> districts;

class Districts{
  int id;
  String name;
  String createdAt;
  String updatedAt;
  dynamic longitude;
  dynamic latitude;

  Districts(
      {this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.longitude,
        this.latitude});

  factory Districts.fromJson(Map<String, dynamic> json) {
    return   Districts(
        id : json['id'],
        name : json['name'],
        createdAt : json['created_at'],
        updatedAt : json['updated_at'],
        longitude : json['longitude'],
        latitude : json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}