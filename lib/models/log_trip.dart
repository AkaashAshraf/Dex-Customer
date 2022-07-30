class LogTrip {
  int id;
  String createdAt;
  String updatedAt;
  String fromCity;
  String toCity;
  String fromCityAr;
  String toCityAr;
  String startDate;
  String startegy;
  String frequency;
  int isOn;
  int state;
  double price;
  int carType;
  List<Dates> dates;

  LogTrip(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.fromCity,
      this.toCity,
      this.fromCityAr,
      this.toCityAr,
      this.startDate,
      this.startegy,
      this.frequency,
      this.isOn,
      this.state,
      this.price,
      this.carType,
      this.dates});

  LogTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fromCity = json['fromCity'];
    toCity = json['toCity'];
    fromCityAr = json['fromCity_ar'];
    toCityAr = json['toCity_ar'];
    startDate = json['startDate'];
    startegy = json['startegy'];
    frequency = json['frequency'];
    isOn = json['isOn'];
    state = json['state'];
    price = json['price'] * 1.0;
    carType = json['carType'];
    if (json['dates'] != null) {
      dates = new List<Dates>();
      json['dates'].forEach((v) {
        dates.add(new Dates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['fromCity'] = this.fromCity;
    data['toCity'] = this.toCity;
    data['startDate'] = this.startDate;
    data['startegy'] = this.startegy;
    data['frequency'] = this.frequency;
    data['isOn'] = this.isOn;
    data['state'] = this.state;
    data['price'] = this.price;
    data['carType'] = this.carType;
    if (this.dates != null) {
      data['dates'] = this.dates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dates {
  int id;
  String createdAt;
  String updatedAt;
  int logisticTripID;
  String date;
  int priceFactore;

  Dates(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.logisticTripID,
      this.date,
      this.priceFactore});

  Dates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    logisticTripID = json['logisticTripID'];
    date = json['date'];
    priceFactore = json['priceFactore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['logisticTripID'] = this.logisticTripID;
    data['date'] = this.date;
    data['priceFactore'] = this.priceFactore;
    return data;
  }
}
