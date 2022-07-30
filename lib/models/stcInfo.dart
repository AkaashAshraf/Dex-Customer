StcInfo stcInfo;

class StcInfo {
  dynamic customerGivenName;
  dynamic customerPhone;
  dynamic cartItemName;
  dynamic amount;
  dynamic customerId;
  dynamic currency;
  dynamic note;
  dynamic paymentCuse;
  dynamic errors;
  dynamic message;
  dynamic billImage;
  dynamic state;
  dynamic updatedAt;
  dynamic createdAt;
  dynamic id;
  dynamic otpReference;
  dynamic sTCPayPmtReference;

  StcInfo(
      {this.customerGivenName,
      this.customerPhone,
      this.cartItemName,
      this.amount,
      this.customerId,
      this.currency,
      this.note,
      this.paymentCuse,
      this.errors,
      this.message,
      this.billImage,
      this.state,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.otpReference,
      this.sTCPayPmtReference});

  StcInfo.fromJson(Map<dynamic, dynamic> json) {
    customerGivenName = json['customerGivenName'];
    customerPhone = json['customerPhone'];
    cartItemName = json['cartItemName'];
    amount = json['amount'];
    customerId = json['customerId'];
    currency = json['currency'];
    note = json['note'];
    paymentCuse = json['paymentCuse'];
    errors = json['errors'];
    message = json['message'];
    billImage = json['billImage'];
    state = json['state'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    otpReference = json['OtpReference'];
    sTCPayPmtReference = json['STCPayPmtReference'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['customerGivenName'] = this.customerGivenName;
    data['customerPhone'] = this.customerPhone;
    data['cartItemName'] = this.cartItemName;
    data['amount'] = this.amount;
    data['customerId'] = this.customerId;
    data['currency'] = this.currency;
    data['note'] = this.note;
    data['paymentCuse'] = this.paymentCuse;
    data['errors'] = this.errors;
    data['message'] = this.message;
    data['billImage'] = this.billImage;
    data['state'] = this.state;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['OtpReference'] = this.otpReference;
    data['STCPayPmtReference'] = this.sTCPayPmtReference;
    return data;
  }
}
