PaymentInformation paymentInformation;

class PaymentInformation {
  dynamic merchantPhone;
  dynamic customerGivenName;
  dynamic customerPhone;
  dynamic cartItemName;
  dynamic amount;
  dynamic merchantId;
  dynamic driverId;
  dynamic customerId;
  dynamic currency;
  dynamic note;
  dynamic paymentCuse;
  dynamic state;
  dynamic updatedAt;
  dynamic createdAt;
  dynamic id;
  dynamic hayperPayId;

  PaymentInformation(
      {merchantPhone,
      customerGivenName,
      customerPhone,
      cartItemName,
      amount,
      merchantId,
      driverId,
      customerId,
      currency,
      note,
      paymentCuse,
      state,
      updatedAt,
      createdAt,
      id,
      hayperPayId});

  PaymentInformation.fromJson(Map<dynamic, dynamic> json) {
    merchantPhone = json['merchantPhone'];
    customerGivenName = json['customerGivenName'];
    customerPhone = json['customerPhone'];
    cartItemName = json['cartItemName'];
    amount = json['amount'];
    merchantId = json['merchantId'];
    driverId = json['driverId'];
    customerId = json['customerId'];
    currency = json['currency'];
    note = json['note'];
    paymentCuse = json['paymentCuse'];
    state = json['state'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    hayperPayId = json['hayperPayId'];
  }

  Map<dynamic, dynamic> toJson() {
    final data = <dynamic, dynamic>{};
    data['merchantPhone'] = merchantPhone;
    data['customerGivenName'] = customerGivenName;
    data['customerPhone'] = customerPhone;
    data['cartItemName'] = cartItemName;
    data['amount'] = amount;
    data['merchantId'] = merchantId;
    data['driverId'] = driverId;
    data['customerId'] = customerId;
    data['currency'] = currency;
    data['note'] = note;
    data['paymentCuse'] = paymentCuse;
    data['state'] = state;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['hayperPayId'] = hayperPayId;
    return data;
  }
}

PullResponse pullResponse;

class PullResponse {
  String customerGivenName;
  String customerPhone;
  String cartItemName;
  String amount;
  String customerId;
  String currency;
  String note;
  String paymentCuse;
  String errors;
  String message;
  String state;
  String updatedAt;
  String createdAt;
  int id;

  PullResponse(
      {customerGivenName,
      customerPhone,
      cartItemName,
      amount,
      customerId,
      currency,
      note,
      paymentCuse,
      errors,
      message,
      state,
      updatedAt,
      createdAt,
      id});

  PullResponse.fromJson(Map<String, dynamic> json) {
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
    state = json['state'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['customerGivenName'] = customerGivenName;
    data['customerPhone'] = customerPhone;
    data['cartItemName'] = cartItemName;
    data['amount'] = amount;
    data['customerId'] = customerId;
    data['currency'] = currency;
    data['note'] = note;
    data['paymentCuse'] = paymentCuse;
    data['errors'] = errors;
    data['message'] = message;
    data['state'] = state;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
