class NearShop {
  dynamic formattedAddress;
  Geometry geometry;
  dynamic icon;
  dynamic id;
  dynamic name;
  dynamic placeId;
  PlusCode plusCode;
  dynamic rating;
  dynamic reference;
  List<dynamic> types;
  dynamic userRatingsTotal;

  NearShop(
      {this.formattedAddress,
      this.geometry,
      this.icon,
      this.id,
      this.name,
      this.placeId,
      this.plusCode,
      this.rating,
      this.reference,
      this.types,
      this.userRatingsTotal});

  NearShop.fromJson(Map<String, dynamic> json) {
    json['formatted_address'] != null
        ? formattedAddress = json['formatted_address']
        : formattedAddress = json['vicinity'];

    geometry = json['geometry'] != null
        ?  Geometry.fromJson(json['geometry'])
        : null;
    icon = json['icon'];
    id = json['id'];
    name = json['name'];
    placeId = json['place_id'];
    plusCode = json['plus_code'] != null
        ?  PlusCode.fromJson(json['plus_code'])
        : null;
    rating = json['rating'];
    reference = json['reference'];
    types = json['types'].cast<String>();
    userRatingsTotal = json['user_ratings_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['formatted_address'] = this.formattedAddress;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['name'] = this.name;
    data['place_id'] = this.placeId;
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode.toJson();
    }
    data['rating'] = this.rating;
    data['reference'] = this.reference;
    data['types'] = this.types;
    data['user_ratings_total'] = this.userRatingsTotal;
    return data;
  }
}

class PlusCode {
  dynamic compoundCode;
  dynamic globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}

class Geometry {
  NearLocation location;
  Viewport viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ?  NearLocation.fromJson(json['location'])
        : null;
    viewport = json['viewport'] != null
        ?  Viewport.fromJson(json['viewport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport.toJson();
    }
    return data;
  }
}

class NearLocation {
  dynamic lat;
  dynamic lng;

  NearLocation({this.lat, this.lng});

  NearLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  NearLocation northeast;
  NearLocation southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ?  NearLocation.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ?  NearLocation.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest.toJson();
    }
    return data;
  }
}