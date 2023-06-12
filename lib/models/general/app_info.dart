class AppInfo{
  int id;
  String name;
  String aboutUs;
  String colorTheme;
  String email;
  String phone;
  String whatsApp;
  String facebook;
  String insta;
  int minRequests;
  String createdAt;
  String updatedAt;
  String twitter;
  String  privacyPolicy;
  String  privacyPolicyEn;

  AppInfo(
      {this.id,
        this.name,
        this.aboutUs,
        this.colorTheme,
        this.email,
        this.phone,
        this.whatsApp,
        this.facebook,
        this.insta,
        this.minRequests,
        this.createdAt,
        this.updatedAt,
        this.twitter,
        this.privacyPolicy,
        this.privacyPolicyEn,
        });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return  AppInfo(
        id          : json['id'],
        name        : json['name'],
        aboutUs     : json['aboutUs'],
        colorTheme  : json['colorTheme'],
        email       : json['email'],
        phone       : json['phone'],
        whatsApp    : json['whatsApp'],
        facebook    : json['facebook'],
        minRequests : json['minRequests'],
        createdAt   : json['created_at'],
        updatedAt   : json['updated_at'],
        twitter     : json['twitter'],
        privacyPolicy:  json['userAgreement'],
        privacyPolicyEn:  json['UserAgreement_Eng'] == null ? '' : json['UserAgreement_Eng'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['aboutUs'] = this.aboutUs;
    data['colorTheme'] = this.colorTheme;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['whatsApp'] = this.whatsApp;
    data['facebook'] = this.facebook;
    data['minRequests'] = this.minRequests;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['twitter'] = this.twitter;
    return data;
  }
}