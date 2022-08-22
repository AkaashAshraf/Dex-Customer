class Reason {
  int id;
  String createdAt;
  String updatedAt;
  String name;
  String description;

  Reason(
      {this.id, this.createdAt, this.updatedAt, this.name, this.description});

  Reason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
