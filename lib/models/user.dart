User user;

class User {
  final int id;
  final String image;
  final String loginPhone;
  final String firstName;
  final String lastName;
  final String password;
  final double longtude;
  final double latitude;
  final int credit;
  final dynamic subscriptionDate;
  final dynamic subscriptionPackage;
  final String email;
  final String customerType;
  final String isOn;
  final String isActive;
  final String createdAt;
  final String updatedAt;
  final String city;
  final String address;
  final String rate;
  final String count;
  final String firebaseToken;
  final String licenceImage;
  final String carImage;
  final dynamic smscode;
  final dynamic smsExpireDate;
  final dynamic isVerified;
  final dynamic points;
  dynamic dexLevel;
  dynamic dexLevelAr;
  dynamic levelImg;
  dynamic minPoints;
  dynamic maxPoints;
  dynamic gainPoints;
  dynamic gainPercentage;
  dynamic pointsMinLevel;
  dynamic withdrawalLimt;

  User(
      {this.id,
      this.image,
      this.loginPhone,
      this.firstName,
      this.lastName,
      this.password,
      this.longtude,
      this.latitude,
      this.credit,
      this.subscriptionDate,
      this.subscriptionPackage,
      this.email,
      this.customerType,
      this.isOn,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.city,
      this.address,
      this.rate,
      this.count,
      this.firebaseToken,
      this.licenceImage,
      this.carImage,
      this.smscode,
      this.smsExpireDate,
      this.isVerified,
      this.points,
      this.dexLevel,
      this.dexLevelAr,
      this.levelImg,
      this.minPoints,
      this.maxPoints,
      this.gainPoints,
      this.gainPercentage,
      this.pointsMinLevel,
      this.withdrawalLimt});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        image: json['image'],
        loginPhone: json['login_phone'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        password: json['password'],
        longtude: json['longtude'],
        latitude: json['latitude'],
        credit: json['credit'],
        subscriptionDate: json['subscription_date'],
        subscriptionPackage: json['subscription_package'],
        email: json['email'],
        customerType: json['customer_type'],
        isOn: json['is_On'],
        isActive: json['is_Active'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        city: json['city'],
        address: json['address'],
        rate: json['rate'],
        count: json['count'],
        firebaseToken: json['FirebaseToken'],
        licenceImage: json['licenceImage'],
        carImage: json['CarImage'],
        smscode: json['smscode'],
        smsExpireDate: json['smsExpireDate'],
        isVerified: json['isVerified'],
        points: json['points'],
        dexLevel: json['DexLevel'] != null ? json['DexLevel']['Name'] : '',
        dexLevelAr: json['DexLevel'] != null ? json['DexLevel']['name_ar'] : '',
        levelImg: json['DexLevel'] != null ? json['DexLevel']['image'] : '',
        minPoints:
            json['DexLevel'] != null ? json['DexLevel']['levelMinPoints'] : '',
        maxPoints:
            json['DexLevel'] != null ? json['DexLevel']['levelMaxPoints'] : '',
        gainPoints:
            json['DexLevel'] != null ? json['DexLevel']['gainPoints'] : '',
        gainPercentage:
            json['DexLevel'] != null ? json['DexLevel']['gainPercentage'] : '',
        pointsMinLevel:
            json['DexLevel'] != null ? json['DexLevel']['pointsMinLevel'] : '',
        withdrawalLimt:
            json['DexLevel'] != null ? json['DexLevel']['withdrawalLimt'] : '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['login_phone'] = this.loginPhone;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['password'] = this.password;
    data['longtude'] = this.longtude;
    data['latitude'] = this.latitude;
    data['credit'] = this.credit;
    data['subscription_date'] = this.subscriptionDate;
    data['subscription_package'] = this.subscriptionPackage;
    data['email'] = this.email;
    data['customer_type'] = this.customerType;
    data['is_On'] = this.isOn;
    data['is_Active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['city'] = this.city;
    data['address'] = this.address;
    data['rate'] = this.rate;
    data['count'] = this.count;
    data['FirebaseToken'] = this.firebaseToken;
    data['licenceImage'] = this.licenceImage;
    data['CarImage'] = this.carImage;
    data['smscode'] = this.smscode;
    data['smsExpireDate'] = this.smsExpireDate;
    data['isVerified'] = this.isVerified;
    data['points'] = this.points;
    return data;
  }
}
